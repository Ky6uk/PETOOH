#include <iostream>
#include <memory>
#include <sstream>
#include <string>
#include <vector>

#include <cctype>
#include <cstdint>
#include <cstdlib>
#include <cstring>

#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>

#define FOR_EACH_INSTRUCTION(MACRO)                                            \
  MACRO(INC_POS, "Kudah")                                                      \
  MACRO(DEC_POS, "kudah")                                                      \
  MACRO(INC_BYTE, "Ko")                                                        \
  MACRO(DEC_BYTE, "kO")                                                        \
  MACRO(OUTPUT, "Kukarek")                                                     \
  MACRO(LOOP_START, "Kud")                                                     \
  MACRO(LOOP_END, "kud")

enum class Instr {
#define CREATE_INSTR(INSTR, _) INSTR,
  FOR_EACH_INSTRUCTION(CREATE_INSTR)
#undef CREATE_INSTR
      UNKNOWN = -1
};

// Algorithm correctness depends on the instruction order
// in FOR_EACH_INSTRUCTION macro:
// an instruction that is a prefix of another one must not be located first.
Instr takeInstr(std::string const &line, size_t &startPos) {
#define CHECK_INSTR(INSTR, STR)                                                \
  {                                                                            \
    size_t const instrLen = strlen(STR);                                       \
    if (startPos + instrLen <= line.size() &&                                  \
        line.compare(startPos, instrLen, STR) == 0) {                          \
      startPos += instrLen;                                                    \
      return Instr::INSTR;                                                     \
    }                                                                          \
  }
  FOR_EACH_INSTRUCTION(CHECK_INSTR)
#undef CHECK_INSTR
  return Instr::UNKNOWN;
}

#undef FOR_EACH_INSTRUCTION

struct InstrToken {
  Instr instr;
  size_t lineIdx;
  size_t firstCharIdx;
};

using InstrList = std::vector<Instr>;
using InstrTokenList = std::vector<InstrToken>;

void showErrorMessageAndExit(std::string const &errorMessage) {
  std::cerr << errorMessage << std::endl;
  exit(EXIT_FAILURE);
}

bool isIgnored(char const chr) { return isspace(chr) || chr == '-'; }

std::string const formatCharPosition(size_t const lineIdx,
                                     size_t const chrIdx) {
  return std::to_string(lineIdx + 1) + ":" + std::to_string(chrIdx + 1);
}

InstrTokenList const readInstructions(std::istream &in) {
  InstrTokenList tokens;

  size_t lineIdx = 0;
  std::string line;
  while (std::getline(in, line)) {
    size_t chrIdx = 0;
    while (chrIdx < line.size()) {
      char const chr = line[chrIdx];
      if (isIgnored(chr)) {
        ++chrIdx;
        continue;
      }

      Instr const instr = takeInstr(line, chrIdx); // changes chrIdx
      if (instr == Instr::UNKNOWN) {
        showErrorMessageAndExit("Illegal character at line " +
                                formatCharPosition(lineIdx, chrIdx));
      }

      tokens.push_back({instr, lineIdx, chrIdx});
    }

    ++lineIdx;
  }

  return tokens;
}

std::string const createLoopsErrorMessage(InstrTokenList const &unclosedLoops,
                                          InstrTokenList const &unopenedLoops) {
  std::ostringstream errStream;
  for (auto const &token : unopenedLoops) {
    errStream << "Unopened loop at line "
              << formatCharPosition(token.lineIdx, token.firstCharIdx) << '\n';
  }
  for (size_t i = 0; i < unclosedLoops.size(); ++i) {
    if (i > 0) {
      errStream << '\n';
    }
    InstrToken const &token = unclosedLoops[i];
    errStream << "Unclosed loop at line "
              << formatCharPosition(token.lineIdx, token.firstCharIdx);
  }
  return errStream.str();
}

