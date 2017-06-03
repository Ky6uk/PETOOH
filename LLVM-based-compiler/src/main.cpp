#include <iostream>
#include <string>


#define FOR_EACH_INSTRUCTION(MACRO) \
    MACRO(INC_POS, "Kudah") \
    MACRO(DEC_POS, "kudah") \
    MACRO(INC_BYTE, "Ko") \
    MACRO(DEC_BYTE, "kO") \
    MACRO(OUTPUT, "Kukarek") \
    MACRO(LOOP_START, "Kud") \
    MACRO(LOOP_END, "kud")

enum class Instr
{
#define CREATE_INSTR(INSTR, _) \
    INSTR,
    FOR_EACH_INSTRUCTION(CREATE_INSTR)
#undef CREATE_INSTR
    UNKNOWN = -1
};


Instr toInstr(std::string const &str)
{
#define CHECK_INSTR(INSTR, STR) \
    if (str == STR) return Instr::INSTR;
    FOR_EACH_INSTRUCTION(CHECK_INSTR)
#undef CHECK_INSTR
    return Instr::UNKNOWN;
}

#undef FOR_EACH_INSTRUCTION


int main(int argc, char *argv[])
{
    if (argc <= 1) {
        return 0;
    }

    for (int i = 1; i < argc; ++i) {
        std::cout << static_cast<int>(toInstr(argv[i])) << "\n";
    }

    return 0;
}
