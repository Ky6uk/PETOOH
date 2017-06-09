#include <iostream>
#include <sstream>
#include <string>
#include <vector>

#include <cctype>
#include <cstdlib>
#include <cstring>

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

int main(int argc, char *argv[]) {
  InstrTokenList instrTokens(readInstructions(std::cin));
  for (auto const &token : instrTokens) {
    std::cout << static_cast<int>(token.instr) << " " << token.lineIdx << " "
              << token.firstCharIdx << "\n";
  }
  checkLoops(instrTokens);

  return 0;
}
