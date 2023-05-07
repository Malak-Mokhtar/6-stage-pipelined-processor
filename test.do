vsim work.processor
add wave -position insertpoint  \
sim:/processor/clk
# rising
#force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
#falling
force -freeze sim:/processor/clk 0 0, 1 {50 ps} -r 100
add wave -position insertpoint  \
sim:/processor/rst
mem load -filltype value -filldata 0000100000000000 -fillradix symbolic /processor/Internal_Fetch_Stage/Internal_Instruction_Memory/instruction_cache(0)
mem load -filltype value -filldata {0001000000000000 } -fillradix symbolic /processor/Internal_Fetch_Stage/Internal_Instruction_Memory/instruction_cache(1)
mem load -filltype value -filldata 0000000000000000 -fillradix symbolic /processor/Internal_Memory_Stages/Data_memory_MAP/memory_data(0)
#####
add wave -position insertpoint  \
sim:/processor/Internal_Fetch_Stage/Inst
add wave -position insertpoint  \
sim:/processor/Internal_FD_Register/FD_Inst_out
add wave -position insertpoint  \
sim:/processor/Internal_Fetch_Stage/IN_PC
add wave -position insertpoint  \
sim:/processor/Internal_Decode_Stage/Add_Value_sig
add wave -position insertpoint  \
sim:/processor/Internal_Decode_Stage/PC_Added_sig
add wave -position insertpoint  \
sim:/processor/Internal_Decode_Stage/IN_PC
add wave -position insertpoint  \
sim:/processor/Internal_Decode_Stage/Adder_MAP/FD_Read_Address_out
add wave -position insertpoint  \
sim:/processor/Internal_FD_Register/FD_Read_Address_out
add wave -position insertpoint  \
sim:/processor/Internal_FD_Register/Read_Address
add wave -position insertpoint  \
sim:/processor/Internal_FD_Register/en
add wave -position insertpoint  \
sim:/processor/Internal_FD_Register/pipelined_rst
add wave -position insertpoint  \
sim:/processor/Internal_Fetch_Stage/Read_Address
add wave -position insertpoint  \
sim:/processor/Internal_FD_Register/Zero_rst
add wave -position insertpoint  \
sim:/processor/Internal_FD_Register/Carry_rst
add wave -position insertpoint  \
sim:/processor/Internal_FD_Register/RET_rst
add wave -position insertpoint  \
sim:/processor/Internal_FD_Register/DE_Interrupt_en_out
add wave -position insertpoint  \
sim:/processor/Internal_FD_Register/CF_OUT
add wave -position insertpoint  \
sim:/processor/Internal_FD_Register/DE_JZ_en_out
add wave -position insertpoint  \
sim:/processor/Internal_FD_Register/DE_JC_en_out
add wave -position insertpoint  \
sim:/processor/Internal_FD_Register/CF_OUT
add wave -position insertpoint  \
sim:/processor/Internal_FD_Register/DE_RET_en_out \
sim:/processor/Internal_FD_Register/EM_RET_en_out \
sim:/processor/Internal_FD_Register/MM_RET_en_out
add wave -position insertpoint  \
sim:/processor/Internal_Decode_Stage/MUX_DEC_PC_MAP/sel1
add wave -position insertpoint  \
sim:/processor/Internal_Decode_Stage/MUX_DEC_PC_MAP/sel0
add wave -position insertpoint  \
sim:/processor/Internal_DE_Register/Interrupt_en
add wave -position insertpoint  \
sim:/processor/Internal_Decode_Stage/Interrupt_en
#####
add wave -position insertpoint  \
sim:/processor/Internal_Decode_Stage/Control_Unit_MAP/OPCODE
add wave -position insertpoint  \
sim:/processor/Internal_Decode_Stage/Control_Unit_MAP/Carry_en
add wave -position insertpoint  \
sim:/processor/CLRC_en
add wave -position insertpoint  \
sim:/processor/Internal_Decode_Stage/Control_Unit_MAP/SETC_en
add wave -position insertpoint  \
sim:/processor/Internal_Execute_Stage/CF_MAP/CF_OUT
force -freeze sim:/processor/rst 1 0
run
force -freeze sim:/processor/rst 0 0
run
run
run
run
run