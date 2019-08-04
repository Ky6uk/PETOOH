#include "ir.hpp"

#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>

namespace {
llvm::LLVMContext LLVM_CTX;

llvm::IntegerType *const I8 = llvm::Type::getInt8Ty(LLVM_CTX);
llvm::IntegerType *const I32 = llvm::Type::getInt32Ty(LLVM_CTX);
llvm::IntegerType *const I64 = llvm::Type::getInt64Ty(LLVM_CTX);

llvm::ConstantInt *const ZERO_I8 = llvm::ConstantInt::get(I8, 0);
llvm::ConstantInt *const ZERO_I64 = llvm::ConstantInt::get(I64, 0);
llvm::ConstantInt *const ONE_I8 = llvm::ConstantInt::get(I8, 1);
llvm::ConstantInt *const MINUS_ONE_I8 = llvm::ConstantInt::get(I8, -1);
llvm::ConstantInt *const ONE_I64 = llvm::ConstantInt::get(I64, 1);
llvm::ConstantInt *const MINUS_ONE_I64 = llvm::ConstantInt::get(I64, -1);

llvm::GlobalVariable *allocateBytes(uint64_t const byteCount,
                                    llvm::Module &module) {
  auto *const arrayType = llvm::ArrayType::get(I8, byteCount);
  auto *const initializer = llvm::ConstantAggregateZero::get(arrayType);
  return new llvm::GlobalVariable(module, arrayType, false,
                                  llvm::GlobalVariable::CommonLinkage,
                                  initializer, "bytes");
}

llvm::Constant *declarePutchar(llvm::Module &module) {
  auto *const putcharType = llvm::FunctionType::get(I32, {I32}, false);
  return module.getOrInsertFunction("putchar", putcharType);
}

llvm::Function *createMain(llvm::Module &module) {
  auto *const mainType = llvm::FunctionType::get(I32, false);
  return llvm::Function::Create(mainType, llvm::Function::ExternalLinkage,
                                "main", &module);
}
}

std::unique_ptr<llvm::Module> createMainLlvmModule(uint64_t const byteCount,
                                                   InstrList const &instrs) {
  auto module(std::make_unique<llvm::Module>("main", LLVM_CTX));

  // Globals
  auto *const bytes = allocateBytes(byteCount, *module);
  auto *const putcharFunc = declarePutchar(*module);
  auto *const mainFunc = createMain(*module);

  // Generate body of main function
  llvm::IRBuilder<> builder(LLVM_CTX);

  auto *const entry = llvm::BasicBlock::Create(LLVM_CTX, "entry", mainFunc);
  builder.SetInsertPoint(entry);

  auto *const pos = builder.CreateAlloca(I64, nullptr, "pos");
  builder.CreateStore(ZERO_I64, pos);

  auto const loadPos([&]() { return builder.CreateLoad(pos); });
  auto const getByte([&]() {
    return builder.CreateInBoundsGEP(bytes, {ZERO_I64, loadPos()});
  });
  auto const loadByte([&]() { return builder.CreateLoad(getByte()); });

  auto const movePos([&](llvm::Value *const shift) {
    builder.CreateStore(builder.CreateAdd(loadPos(), shift), pos);
  });

  auto const changeByte([&](llvm::Value *const inc) {
    auto *const byte = getByte();
    auto *const byteVal = builder.CreateLoad(byte);
    builder.CreateStore(builder.CreateAdd(byteVal, inc), byte);
  });

  std::vector<std::pair<llvm::BasicBlock *, llvm::BasicBlock *>> loopStarts;
  for (auto const instr : instrs) {
    switch (instr) {
    case Instr::INC_POS:
      movePos(ONE_I64);
      break;
    case Instr::DEC_POS:
      movePos(MINUS_ONE_I64);
      break;
    case Instr::INC_BYTE:
      changeByte(ONE_I8);
      break;
    case Instr::DEC_BYTE:
      changeByte(MINUS_ONE_I8);
      break;
    case Instr::OUTPUT: {
      auto *const intVal = builder.CreateIntCast(loadByte(), I32, false);
      builder.CreateCall(putcharFunc, {intVal});
    } break;
    case Instr::LOOP_START: {
      auto *const start = llvm::BasicBlock::Create(LLVM_CTX, "", mainFunc);
      auto *const body = llvm::BasicBlock::Create(LLVM_CTX, "", mainFunc);
      loopStarts.emplace_back(start, body);

      builder.CreateBr(start);
      builder.SetInsertPoint(body);
    } break;
    case Instr::LOOP_END: {
      llvm::BasicBlock *const start = loopStarts.back().first;
      llvm::BasicBlock *const body = loopStarts.back().second;
      loopStarts.pop_back();
      auto *const end = llvm::BasicBlock::Create(LLVM_CTX, "", mainFunc);

      builder.CreateBr(start);
      builder.SetInsertPoint(start);
      auto *const cond = builder.CreateICmpEQ(loadByte(), ZERO_I8);
      builder.CreateCondBr(cond, end, body);
      builder.SetInsertPoint(end);
    } break;
    }
  }

  builder.CreateRet(llvm::ConstantInt::get(I32, 0));

  return module;
}
