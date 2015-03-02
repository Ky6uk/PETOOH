import sys
from collections import defaultdict


class Interpreter(object):

    OP_INC = "Ko"
    OP_DEC = "kO"
    OP_INCPTR = "Kudah"
    OP_DECPTR = "kudah"
    OP_OUT = "Kukarek"
    OP_JMP = "Kud"
    OP_RET = "kud"
    VALID_CHARS = "adehkKoOru"
    MAX_MEM = 65535

    def __init__(self, maxmem=MAX_MEM):
        self.cells, self.cellptr = [0]*maxmem, 0
        self.stack, self.level = defaultdict(list), 0

    def _push(self, instruction):
        self.stack[self.level].append(instruction)

    def _loop(self):
        while self.cells[self.cellptr] > 0:
            for instruction in self.stack[self.level]:
                if instruction == self.OP_INC: self.cells[self.cellptr] += 1
                elif instruction == self.OP_DEC: self.cells[self.cellptr] -= 1
                elif instruction == self.OP_INCPTR: self.cellptr += 1
                elif instruction == self.OP_DECPTR: self.cellptr -= 1
                elif instruction == self.OP_OUT: sys.stdout.write(chr(self.cells[self.cellptr]))

    def evaluate(self, code):
        code = filter(self.VALID_CHARS.__contains__, code)
        buffer = ''

        try:
            for char in code:
                instruction = buffer + char

                if instruction == self.OP_INC:
                    buffer = ''
                    if self.level > 0:
                        self._push(instruction)
                    else:
                        self.cells[self.cellptr] += 1
                elif instruction == self.OP_DEC:
                    buffer = ''
                    if self.level > 0:
                        self._push(instruction)
                    else:
                        self.cells[self.cellptr] -= 1
                elif instruction == self.OP_INCPTR:
                    buffer = ''
                    if self.level > 0:
                        self._push(instruction)
                    else:
                        self.cellptr += 1
                elif instruction == self.OP_DECPTR:
                    buffer = ''
                    if self.level > 0:
                        self._push(instruction)
                    else:
                        self.cellptr -= 1
                elif buffer == self.OP_JMP and char != 'a':
                    buffer = char
                    self.level += 1
                    self.stack[self.level] = []
                elif buffer == self.OP_RET and char != 'a':
                    buffer = char
                    self._loop()
                    self.level -= 1
                elif instruction == self.OP_OUT:
                    buffer = ''
                    if self.level > 0:
                        self._push(instruction)
                    else:
                        sys.stdout.write(chr(self.cells[self.cellptr]))
                else:
                    buffer += char
        except IndexError:
            print "[Error] Segmentation fault at address 0x%08x (maxmem = %s)" % (self.cellptr, len(self.cells))


if __name__ == "__main__":
    if len(sys.argv) == 2:
        try:
            with open(sys.argv[1], "r") as f:
                interpreter = Interpreter()
                interpreter.evaluate(f.read())
        except IOError as e:
            print e
    else:
        print "\n    USAGE: %s /path/to/file.koko" % sys.argv[0]