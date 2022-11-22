.eqv KEY_CODE 0xFFFF0004
.eqv KEY_READY 0xFFFF0000
.eqv DISPLAY_CODE 0xFFFF000C
.eqv DISPLAY_READY 0xFFFF0008
.eqv HEX_KEY 0xFFFF0012
.eqv KEYPAD_VAL 0xFFFF0014

.data
hai_chu_so: .space 8 #giu hai gia tri chu so cua thoi gian nhap vao
dong_chu_can_nhap: .space 100
dong_chu_nhap_vao: .space 400
xuongdong: .asciiz "\n"
tb1: .asciiz "Gia tri ban da nhap: "
tb2: .asciiz "Gia tri thoi gian ban da nhap: "
tb3: .asciiz "Noi dung ban nhap vao: "
tb4: .asciiz "So ky tu chinh xac: "

.text
li $k0, KEY_CODE
li $k1, KEY_READY
li $s0, DISPLAY_CODE
li $s1, DISPLAY_READY
li $s2, HEX_KEY
li $s3, KEYPAD_VAL

li $t1, 0 #kiem tra hai chu so cua gia tri tgian nhap vao

	li $v0, 8
	la $a0, dong_chu_can_nhap
	li $a1, 100
	syscall
kiem_tra_nhap_numpad:
	li $t0, 0x01
	sb $t0, 0($s2)
	lb $a0, 0($s3)	
	bnez $a0, nhan_gia_tri_thoi_gian
	nop
	
	li $t0, 0x02
	sb $t0, 0($s2)
	lb $a0, 0($s3)		
	bnez $a0, nhan_gia_tri_thoi_gian
	nop
	
	li $t0, 0x04
	sb $t0, 0($s2)
	lb $a0, 0($s3)
	bnez $a0, nhan_gia_tri_thoi_gian
	nop
	
	j kiem_tra_nhap_numpad
	
nhan_gia_tri_thoi_gian:
	jal he16_sang_he10
	move $t0, $a0
	li $v0, 4
	la $a0, tb1
	syscall
	li $v0, 1
	move $a0, $t0
	syscall
	li $v0, 4
	la $a0, xuongdong
	syscall
	
	sw $t0, hai_chu_so($t1)
	cho_nhap_so_tiep_theo:
	li $t2, 0x01
	sb $t2, 0($s2)
	lb $a0, 0($s3)	
	bnez $a0, cho_nhap_so_tiep_theo
	nop
	
	li $t2, 0x02
	sb $t2, 0($s2)
	lb $a0, 0($s3)		
	bnez $a0, cho_nhap_so_tiep_theo
	nop
	
	li $t2, 0x04
	sb $t2, 0($s2)
	lb $a0, 0($s3)
	bnez $a0, cho_nhap_so_tiep_theo
	
	addi $t1, $t1, 4
	beq $t1, 4, kiem_tra_nhap_numpad
	
	subi $t1, $t1, 4
	lw $t0, hai_chu_so($zero)
	lw $t2, hai_chu_so($t1)
	mul $t0, $t0, 10
	add $t0, $t0, $t2
	li $v0, 4
	la $a0, tb2
	syscall
	li $v0, 1
	move $a0, $t0
	syscall
	li $v0, 4
	la $a0, xuongdong
	syscall
	
	mul $t0, $t0, 1000
doi:
	nop
	lw $t1, 0($k1)
	beqz $t1, doi
	
	li $v0, 30 #lay timestamp luc bat dau nhap
	syscall
	move $t2, $a0
	li $t1, 0
dong_ho_bam_gio:
	nop
	lw $t3, 0($k1)
	beqz $t3, khong_doc #neu thanh trang thai = 0(chua nhap) thi bo qua khong kiem tra noi dung
	lw $t3, 0($k0)
	sw $t3, dong_chu_nhap_vao($t1)
	addi $t1, $t1, 4
	khong_doc:
	li $v0, 30 #lay timestamp va so sanh voi moc thoi gian cu
	syscall
	sub $a0, $a0, $t2 #thoi gian da troi qua
	blt $a0, $t0, dong_ho_bam_gio
#-----------------------	
	li $t0, 0
	li $v0, 4
	la $a0, tb3
	syscall
xac_nhan_input: #in ra de chuong trinh trong ro rang hon, xoa di cung duoc
	la $a0, dong_chu_nhap_vao($t0)
	li $v0, 4
	syscall
	addi $t0, $t0, 4
	blt $t0, $t1, xac_nhan_input
	
	li $v0, 4
	la $a0, xuongdong
	syscall
#-------------------	
	li $t1, 0
	la $t4, dong_chu_can_nhap
	la $t5, dong_chu_nhap_vao
kiem_tra_chinh_ta:
	lb $t2, 0($t4)
	beqz $t2, ket_thuc
	lb $t3, 0($t5)
	bne $t2, $t3, khong_chinh_xac
	addi $t1, $t1, 1 #dem ky tu dung
	khong_chinh_xac:
	addi $t4, $t4, 1
	addi $t5, $t5, 4
	j kiem_tra_chinh_ta
	
ket_thuc:
	li $v0, 4
	la $a0, tb4
	syscall
	li $v0, 1
	move $a0, $t1
	syscall
	li $v0, 10
	syscall

he16_sang_he10:
	beq $a0, 0x11, he16_sang_he10_0
	beq $a0, 0x21, he16_sang_he10_1
	beq $a0, 0x41, he16_sang_he10_2
	beq $a0, -127, he16_sang_he10_3
	beq $a0, 0x12, he16_sang_he10_4
	beq $a0, 0x22, he16_sang_he10_5
	beq $a0, 0x42, he16_sang_he10_6
	beq $a0, -126, he16_sang_he10_7
	beq $a0, 0x14, he16_sang_he10_8
	beq $a0, 0x24, he16_sang_he10_9
he16_sang_he10_0:
	li $a0, 0
	jr $ra
he16_sang_he10_1:
	li $a0, 1
	jr $ra
he16_sang_he10_2:
	li $a0, 2
	jr $ra
he16_sang_he10_3:
	li $a0, 3
	jr $ra
he16_sang_he10_4:
	li $a0, 4
	jr $ra
he16_sang_he10_5:
	li $a0, 5
	jr $ra
he16_sang_he10_6:
	li $a0, 6
	jr $ra
he16_sang_he10_7:
	li $a0, 7
	jr $ra
he16_sang_he10_8:
	li $a0, 8
	jr $ra
he16_sang_he10_9:
	li $a0, 9
	jr $ra
