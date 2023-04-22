
def main():

    f = open("TestcasesPhaseOne.asm", 'r', encoding='utf-8')
    file_lines = f.readlines()
    instructions = []
    for line in file_lines:
        if ('#' not in line):
            temp1 = line.replace("\n", "")
            instructions.append(temp1)
    print(instructions)


main()
