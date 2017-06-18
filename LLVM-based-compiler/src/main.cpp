#include "input.hpp"
#include "ir.hpp"

#include <iostream>

int main(int argc, char *argv[]) {
  InstrList instrs(readAndCheckInstructions(std::cin));
  auto const module(createMainLlvmModule(30000, instrs));
  module->dump();

  return 0;
}
