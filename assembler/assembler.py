
# function for loading file
def load_file():

    f = open("TestcasesPhaseOne.asm", 'r', encoding='utf-8')
    file_lines = f.readlines()
    instructions = []
    for line in file_lines:
        if ('#' not in line):
            temp1 = line.replace("\n", "")
            instructions.append(temp1)
    print(instructions)
    return instructions


def conversion(assembly_instructions: list[str]):

    for instruction in assembly_instructions:
        instruction_line = instruction.split(" ")