void checkLoops(InstrTokenList const &instrTokens) {
  InstrTokenList unclosedLoops;
  InstrTokenList unopenedLoops;
  for (auto const &token : instrTokens) {
    switch (token.instr) {
    case Instr::LOOP_START:
      unclosedLoops.push_back(token);
      break;
    case Instr::LOOP_END:
      if (unclosedLoops.empty()) {
        unopenedLoops.push_back(token);
      } else {
        unclosedLoops.pop_back();
      }
      break;
    default:
      break;
    }
  }

  if (unclosedLoops.empty() && unopenedLoops.empty()) {
    return;
  }

  showErrorMessageAndExit(
      createLoopsErrorMessage(unclosedLoops, unopenedLoops));
}

std::unique_ptr<llvm::Module> createMainLlvmModule(uint64_t const byteCount,
                                                   InstrList const &instrs) {
  llvm::LLVMContext &ctx = llvm::getGlobalContext();
  auto module(std::make_unique<llvm::Module>("main", ctx));
  llvm::IRBuilder<> builder(ctx);

  // Useful constants
  auto *const i8 = builder.getInt8Ty();
  auto *const i32 = builder.getInt32Ty();
  auto *const i64 = builder.getInt64Ty();

  auto *const zeroI64 = llvm::ConstantInt::get(i64, 0);

  auto *const oneI8 = llvm::ConstantInt::get(i8, 1);
  auto *const oneI64 = llvm::ConstantInt::get(i64, 1);

  // Allocate program memory
  auto *const arrayType = llvm::ArrayType::get(i8, byteCount);
  auto *const initializer = llvm::ConstantAggregateZero::get(arrayType);
  auto *const bytes = new llvm::GlobalVariable(
      *module, arrayType, false, llvm::GlobalVariable::CommonLinkage,
      initializer, "bytes");

  // Declare putchar function
  auto *const putcharType = llvm::FunctionType::get(i32, {i32}, false);
  auto *const putcharFunc = module->getOrInsertFunction(
      "putchar", putcharType);

  // Create main function
  auto *const mainType = llvm::FunctionType::get(i32, false);
  auto *const mainFunc = llvm::Function::Create(
      mainType, llvm::Function::ExternalLinkage, "main", module.get());
  auto *const entry = llvm::BasicBlock::Create(ctx, "entry", mainFunc);
  builder.SetInsertPoint(entry);

  // Current position
  auto *const pos = builder.CreateAlloca(i64, nullptr, "pos");
  builder.CreateStore(zeroI64, pos);

  for (auto const instr : instrs) {
    switch (instr) {
    case Instr::INC_POS: {
      auto *const posVal = builder.CreateLoad(pos);
      builder.CreateStore(builder.CreateAdd(posVal, oneI64), pos);
    } break;
    case Instr::DEC_POS: {
      auto *const posVal = builder.CreateLoad(pos);
      builder.CreateStore(builder.CreateSub(posVal, oneI64), pos);
    } break;
    case Instr::INC_BYTE: {
      auto *const posVal = builder.CreateLoad(pos);
      auto *const byte = builder.CreateInBoundsGEP(bytes, {zeroI64, posVal});
      auto *const byteVal = builder.CreateLoad(byte);
      builder.CreateStore(builder.CreateAdd(byteVal, oneI8), byte);
    } break;
    case Instr::DEC_BYTE: {
      auto *const posVal = builder.CreateLoad(pos);
      auto *const byte = builder.CreateInBoundsGEP(bytes, {zeroI64, posVal});
      auto *const byteVal = builder.CreateLoad(byte);
      builder.CreateStore(builder.CreateSub(byteVal, oneI8), byte);
    } break;
    case Instr::OUTPUT: {
      auto *const posVal = builder.CreateLoad(pos);
      auto *const byte = builder.CreateInBoundsGEP(bytes, {zeroI64, posVal});
      auto *const byteVal = builder.CreateLoad(byte);
      auto *const intVal = builder.CreateIntCast(byteVal, i32, false);
      builder.CreateCall(putcharFunc, {intVal});
    } break;
    case Instr::LOOP_START:
      break;
    case Instr::LOOP_END:
      break;
    }
  }

  builder.CreateRet(llvm::ConstantInt::get(i32, 0));

  return module;
}

int main(int argc, char *argv[]) {
  InstrList instrs = {Instr::INC_BYTE, Instr::OUTPUT};
  auto const module(createMainLlvmModule(30000, instrs));
  module->dump();

  return 0;
}
