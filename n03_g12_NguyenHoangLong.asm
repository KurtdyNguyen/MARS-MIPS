.eqv SEVENSEG_LEFT	0xFFFF0011
.eqv SEVENSEG_RIGHT	0xFFFF0010

.eqv KEY_CODE 0xFFFF0004		# ASCII code from keyboard, 1 byte
.eqv KEY_READY 0xFFFF0000		# =1 if has a new keycode ?
			 		# Auto clear after lw
.eqv DISPLAY_CODE 0xFFFF000C 		# ASCII code to show, 1 byte
.eqv DISPLAY_READY 0xFFFF0008 		# =1 if the display has already to do
 					# Auto clear after sw
.eqv MASK_CAUSE_KEYBOARD   0x0000034
.data
bytehex: .byte 63,6,91,79,102,109,125,7,127,111 
storestring : .space 1000		# khoang trong de luu cac ky tu nhap tu ban phim.
Chuoiss : .asciiz "Bo mon ky thuat may tinh" 
Message: .asciiz "\n So ky tu trong 1 giay :  "
#Keyboard
.text
	li	$t9, 10			# muc dich cua $t9 la de lay so can dua vao Digital Lab Sim chia 10 de lay duoc 2 chu so can dua vao
	li	$t7, 200		# so vong lap
	li	$t6, 0			# so ky tu duoc nhap trong 1 giay
	li	$t8, 0			# bien chay de so sanh chuoi
	li	$t3, 0			# bien dem so ky tu giong nhau
	li	$s6, 0			# so ky tu duoc nhap vao tu ban phim
	li	$k0, KEY_CODE
	li	$k1, KEY_READY
 	li 	$s0, DISPLAY_CODE
	li 	$s1, DISPLAY_READY
loop: 	nop
WaitForKey:
	lb 	$t1, 0($k1) 		# $t1 = [$k1] = KEY_READY
	beq 	$t1, $zero, Vonglap	# if $t1 == 0 then Polling
MakeIntR:
	addi	$t6, $t6, 1		# dem so ky tu trong 1 giay
	teqi	$t1, 1 			# if $t1 = 1 then raise an Interrupt 
Vonglap:
	addi	$s6, $s6, 1
	addi	$a3, $a3, 1		# dem so vong lap, tuong ung thoi gian hoan thanh
	div	$s6, $t7		# kiem tra xem $s6 da duoc 1 giay chua
	mfhi	$s5
	bne	$s5, 0, Sleep
Dem:
	li	$s6, 0
# in toc do go
Display:
	div	$t6, $t9		# chia so can in ra cho 10
	mflo	$s5			# lay phan nguyen
	la	$s4, bytehex
	add	$s4, $s4, $s5
	lb	$v1, 0 ($s4)
	jal	SHOW_7SEG_LEFT		# in chu so hang chuc

	mfhi	$s5
	la	$s4, bytehex		# lay phan du
	add	$s4, $s4, $s5
	lb	$v1, 0 ($s4)
	jal	SHOW_7SEG_RIGHT		# in chu so hang don vi
	
	li	$t6, 0
Sleep:
	addi	$v0, $0, 32
	li	$a0, 5			# sleep 5 ms
	syscall
	nop
	b 	loop
SHOW_7SEG_LEFT:
	li	$t0, SEVENSEG_LEFT
	sb	$v1, 0 ($t0)
	jr	$ra
SHOW_7SEG_RIGHT:
	li	$t0, SEVENSEG_RIGHT
	sb	$v1, 0 ($t0)
	jr	$ra
	
.ktext 0x80000180 
get_caus:
	mfc0 	$t1, $13 		# $t1 = Coproc0.cause 
IsCount:
	li 	$t2, MASK_CAUSE_KEYBOARD# if Cause value confirm Keyboard 
	and 	$at, $t1, $t2 
	beq 	$at, $t2, Counter_Keyboard 
	j 	end_process 
Counter_Keyboard: 
ReadKey:
	lb 	$t0, 0($k0) 		# $t0 = [$k0] = KEY_CODE
WaitForDis:
	lb 	$t2, 0($s1) 		# $t2 = [$s1] = DISPLAY_READY
	beq 	$t2, $zero, WaitForDis # if $t2 == 0 then Polling 
Encrypt:
	addi	$t0, $t0, 0 		# change input key
ShowKey:
	beq	$t0, '\n', Stop		# neu la ky tu xuong dong thi dung lai
	la	$s7, Chuoiss		
	add	$s7, $s7, $t8
	addi	$t8, $t8, 1
	lb	$t4, 0 ($s7)		# $t4 la ky tu duoc lay tu xau cho truoc de so sanh voi ky tu duoc nhap
	bne	$t0, $t4, end_process
	sb	$t0, 0($s0) 		# show key
	addi	$t3, $t3, 1
end_process: 
next_pc:
	mfc0	$at, $14 		# $at <= Coproc0.$14 = Coproc0.epc 
	addi	$at, $at, 4 		# $at = $at + 4 (next instruction) 
	mtc0	$at, $14 		# Coproc0.$14 = Coproc0.epc <= $at 
return: eret 				# Return from exception
Stop:
# in ra so ky tu dung
Display1:
	div	$t3, $t9
	mflo	$s5
	la	$s4, bytehex
	add	$s4, $s4, $s5
	lb	$v1, 0 ($s4)
	jal	SHOW_7SEG_LEFT1

	mfhi	$s5
	la	$s4, bytehex
	add	$s4, $s4, $s5
	lb	$v1, 0 ($s4)
	jal	SHOW_7SEG_RIGHT1

	addi	$a0, $a3, 0
	li	$v0, 1			# in ra thoi gian hoan thanh
	syscall
	li	$v0, 10			# ket thuc
	syscall
SHOW_7SEG_LEFT1:
	li	$t0, SEVENSEG_LEFT
	sb	$v1, 0 ($t0)
	jr	$ra
SHOW_7SEG_RIGHT1:
	li	$t0, SEVENSEG_RIGHT
	sb	$v1, 0 ($t0)
	jr	$ra