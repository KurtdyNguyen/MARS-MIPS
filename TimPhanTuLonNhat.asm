.data
	array: .word 5, 3, 9, 4, 1, 10 #khoi tao mang a[i]
.text
.globl main
main:
	li $t0, 0 #dat gia tri tai thanh t0 ve 0; t0 dong vai tro so dem i cho mang a[i]
	li $t1, 0 #dong vai tro la gia tri Max
while:
 	beq $t0, 24, end #neu i vuot qua so luong phan tu trong mang, ket thuc chtrinh.
 			 #O day la 24 vi mang co 6 phan tu, moi phan tu so nguyen co 4 bit, 6x4=24 bit.
 			 #Nho thay doi so 24 neu su dung mang co so phan tu khac
 	lw $t2, array($t0) #nap gia tri a[i] vao thanh t2
 	bgt $t2, $t1, else #nhay den else neu a[i]>Max
 	addi $t0, $t0, 4 #a[i] chuyen sang a[i+1]
 	j while #tiep tuc vong lap moi
 	else:
 		move $t1, $t2 #Max == a[i]	
 		j while
end: #in gia tri MAX
	li $v0, 1
	move $a0, $t1
	syscall
