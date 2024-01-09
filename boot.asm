;	
;	This file is the bootloader for DanOS
;	

ORG 0x7c00					;	this is the standard address where the BIOS loads the bootloader
BITS 16						;	assembler will assemble instructions into 16-bit code (real mode is 16-bit only)

start:
	mov ah, 0x0e			; command to display a character on screen
	mov al, 'A'				; the character to be displayed
	mov bx, 0				; bh register holds the page number
	int 0x10				; calls a BIOS routine to execute and display the character
	jmp $					; jumps to itself to prevent executing the boot signature a few lines below

times 510 - ($-$$) db 0		; sets all bytes from the end of this program until byte 510 to zero

dw 0xAA55					; declares a word-size variable (2 bytes) with value 0xAA55
							; Intel/AMD are little endian so the byte 511 will be 55 and byte 512 will be AA
							; 0x55 0xAA is a boot signature which indicates that the first sector of this device is bootable
