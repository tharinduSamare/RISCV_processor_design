addi x3 x0 1 
addi x4 x0 1	# i
addi x5 x0 5    # value of n
addi x6 x5 1	# value of n+1
jal x0 LOOP 

LOOP:	
    beq x4 x6 EXIT  
    mul x3 x3 x4    
    addi x4 x4 1    
    jal x0 LOOP     
	 
EXIT:	# FALL_THRU #36
sw x3 0(x0)