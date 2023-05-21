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
#test1  JC taken
.org 100
SETC
LDM R1,0F0F
LDM R3,80
NOT R2,R1
JC R3
OUT R3
#test2 JC not taken, JZ taken
.org 80
LDM R3,150
JC R3
LDM R4,08
AND R5,R3,R4
JZ R4
INC R4
.org 8
PUSH R3
POP R5
JMP R5
INC R5
#test4 call 
.org 150
SETC
LDM R1,200
CALL R1
NOT R1
OUT R1
#test 4 continue
#INTERRUPT IS RAISED
.org 200
LDM R1,400
RET
CLRC
OUT R1
#test INTERRUPT
.org 20
CLRC
LDM R7,300
OUT R7
RTI
INC R2