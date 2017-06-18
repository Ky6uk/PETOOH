#ifndef INPUT_HPP
#define INPUT_HPP

#include "instr.hpp"

#include <iostream>

// Exits the program if something goes wrong
InstrList const readAndCheckInstructions(std::istream &in);

#endif // INPUT_HPP
