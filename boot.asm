;	
;	This file is the bootloader for DanOS
;	

ORG 0x7c00					;	this is the standard address where the BIOS loads the bootloader
BITS 16						;	assembler will assemble instructions into 16-bit code (real mode is 16-bit only)


start:
	mov si, message			; loads the address of the label message on the register si
	call print_loop			; calls the function that will loop throughout the string printing it char by char
	jmp $					; jumps to itself to prevent executing the boot signature a few lines below

print_loop:
	mov bx, 0				; bx register holds the page number
	cld						; clears the direction flag to ensure the si register will be incremented after the lodsb
.loop:
	lodsb					; loads a byte from si into register al and increments lodsb (DF is 0)
	cmp al, 0				; it is a null-terminated string, to this is checking if we have reached the end of the string
	je .end					; if the string has ended, jumps to .end label to return
	call print_char			; prints 1 character - the one loaded into al through lodsb
	jmp .loop				; loops

.end:
	ret

print_char:
	mov ah, 0x0e			; command to display a character on screen
	int 0x10				; calls a BIOS routine to execute and display the character
	ret

message: db 'Welcome to DanOS', 0	; creates a null-terminated string

times 510 - ($-$$) db 0		; sets all bytes from the end of this program until byte 510 to zero

dw 0xAA55					; declares a word-size variable (2 bytes) with value 0xAA55
							; Intel/AMD are little endian so the byte 511 will be 55 and byte 512 will be AA
							; 0x55 0xAA is a boot signature which indicates that the first sector of this device is bootable
