#!python3
import subprocess, os, sys

VALID_CHARS = "adehkKoOru"

OP_INC, OP_DEC, OP_INCPTR, OP_DECPTR, OP_OUT, OP_JMP, OP_RET = range(7)
COMMANDS = ['Ko', 'kO', 'Kudah', 'kudah', 'Kukarek', 'Kud', 'kud']

def parse(code):
    code = filter(VALID_CHARS.__contains__, code)

    commands = []
    command, buffer = "", ""

    for c in code:
        buffer = command + c

        if command in (COMMANDS[OP_JMP], COMMANDS[OP_RET]) and c != 'a':
            commands.append(command)
            command = c
        elif buffer in COMMANDS and buffer not in (COMMANDS[OP_JMP], COMMANDS[OP_RET]):
            commands.append(buffer)
            command = ""
        else:
            command += c

    return commands

def main():
    incCount, decCount = 0, 0 #kokoptimisation of KoKokOkO
    whileIds = []
    whileId = 0

    command = ""
    inputFileName = sys.argv[1]
    # temp *.asm file
    tempFileName = inputFileName[0:-5]+".asm"

    inputFile = open(inputFileName)
    tempFile = open(tempFileName,'w')

    def append(s):
        tempFile.write(s+'\n')

    # exe file head
    append('''
    format PE console
    entry start
    include 'win32a.inc'

    section '.data' data readable writeable
    outv db 0
    nll db 0; null terminator for string

    section '.data?' data readable writeable
    mem rb 65535

    section '.code' code readable executable
    start:
    mov esi, mem
    add esi, 32767
    ''')

    for command in parse(inputFile.read()):

        if incCount != 0 and command != COMMANDS[OP_INC]:
            append('add byte [esi], '+str(incCount))
            incCount = 0
        elif decCount != 0 and command != COMMANDS[OP_DEC]:
            append('sub byte [esi], '+str(decCount))
            decCount = 0


        if command == COMMANDS[OP_INC]:
            incCount += 1

        elif command == COMMANDS[OP_DEC]:
            decCount += 1

        # Input available only in PETOOH Enterprise Edition
        #elif command == ',':
        #    append('ccall [getchar]')
        #    append('mov byte [esi], al')

        elif command == COMMANDS[OP_OUT]:
            append('mov ah, byte [esi]')
            append('mov [outv], ah')
            append('ccall [printf], outv')

        elif command == COMMANDS[OP_JMP]:
            whileId+=1
            whileIds.append(whileId)
            s = 'while_kokokopen_'+str(whileId)+''':
                cmp byte [esi], 0
                je while_kokoklose_'''+str(whileId)
            append(s)

        elif command == COMMANDS[OP_RET]:
            wid = whileIds.pop()
            append('jmp while_kokokopen_'+str(wid))
            append('while_kokoklose_'+str(wid)+':')

        elif command == COMMANDS[OP_DECPTR]:
            append('add esi, 1')

        elif command == COMMANDS[OP_INCPTR]:
            append('sub esi, 1')

    # end of exe file
    append('''

    ccall   [getchar]
    stdcall [ExitProcess],0
    ;====================================
    section '.idata' import data readable
    ;====================================

    library kernel,'kernel32.dll',\
        msvcrt,'msvcrt.dll'

    import  kernel,\
        ExitProcess,'ExitProcess'

    import  msvcrt,\
        printf,'printf',\
        getchar,'_getch'
    ''')

    inputFile.close()
    tempFile.close()

    # put env vars
    if len(sys.argv) == 3:
        os.putenv('include', sys.argv[2]+"/INCLUDE")   # 'D:/bf/FASM/INCLUDE'
        os.putenv('PATH', sys.argv[2]+"/")   # 'D:/bf/FASM', folder with fasm.exe

    try:
        subprocess.call(["fasm.exe", tempFileName])
    except Exception as e:
        print("Can't run fasm.exe")
        print(e)

    
if __name__ == "__main__":
    if len(sys.argv) in (2, 3):
        main()
    else:
        print("\n    USAGE: petoohc.py /path/to/file.koko [/path/to/fasm]")
