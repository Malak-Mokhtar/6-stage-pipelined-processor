#	All numbers in hex format
#	We always start by reset signal
# 	This is a commented line
#	You should ignore empty lines

# ---------- Don't forget to Reset before you start anything ---------- #

.org 0
IN R5			#R5= FFFE --> add FFFE on the in port, flags no change	
INC R5,R5 		#R5 = FFFF, C--> no change, N --> 1, Z --> no change
INC R5,R5 		#R5 = 0000, C--> 1, N --> 0, Z --> 1
IN R1			#R1= 0001 --> add 0001 on the in port, flags no change	
IN R2			#R2= 000F -> add 000F on the in port, flags no change	
IN R3			#R3= 00C8 -> add 00C8 on the in port, flags no change	
NOP				#Flags no change
STD R1,00FF  	#M[1] = 00FF
STD R3,001F  	#R3 --> has value 00C8 which is 200 in decimal, hence M[200] = 001F
STD R2,00FC  	#M[15] = 00FC	
INC R2,R1 		#R2 = 0002, C--> 0, N --> 0, Z --> 0
LDD R0, R2  	#R0 = M[1] = 00FF
LDD R0, R3  	#R0 = M[200] = 001F
AND R1,R2,R5	#R1 = 0, C--> 0, N --> 0, Z --> 1
INC R1,R1 		#R1 = 0001, C--> 0, N --> 0, Z --> 0
NOP				#Flags no change
AND R3,R1,R2	#R5 = 0, C--> 0, N --> 0, Z --> 1
NOP				#Flags no change, C--> 0, N --> 0, Z --> 1
NOP
