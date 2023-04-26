
Register_Translation = {"R0": "000",
                        "R1": "001",
                        "R2": "010",
                        "R3": "011",
                        "R4": "100",
                        "R5": "101",
                        "R6": "110",
                        "R7": "111"}
# function for loading file


def load_file():

    f = open("test.asm", 'r', encoding='utf-8')
    file_lines = f.readlines()
    instructions = []
    for line in file_lines:
        if ('#' not in line):
            temp1 = line.replace("\n", "")
            instructions.append(temp1)
    print(instructions)
    return instructions


def conversion(assembly_instructions: list[str]):
    result = []

    for instruction in assembly_instructions:
        # form bit string
        temp_inst = ""
        instruction_line = instruction.split(" ")
        if instruction_line[0] == ".org":
            temp_inst = instruction_line[1]
        elif instruction_line[0] == "NOP":
            # OPCODE
            temp_inst += "00000"
            # Rs1
            temp_inst += "000"
            # Rs2
            temp_inst += "000"
            # Rd
            temp_inst += "000"
            # Default Garbage
            temp_inst += "00"
            # print
            print("NOP")
        elif instruction_line[0] == "SETC":
            # OPCODE
            temp_inst += "00001"
            # Rs1
            temp_inst += "000"
            # Rs2
            temp_inst += "000"
            # Rd
            temp_inst += "000"
            # Default Garbage
            temp_inst += "00"
            # print
            print("SETC")
        elif instruction_line[0] == "CLRC":
            # OPCODE
            temp_inst += "00010"
            # Rs1
            temp_inst += "000"
            # Rs2
            temp_inst += "000"
            # Rd
            temp_inst += "000"
            # Default Garbage
            temp_inst += "00"
            # print
            print("CLRC")
        # OUT Rs2	-> different than in project document
        elif instruction_line[0] == "OUT":
            # OPCODE
            temp_inst += "00011"
            # Rs1 (Garbage)
            temp_inst += "000"
            # Rs2
            temp_inst += Register_Translation[instruction_line[1]]
            # Rd (Garbage)
            temp_inst += "000"
            # Default Garbage
            temp_inst += "00"
            # print
            print("OUT")
        elif instruction_line[0] == "IN":
            # OPCODE
            temp_inst += "00100"
            # Rs1(Garbage)
            temp_inst += "000"
            # Rs2(Garbage)
            temp_inst += "000"
            # Rd
            temp_inst += Register_Translation[instruction_line[1]]
            # Default Garbage
            temp_inst += "00"
            # print
            print("IN")
        # MOV Rd,Rs2	-> different than in project document
        elif instruction_line[0] == "MOV":
            # getting the two registers
            registers = instruction_line[1].split(",")
            # OPCODE
            temp_inst += "00101"
            # Rs1(Garbage)
            temp_inst += "000"
            # Rs2
            temp_inst += Register_Translation[registers[1]]
            # Rd
            temp_inst += Register_Translation[registers[0]]
            # Default Garbage
            temp_inst += "00"
            # print
            print("MOV")
        elif instruction_line[0] == "IADD":
            registers = instruction_line[1].split(",")
            # OPCODE
            temp_inst += "01000"
            # Rs1
            temp_inst += Register_Translation[registers[1]]
            # Rs2
            temp_inst += "000"
            # Rd
            temp_inst += Register_Translation[registers[0]]
            # Default Garbage
            temp_inst += "00"
            # add operation to results
            result.append(temp_inst)
            # to get immediate
            temp_inst = bin(int("0x"+"F"+registers[2], 16))[6:]
            # print
            print("IADD")
        elif instruction_line[0] == "ADD":
            registers = instruction_line[1].split(",")
            # OPCODE
            temp_inst += "01001"
            # Rs1
            temp_inst += Register_Translation[registers[1]]
            # Rs2
            temp_inst += Register_Translation[registers[2]]
            # Rd
            temp_inst += Register_Translation[registers[0]]
            # Default Garbage
            temp_inst += "00"
            # print
            print("ADD")
        elif instruction_line[0] == "SUB":
            registers = instruction_line[1].split(",")
            # OPCODE
            temp_inst += "01010"
            # Rs1
            temp_inst += Register_Translation[registers[1]]
            # Rs2
            temp_inst += Register_Translation[registers[2]]
            # Rd
            temp_inst += Register_Translation[registers[0]]
            # Default Garbage
            temp_inst += "00"
            # print
            print("SUB")
        elif instruction_line[0] == "AND":
            registers = instruction_line[1].split(",")
            # OPCODE
            temp_inst += "01011"
            # Rs1
            temp_inst += Register_Translation[registers[1]]
            # Rs2
            temp_inst += Register_Translation[registers[2]]
            # Rd
            temp_inst += Register_Translation[registers[0]]
            # Default Garbage
            temp_inst += "00"
            # print
            print("AND")
        elif instruction_line[0] == "OR":
            registers = instruction_line[1].split(",")
            # OPCODE
            temp_inst += "01100"
            # Rs1
            temp_inst += Register_Translation[registers[1]]
            # Rs2
            temp_inst += Register_Translation[registers[2]]
            # Rd
            temp_inst += Register_Translation[registers[0]]
            # Default Garbage
            temp_inst += "00"
            # print
            print("OR")
        elif instruction_line[0] == "NOT":
            registers = instruction_line[1].split(",")
            # OPCODE
            temp_inst += "01101"
            # Rs1
            temp_inst += Register_Translation[registers[1]]
            # Rs2 (Garbage)
            temp_inst += "000"
            # Rd
            temp_inst += Register_Translation[registers[0]]
            # Default Garbage
            temp_inst += "00"
            # print
            print("NOT")
        elif instruction_line[0] == "INC":
            registers = instruction_line[1].split(",")
            # OPCODE
            temp_inst += "01110"
            # Rs1
            temp_inst += Register_Translation[registers[1]]
            # Rs2 (Garbage)
            temp_inst += "000"
            # Rd
            temp_inst += Register_Translation[registers[0]]
            # Default Garbage
            temp_inst += "00"
            # print
            print("INC")
        elif instruction_line[0] == "DEC":
            registers = instruction_line[1].split(",")
            # OPCODE
            temp_inst += "01111"
            # Rs1
            temp_inst += Register_Translation[registers[1]]
            # Rs2 (Garbage)
            temp_inst += "000"
            # Rd
            temp_inst += Register_Translation[registers[0]]
            # Default Garbage
            temp_inst += "00"
            # print
            print("DEC")
        elif instruction_line[0] == "LDM":
            registers = instruction_line[1].split(",")
            # OPCODE
            temp_inst += "10000"
            # Rs1 (Garbage)
            temp_inst += "000"
            # Rs2 (Garbage)
            temp_inst += "000"
            # Rd
            temp_inst += Register_Translation[registers[0]]
            # Default Garbage
            temp_inst += "00"
            # add instruction
            result.append(temp_inst)
            # to get immediate
            temp_inst = bin(int("0x"+"F"+registers[1], 16))[6:]
            # print
            print("LDM")
        # PUSH Rs2	-> different than in project document
        elif instruction_line[0] == "PUSH":
            # OPCODE
            temp_inst += "10001"
            # Rs1 (Garbage)
            temp_inst += "000"
            # Rs2
            temp_inst += Register_Translation[instruction_line[1]]
            # Rd (Garbage)
            temp_inst += "000"
            # Default Garbage
            temp_inst += "00"
            # print
            print("PUSH")
        elif instruction_line[0] == "POP":
            # OPCODE
            temp_inst += "10010"
            # Rs1 (Garbage)
            temp_inst += "000"
            # Rs2 (Garbage)
            temp_inst += "000"
            # Rd
            temp_inst += Register_Translation[instruction_line[1]]
            # Default Garbage
            temp_inst += "00"
            # print
            print("POP")
        # LDD Rd,Rs2	-> different than in project document
        elif instruction_line[0] == "LDD":
            registers = instruction_line[1].split(",")
            # OPCODE
            temp_inst += "10011"
            # Rs1 (Garbage)
            temp_inst += "000"
            # Rs2
            temp_inst += Register_Translation[registers[1]]
            # Rd
            temp_inst += Register_Translation[registers[0]]
            # Default Garbage
            temp_inst += "00"
            # print
            print("LDD")
        # STD Rs1,Rs2	-> different than in project document
        elif instruction_line[0] == "STD":
            registers = instruction_line[1].split(",")
            # OPCODE
            temp_inst += "10100"
            # Rs1
            temp_inst += Register_Translation[registers[0]]
            # Rs2
            temp_inst += Register_Translation[registers[1]]
            # Rd (Garbage)
            temp_inst += "000"
            # Default Garbage
            temp_inst += "00"
            # print
            print("STD")
        # JZ Rs1	-> different than in project document
        elif instruction_line[0] == "JZ":
            # OPCODE
            temp_inst += "11000"
            # Rs1
            temp_inst += Register_Translation[instruction_line[1]]
            # Rs2 (Garbage)
            temp_inst += "000"
            # Rd (Garbage)
            temp_inst += "000"
            # Default Garbage
            temp_inst += "00"
            # print
            print("JZ")
        # JC Rs1	-> different than in project document
        elif instruction_line[0] == "JC":
            # OPCODE
            temp_inst += "11001"
            # Rs1
            temp_inst += Register_Translation[instruction_line[1]]
            # Rs2 (Garbage)
            temp_inst += "000"
            # Rd (Garbage)
            temp_inst += "000"
            # Default Garbage
            temp_inst += "00"
            # print
            print("JC")
        # JMP Rs1	-> different than in project document
        elif instruction_line[0] == "JMP":
            # OPCODE
            temp_inst += "11010"
            # Rs1
            temp_inst += Register_Translation[instruction_line[1]]
            # Rs2
            temp_inst += "000"
            # Rd
            temp_inst += "000"
            # Default Garbage
            temp_inst += "00"
            # print
            print("JMP")
        # CALL Rs1	-> different than in project document
        elif instruction_line[0] == "CALL":
            # OPCODE
            temp_inst += "11011"
            # Rs1
            temp_inst += Register_Translation[instruction_line[1]]
            # Rs2 (Garbage)
            temp_inst += "000"
            # Rd (Garbage)
            temp_inst += "000"
            # Default Garbage
            temp_inst += "00"
            # print
            print("CALL")
        elif instruction_line[0] == "RET":
            # OPCODE
            temp_inst += "11100"
            # Rs1 (Garbage)
            temp_inst += "000"
            # Rs2 (Garbage)
            temp_inst += "000"
            # Rd (Garbage)
            temp_inst += "000"
            # Default Garbage
            temp_inst += "00"
            # print
            print("RET")
        elif instruction_line[0] == "RTI":
            # OPCODE
            temp_inst += "11101"
            # Rs1 (Garbage)
            temp_inst += "000"
            # Rs2 (Garbage)
            temp_inst += "000"
            # Rd (Garbage)
            temp_inst += "000"
            # Default Garbage
            temp_inst += "00"
            # print
            print("RTI")
        # add inst to result array
        result.append(temp_inst)
    print(result)
    return result


