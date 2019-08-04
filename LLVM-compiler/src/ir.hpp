#ifndef IR_HPP
#define IR_HPP

#include "instr.hpp"

#include <memory>

#include <llvm/IR/Module.h>

std::unique_ptr<llvm::Module> createMainLlvmModule(uint64_t const byteCount,
                                                   InstrList const &instrs);

#endif // IR_HPP
