#chu thich la bai nay toi sap xep tu be den lon

.data
	D: .word 3, 1, 5, -12, 2, 3 #khoi tao mang, mang nay co 6 phan tu nguyen, 24 bit, tuong ung voi D[0], D[4], ..., D[20]
	daucach: .asciiz " "
.text 
	li $t0, 0 #hai bien i va i+4
	li $t1, 4 #de so sanh hai phan tu canh nhau(VD: D[16] <>= D[20]?)
	li $s0, 1 #dem so lan sap xep mang. Trong truong hop xau nhat chung ta can soat lai n-1 lan doi voi mang co n phan tu
	sosanh:
		bgt $t0, 16, vonglapmoi #neu da xu li hai phan tu cuoi cung xong thi ta ket thuc qua trinh so sanh
		lw $t2, D($t0) #lay gia tri
		lw $t3, D($t1) #cua phan tu mang D
		bgt $t2, $t3, daovitri #neu D[i]>D[i+4] thi tien hanh doi gia tri cua chung
		addi $t0, $t0, 4 #i+=4, chuyen den hai phan tu
		addi $t1, $t1, 4 #lien sau cua mang de tiep tuc so sanh
		j sosanh
	daovitri:
		sw $t2, D($t1)
		sw $t3, D($t0)
		addi $t0, $t0, 4 #cung la buoc i+=4, vai tro tuong tu
		addi $t1, $t1, 4 #hai dong addi ben tren
		j sosanh
	vonglapmoi:
		li $t0, 0 #bat dau lai tu dau
		li $t1, 4 #bang viec gan i=0
		addi $s0, $s0, 1 #dem xem minh da sap xep noi bot bao nhieu lan
		beq $s0, 6, in #dung lai khi da hoan thanh n-1 lan sap xep noi bot
		j sosanh
	in:
		li $t0, 0
		vonglap:
			li $v0, 1
			lw $a0, D($t0)
			syscall
			
			li $v0, 4
			la $a0, daucach
			syscall
			
			addi $t0, $t0, 4
			bgt $t0, 20, ketthuc
			j vonglap
	ketthuc:
		li $v0, 10
		syscall