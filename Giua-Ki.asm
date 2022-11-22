.data
	D: .space 80
	daucach: .asciiz " "
	thongbao1: .asciiz "\nNhap so phan tu trong mang(1< va <=20): "
	thongbao2: .asciiz "\nNhap gia tri cac phan tu: "
	thongbao3: .asciiz "\nGia tri cua day sau khi da xu li: "
	thongbao4: .asciiz "\nSo buoc de cho ra day tang dan la: "
	thongbao5: .asciiz "\nKhong hop le. Hay nhap lai phan tu nay!\n"
.text	
	li $t0, 0 #goi tri so i dem D[i]
	li $t1, 4 #goi tri so i+4
	li $s0, 0 #dem xem da thuc hien bao nhieu buoc "+1"
	li $s1, 0 #tri so phan tu cuoi cung cua mang D, viet duoi dang x4bit
nhapmang: #nhap so phan tu trong mang va gia tri moi phan tu
	kiemtra1:
		li $v0, 4
		la $a0, thongbao1
		syscall
		
		li $v0, 5
		syscall
		
		ble $v0, 1, kiemtra1
		bgt $v0, 20, kiemtra1
		mulou $s1, $v0, 4
		subiu $s1, $s1, 4
	li $v0, 4
	la $a0, thongbao2
	syscall
	vonglap1:
		li $v0, 5
		syscall
		sw $v0, D($t0)
		addi $t0, $t0, 4
		ble $t0, $s1, vonglap1
	li $t0, 0
sosanh:
	lw $t2, D($t0) #t2 = D[i]
	lw $t3, D($t1) #t3 = D[i+4]
	ble $t3, $t2, cong #neu D[i]>=D[i+4], cong them 1 vao gia tri cua D[i+4]
	j chuyentiep #dich i=i+4, neu i vuot qua do lon cua chuoi thi ta ket thuc viec kiem tra
	
cong: #cong them 1 vao gia tri cua D[i+4]
	addi $t3, $t3, 1
	sw $t3, D($t1)
	addi $s0, $s0, 1
	j sosanh

chuyentiep: #dich i=i+4, neu i vuot qua do lon cua chuoi thi ta ket thuc viec kiem tra
	addi $t0, $t0, 4
	addi $t1, $t1, 4
	beq $t0, $s1, in
	j sosanh

in: #ra ket qua
	li $v0, 4
	la $a0, thongbao3
	syscall
	
	li $t0, 0
	vonglap2:
		li $v0, 4
		la $a0, daucach
		syscall
	
		li $v0, 1
		lw $a0, D($t0)
		syscall
		
		addi $t0, $t0, 4
		ble $t0, $s1, vonglap2
	
	li $v0, 4
	la $a0, thongbao4
	syscall
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	li $v0, 10
	syscall
