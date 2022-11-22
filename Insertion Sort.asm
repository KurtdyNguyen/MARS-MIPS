.data
	D: .word 3, 1, 5, -12, 2, 3 #khoi tao mang, mang nay co 6 phan tu nguyen, 24 bit, tuong ung voi D[0], D[4], ..., D[20]
	daucach: .asciiz " "
.text
	li $t0, 0 #hai bien i va i+4
	li $t1, 4 #de so sanh hai phan tu canh nhau(VD: D[16] <>= D[20]?)
	sosanh:
		lw $s0, D($t0) #lay gia tri
		lw $s1, D($t1) #cua phan tu mang D
		bgt $s0, $s1, kiemtra #neu D[i]>D[i+4] thi tien hanh so sanh cac gia tri truoc do cua D voi D[i+4]
		addi $t0, $t0, 4 #i+=4, chuyen den hai phan tu
		addi $t1, $t1, 4 #lien sau cua mang de tiep tuc so sanh
		beq $t0, 20, in #neu da xu li hai phan tu cuoi cung xong thi ta ket thuc qua trinh so sanh
		j sosanh
	kiemtra: #bat dau tu D[i], ta so sanh D[i+4] voi D[i-4], D[i-8],... cho den khi tim ra gia tri
		 #be hon no, hoac da kiem tra xong voi D[0]
		move $t2, $t0 
		vonglap1:
			subi $t2, $t2, 4
			blt $t2, 0, doivitri
			lw $s2, D($t2)
			bge $s1, $s2, doivitri
			j vonglap1
	doivitri: #dich vi tri cua cac phan tu len 4 bit(gan D[j] = D[j+4]); trong khi do, tra D[i+4] ve vi tri moi
		move $t3, $t0
		move $t4, $t1
		vonglap2:
			lw $s3, D($t3)
			sw $s3, D($t4)
			subi $t3, $t3, 4
			subi $t4, $t4, 4
			bgt $t3, $t2, vonglap2
		sw $s1, D($t4) #D[i+4] = D[vi tri moi]
		j sosanh #tiep tuc viec so sanh cac phan tu dang sau
	in:
		li $t0, 0
		vonglap3:
			li $v0, 1
			lw $a0, D($t0)
			syscall
			
			li $v0, 4
			la $a0, daucach
			syscall
			
			addi $t0, $t0, 4
			bgt $t0, 20, ketthuc
			j vonglap3
	ketthuc:
		li $v0, 10
		syscall