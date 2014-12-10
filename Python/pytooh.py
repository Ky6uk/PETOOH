from sys import stdout, argv
_tst = """
 KoKoKoKoKoKoKoKoKoKo Kud-Kudah KoKoKoKoKoKoKoKo kudah kO kud-Kudah Kukarek
kudah KoKoKo Kud-Kudah kOkOkOkO kudah kO kud-Kudah Ko Kukarek
kudah KoKoKoKo Kud-Kudah KoKoKoKo kudah kO kud-Kudah kO Kukarek
kOkOkOkOkO Kukarek Kukarek
kOkOkOkOkOkOkO Kukarek
"""
comands = ['Kudah', 'kudah', 'Ko', 'kO', 'Kukarek', 'Kud', 'kud']

def parse(line):
    tst = ''.join([c for c in line if c in 'adehkKoOru'])
    # print(tst)
    coms = []
    # char = ''
    instruction = ''
    temp =''
    for char in tst:
        temp = instruction+char
        if temp == 'Ko':
            coms.append(temp)
            instruction=''
        elif temp == 'kO':
            coms.append(temp)
            instruction=''
        elif temp == 'Kudah':
            coms.append(temp)
            instruction=''
        elif temp == 'kudah':
            coms.append(temp)
            instruction=''
        elif instruction == 'Kud' and char!='a':
            coms.append(instruction)
            instruction = char
        elif instruction == 'kud' and char!='a':
            coms.append(instruction)
            instruction = char
        elif temp=='Kukarek':
            coms.append(temp)
            instruction = ''
        else:
            instruction+=char
    return coms


    return tst
    for com in comands:
        tst = tst.replace(com, com+' ')
    return tst.split()



def block(code):
    opened = []
    blocks = {}
    for i in range(len(code)):
        if code[i] == 'Kud':
            opened.append(i)
        elif code[i] == 'kud':
            blocks[i] = opened[-1]
            blocks[opened.pop()] = i
    return blocks

def run(code):
    code = parse(code)
    # print(code)
    x = i = 0
    mem = {0: 0}
    blocks = block(code)
    l = len(code)
    while i < l:
        com = code[i]
        if com == 'Ko':  # +
            mem[x] += 1
        elif com == 'kO':  # -
            mem[x] -= 1
        elif com == 'Kudah':  # >
            x += 1
            mem.setdefault(x, 0)
        elif com == 'kudah':  # <
            x -= 1
        elif com == 'Kukarek':  # .
            stdout.write(chr(mem[x]))
        elif com == 'Kud':  #[
            if not mem[x]:
                i = blocks[i]
        elif com == 'kud':  # ]
            if mem[x]:
                i = blocks[i]
        i += 1
        # print(i)

if __name__ == '__main__':
    inf = open(argv[1], 'r')
    run(inf.read())