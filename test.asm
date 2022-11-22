.data
xuongdong: .asciiz "\n"
dong_chu_can_nhap: .space 100
dong_chu_nhap_vao: .space 100
.text
	li $v0, 8
	la $a0, dong_chu_can_nhap
	li $a1, 30
	syscall
	
	li $v0, 8
	la $a0, dong_chu_nhap_vao
	li $a1, 30
	syscall
	
	li $t0, 0
	li $t3, 0
in:
	lb $t1, dong_chu_can_nhap($t0)
	beqz $t1, ketthuc
	li $v0, 11
	lb $a0, dong_chu_can_nhap($t0)
	syscall
	lb $t2, dong_chu_nhap_vao($t0)
	beq $t1, $t2, chinhxac
	addi $t3, $t3, 1
	chinhxac:
	addi $t0, $t0, 1
	j in
	
ketthuc:
	li $v0, 10
	syscall
