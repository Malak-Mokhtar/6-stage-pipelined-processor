#########################################################
#        All numbers are in hex format   				#
#        We always start by reset signal 				#
#########################################################
#         This is a commented line
#        You should ignore empty lines and commented ones
# ---------- Don't forget to Reset before you start anything ---------- #
.org 0
100
.org 1
20
#test case 1
.org 100
INC R0
INC R0
LDM R2,09
DEC R0
ADD R3,R2,R0
IADD R4,R2,FF00
IN R1
MOV R4,R1
OR R5,R4,R2
OUT R4
#test case 3, load use test
PUSH R1
POP R7
AND R1,R5,R7
OR R2,R1,R7
#test case 4, structural hazard with data hazard
STD R0,R4
LDD R6,R0
STD R3,R6
SUB R5,R6,R3
NOP
NOP