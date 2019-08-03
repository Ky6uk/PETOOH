#ifndef INSTR_HPP
#define INSTR_HPP

#include <vector>

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

using InstrList = std::vector<Instr>;

#endif // INSTR_HPP