def mem_file_writer(res: list[str], inst: list[str]):
    f = open("Instructions.mem", "w")
    f.write(
        "// memory data file (do not edit the following line - required for mem load use)\n")
    f.write(
        "// instance=/processor/Internal_Memory_Stages/Data_memory_MAP/memory_data\n")
    f.write("// format=mti addressradix=d dataradix=s version=1.0 wordsperline=1\n")
    line_number = int(res[0], 16)
    for i in range(1, len(res)):
        # f.write("//"+inst[i]+"\n")
        f.write(str(line_number)+": "+res[i]+"\n")
        line_number += 1
    data_file = open("Data_memory.mem", "w")
    data_file.write(
        "// memory data file (do not edit the following line - required for mem load use)\n")
    data_file.write(
        "// instance=/processor/Internal_Memory_Stages/Data_memory_MAP/memory_data\n")
    data_file.write(
        "// format=mti addressradix=d dataradix=s version=1.0 wordsperline=1\n")
    data_file.write("0: " + bin(int(res[0], 16))[2:].zfill(16))


def main():
    instructions = load_file()
    res = conversion(instructions)
    test = ["0",
            "0000000000000000",
            "0000100000000000",
            "0001000000000000",
            "0110100100010000",
            "0111000100010000",
            "0111100100010000",
            "0001100011000000",
            "0010000000001000",
            "0010100000110000",
            "0100110000101100",
            "0100000100010100",
            "0000000011111111",
            "0100000100010100",
            "0000000000000000",
            "0100000100010100",
            "1010101010111010",
            "0101010000101100",
            "0110010000101100",
            "0101110000101100",
            "1000100010100000",
            "1001000000010000",
            "1000000000010000",
            "1111111111111111",
            "1001100000110000",
            "1010010000100000",
            "1100011100000000",
            "1100111100000000",
            "1101011100000000",
            "1101101100000000",
            "1110000000000000",
            "1110100000000000"]
    for i in range(0, len(res)):
        if res[i] != test[i]:
            print("or at index: " + str(i))
            print(test[i])
            print(res[i])
            print("FALSE")

    mem_file_writer(res, instructions)


main()
