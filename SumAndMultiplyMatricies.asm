# Equation: (rownum * totalcol + colnum) * dataSize

.macro print_str (%str)
.data
label: .asciiz %str
.text
li $v0, 4
la $a0, label
syscall
.end_macro

.data 
arrOne: 
	.word 2,1,9,2
	.word 7,9,10,10
	.word 3,4,4,4
	.word 2,5,4,4
	
arrTwo:
	.word 8,7,1,2 
	.word 2,7,8,6
	.word 7,5,6,8
	.word 9,4,8,9
	
arrRes:
	.word 0,0,0,0 
	.word 0,0,0,0
	.word 0,0,0,0
	.word 0,0,0,0
	
size: 	.word 4  #dimension of the array (2x2 in this case, note this is only for square matrices)
.eqv DATA_SIZE 4 # number of bytes per element, 4 for ints, 1 for chars, 8 for doubles

.text
main:
	lw $a1, size # size
	
	jal sumMatrix  
	print_str("Sum Row Matrix \n")
	jal printMatrix
	
	jal sumColMatrix  
	print_str("Sum Column Matrix \n")
	jal printMatrix
	
	jal productMatrix  
	print_str("Product Row Matrix \n")
	jal printMatrix
	
	jal productColMatrix  
	print_str("Product Column Matrix \n")
	jal printMatrix
	
	#exit
	li $v0, 10
	syscall
	
sumMatrix:	
	li $t0,0 #t0 as the x index

	xSumLoop:
		li $v0,0 #sum = 0
		li $t1,0 #t1 as the y index
		ySumLoop:
			mul $t3, $t0, $a1 #t3 = x index * size
			add $t3, $t3, $t1 #t3 = t3 + y index
			mul $t3, $t3, DATA_SIZE #t3 = t3 * datasize
			
			lw $t4, arrOne($t3)  #getting element arrOne
			lw $t5, arrTwo($t3)  #getting element arrTwo
			
			add $v0, $t4, $t5 # sum = arrOne[x][y] + arrTwo[x][y]
			sw $v0, arrRes($t3) # arrRes[x][y] = sum
			
			addi $t1, $t1, 1 # y = y+1
			blt $t1, $a1, ySumLoop  #if y < size, loop again
 
		addi $t0, $t0, 1 # x = x+1
		blt $t0, $a1, xSumLoop  #if i < size, loop again

	jr $ra

productMatrix:	
	li $t0,0 #t0 as the x index
	xProductLoop:
		li $t1,0 #t1 as the y index
		yProductLoop:
			li $v0,0 #sum = 0
			li $t2,0 #t2 as the z index
			zProductLoop:
				mul $t3, $t0, $a1 #t3 = x index * size
				add $t3, $t3, $t2 #t3 = t3 + z index
				mul $t3, $t3, DATA_SIZE #t3 = t3 * datasize
				
				mul $t4, $t2, $a1 #t4 = z index * size
				add $t4, $t4, $t1 #t4 = t4 + y index
				mul $t4, $t4, DATA_SIZE #t4 = t4 * datasize
			
				lw $t5, arrOne($t3)  #getting element arrOne[x][z]
				lw $t6, arrTwo($t4)  #getting element arrTwo[z][y]
				
				mul $t7, $t5, $t6 # t7 = arrOne[x][z] * arrTwo[z][y]
				add $v0, $v0, $t7 # sum = sum + t7
			
				addi $t2, $t2, 1 # z = z+1
				blt $t2, $a1, zProductLoop  #if z < size, loop again
				
			mul $t3, $t0, $a1 #t3 = x index * size
			add $t3, $t3, $t1 #t3 = t3 + y index
			mul $t3, $t3, DATA_SIZE #t3 = t3 * datasize
				
			sw $v0, arrRes($t3) # arrRes[x][y] = sum
				
 			addi $t1, $t1, 1 # y = y+1
			blt $t1, $a1, yProductLoop  #if y < size, loop again
			
		addi $t0, $t0, 1 # x = x+1
		blt $t0, $a1, xProductLoop  #if i < size, loop again

	jr $ra
	
sumColMatrix:	
	li $t1,0 #t0 as the x index

	ySumColLoop:
		li $v0,0 #sum = 0
		li $t0,0 #t1 as the y index
		xSumColLoop:
			mul $t3, $t0, $a1 #t3 = x index * size
			add $t3, $t3, $t1 #t3 = t3 + y index
			mul $t3, $t3, DATA_SIZE #t3 = t3 * datasize
			
			lw $t4, arrOne($t3)  #getting element arrOne
			lw $t5, arrTwo($t3)  #getting element arrTwo
			
			add $v0, $t4, $t5 # sum = arrOne[x][y] + arrTwo[x][y]
			sw $v0, arrRes($t3) # arrRes[x][y] = sum
			
			addi $t0, $t0, 1 # x = x+1
			blt $t0, $a1, xSumColLoop  #if y < size, loop again
 
		addi $t1, $t1, 1 # y = y+1 
		blt $t1, $a1, ySumColLoop  #if i < size, loop again

	jr $ra

productColMatrix:	
	li $t1,0 #t0 as the y index
	yProductColLoop:
		li $t0,0 #t1 as the x index
		xProductColLoop:
			li $v0,0 #sum = 0
			li $t2,0 #t2 as the z index
			zProductColLoop:
				mul $t3, $t0, $a1 #t3 = x index * size
				add $t3, $t3, $t2 #t3 = t3 + z index
				mul $t3, $t3, DATA_SIZE #t3 = t3 * datasize
				
				mul $t4, $t2, $a1 #t4 = z index * size
				add $t4, $t4, $t1 #t4 = t4 + y index
				mul $t4, $t4, DATA_SIZE #t4 = t4 * datasize
			
				lw $t5, arrOne($t3)  #getting element arrOne[x][z]
				lw $t6, arrTwo($t4)  #getting element arrTwo[z][y]
				
				mul $t7, $t5, $t6 # t7 = arrOne[x][z] * arrTwo[z][y]
				add $v0, $v0, $t7 # sum = sum + t7
			
				addi $t2, $t2, 1 # z = z+1
				blt $t2, $a1, zProductColLoop  #if z < size, loop again
				
			mul $t3, $t0, $a1 #t3 = x index * size
			add $t3, $t3, $t1 #t3 = t3 + y index
			mul $t3, $t3, DATA_SIZE #t3 = t3 * datasize
				
			sw $v0, arrRes($t3) # arrRes[x][y] = sum
				
 			addi $t0, $t0, 1 # x = x+1
			blt $t0, $a1, xProductColLoop  #if x < size, loop again
			
		addi $t1, $t1, 1 # y = y+1
		blt $t1, $a1, yProductColLoop  #if y < size, loop again

	jr $ra

printMatrix:	
li $t0,0 #t0 as the x index		
xPrintLoop:
	li $t1,0 # t1 as the y index
	yPrintLoop:
		mul $t3, $t0, $a1 # t3 = x index * size
		add $t3, $t3, $t1 # t3 = t3 + y index
		mul $t3, $t3, DATA_SIZE # t3 = t3 * datasize
			
		lw $a0, arrRes($t3) 
		li $v0, 1
		syscall
			
		print_str("\t")
			
		addi $t1, $t1, 1 # y = y+1
		blt $t1, $a1, yPrintLoop  #if y < size, loop again
 		
 	print_str("\n")
		
	addi $t0, $t0, 1 # x = x+1
	blt $t0, $a1, xPrintLoop  #if i < size, loop again

print_str("\n")
jr $ra
