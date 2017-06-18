#include "ir.hpp"

#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>

std::unique_ptr<llvm::Module> createMainLlvmModule(uint64_t const byteCount,
                                                   InstrList const &instrs) {
  llvm::LLVMContext &ctx = llvm::getGlobalContext();
  auto module(std::make_unique<llvm::Module>("main", ctx));
  llvm::IRBuilder<> builder(ctx);

  // Useful constants
  auto *const i8 = builder.getInt8Ty();
  auto *const i32 = builder.getInt32Ty();
  auto *const i64 = builder.getInt64Ty();

  auto *const zeroI8 = llvm::ConstantInt::get(i8, 0);
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
  auto *const putcharFunc = module->getOrInsertFunction("putchar", putcharType);

  // Create main function
  auto *const mainType = llvm::FunctionType::get(i32, false);
  auto *const mainFunc = llvm::Function::Create(
      mainType, llvm::Function::ExternalLinkage, "main", module.get());
  auto *const entry = llvm::BasicBlock::Create(ctx, "entry", mainFunc);
  builder.SetInsertPoint(entry);

  // Current position
  auto *const pos = builder.CreateAlloca(i64, nullptr, "pos");
  builder.CreateStore(zeroI64, pos);

  std::vector<std::pair<llvm::BasicBlock *, llvm::BasicBlock *>> loopEnds;
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
    case Instr::LOOP_START: {
      auto *const start = llvm::BasicBlock::Create(ctx, "", mainFunc);
      auto *const body = llvm::BasicBlock::Create(ctx, "", mainFunc);
      loopEnds.emplace_back(start, body);

      builder.CreateBr(start);

      builder.SetInsertPoint(body);
    } break;
    case Instr::LOOP_END: {
      auto *const start = loopEnds.back().first;
      auto *const body = loopEnds.back().second;
      auto *const end = llvm::BasicBlock::Create(ctx, "", mainFunc);
      loopEnds.pop_back();

      builder.CreateBr(start);

      builder.SetInsertPoint(start);
      auto *const posVal = builder.CreateLoad(pos);
      auto *const byte = builder.CreateInBoundsGEP(bytes, {zeroI64, posVal});
      auto *const byteVal = builder.CreateLoad(byte);
      auto *const cond = builder.CreateICmpEQ(byteVal, zeroI8);
      builder.CreateCondBr(cond, end, body);

      builder.SetInsertPoint(end);
    } break;
    }
  }

  builder.CreateRet(llvm::ConstantInt::get(i32, 0));

  return module;
}
