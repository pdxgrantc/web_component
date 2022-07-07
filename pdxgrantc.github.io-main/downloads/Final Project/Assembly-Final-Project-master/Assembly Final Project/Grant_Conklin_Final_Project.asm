TITLE Final Project         (Grant_Conklin_Final_Project.asm)

; Grant Conklin
; 3/1/2022
; CS 271
; Winter 2022
; FINAL PROJECT

; I think my grader is Sadie Thomas

INCLUDE Irvine32.inc

.data
; Test One Decoy
decoyT						BYTE		"Decoy mode:", 0
sum							BYTE		"Sum: ", 0
operandone					WORD		46
operandtwo					WORD		-20
operandthree				DWORD		0

; Test Two Encryption
encryptionT					BYTE		"Encrpyton mode:", 0
encryptionkey				BYTE		"efbcdghijklmnopqrstuvwxyza"
encryptionmessage			BYTE		"the contents of this message will be a mystery.",0
encryptiondestination		DWORD		-1

; Test Three Decryption
decryptionT					BYTE		"Decryption mode:", 0
decryptionkey				BYTE		"efbcdghijklmnopqrstuvwxyza"
decryptionessage			BYTE		"uid bpoudout pg uijt ndttehd xjmm fd e nztudsz.",0
decryptiondestination		DWORD		-2

.code
main PROC
	; Test One
	mov			edx,OFFSET  decoyT
	call		WriteString
	call		crlf
	mov			edx,OFFSET  sum
	call		WriteString
	push		operandone
	push		operandtwo
	push		OFFSET		operandthree
	call		Compute
	pop			eax
	pop			eax
	pop			eax
	mov			eax,		operandthree
	call		WriteInt
	call		crlf
	call		crlf

	; Test Two
	mov			edx,OFFSET  encryptionT
	call		WriteString
	call		crlf
	mov			edx,		OFFSET encryptionmessage
	call		WriteString
	call		crlf
	push		OFFSET		encryptionkey
	push		OFFSET		encryptionmessage
	push		OFFSET		encryptiondestination
	call		Compute
	pop			eax
	pop			eax
	pop			eax
	mov			edx,		OFFSET encryptionmessage
	call		WriteString
	call		crlf
	call		crlf

	; Test Three
	mov			edx,OFFSET  decryptionT
	call		WriteString
	call		crlf
	mov			edx,		OFFSET decryptionessage
	call		WriteString
	call		crlf
	push		OFFSET		decryptionkey
	push		OFFSET		decryptionessage
	push		OFFSET		decryptiondestination
	call		Compute
	pop			eax
	pop			eax
	pop			eax
	mov			edx,		OFFSET decryptionessage
	call		WriteString
	call		crlf
	
	exit
main ENDP

; Procedure takes 3 DWORD pointers and choses a function to call based on the integer value of one of them
; recieves: 3 DWORD pointers 
; returns: updates to the pointers depending on value
; preconditions: operands pushed onto the stack
; registers changed: eax, edx
compute PROC
	; setting up stack frame
	push    ebp
	mov		ebp, esp
	; comparing the final operand to check what procedure to call
	mov	edx,	[ebp + 8]
	mov	eax,	[edx]
	cmp	eax,	0
	; if else statement to call proc's 
	je	decoy		
	cmp	eax,	-1
	je	encryption
	cmp	eax,	-2
	je	decryption 
	jmp	final 
	decoy:		; jump point for decoy procedure
		; push operands on stack
		push	word ptr		[ebp + 14]
		push	word ptr		[ebp + 12]
		push	[ebp + 8]
		call	decoyPROC
		; clear stack
		pop		eax
		pop		eax
		pop		eax
		jmp		final
	encryption: ; jump point for encryption procedure
		; push operands on stack
		push	[ebp + 12] ;message
		push	[ebp + 16] ;key
		call	encryptionPROC
		; clear stack
		pop		eax
		pop		eax
		jmp		final
	decryption: ; jump point for decryption procedure
		; push operands on stack
		push	[ebp + 12]
		push	[ebp + 16]
		call	decryptionPROC
		; clear stack
		pop		eax
		pop		eax
	final:

	mov	esp,	ebp        
	pop	ebp              
	ret  
compute ENDP

; Procedure take two 16 bit integers and add them to a possible 32 bit state
; recieves: 2 16 bit integers and an address to a DWORD
; returns: sum of two WORD inputs in DWORD address
; preconditions: operands pushed onto the stack
; registers changed: eax, ebx, ecx
decoyPROC PROC
	; setting up stack frame
	push    ebp
	mov		ebp,	esp
	; move output address to ecx and move arguements into ax and bx
	mov		ecx,	[ebp + 8]
	mov		eax,	0
	mov		ebx,	0
	mov		ax,		word ptr [ebp + 12]
	mov		bx,		word ptr [ebp + 14]
	; sign extend ex to eax and bx to ebx
	movsx	eax,	ax
	movsx	ebx,	bx
	; preform adition and move output to output adress in ecx
	add		eax,	ebx
	mov		[ecx],	eax
	; return stack to pre call state
	mov		esp,	ebp        
	pop		ebp              
	ret
decoyPROC ENDP

; Procedure to take a key and message and encrpyt based on substitution cipher
; recieves: 2 DWORD pointers to key and message
; returns: encrypted message in the message pointer array
; preconditions: operands pushed onto the stack
; registers changed: eax, ebx, cl, edx, edi
encryptionPROC PROC
	; setting up stack frame
	push    ebp
	mov		ebp, esp
	; moving pointers to each array into registers
	mov		ebx, [ebp + 12] ; message pointer
	mov		edi, [ebp + 8]	; key pointer
	mov		edx, 0
	; starting to iterate through the message
	stringprocess:
		; moving nth character in message into al
		mov eax, 0
		mov al, [ebx + edx]
		; testing to see if null character SPACE or . 
		cmp	al, 0
		je	endstr		; null character so we skip to end of procedure
		; checking if character is lowercase alphabetic
		cmp al, 97
		jl  notLowerCase
		cmp al, 122
		jg  notLowerCase
		; getting letters index in alphabet
		sub al, 97
		movzx	eax,	ax
		; getting the alphabetic index of the message letter from key
		mov cl, [edi + eax]
		; moving letter from key into the message
		mov	[ebx + edx], cl
		; jump points to avoid swapping
		notLowerCase:
		inc edx
		jmp	stringprocess
	endstr:
	mov		esp, ebp        
	pop		ebp              
	ret
encryptionPROC ENDP

; Procedure to take a key and encryted message and decrpyt based on substitution cipher
; recieves: 2 DWORD pointers to key and message
; returns: decrypted message in the message pointer array
; preconditions: operands pushed onto the stack
; registers changed: eax, ebx, ecx, edx, edi
decryptionPROC PROC
	; setting up stack frame
	push    ebp
	mov		ebp, esp
	; moving pointers to each array into registers
	mov		ebx, [ebp + 12] ; message pointer
	mov		edi, [ebp + 8]	; key pointer
	mov		edx, 0
	; starting to iterate through the message
	stringprocess:
		; moving nth character in message into al
		mov eax, 0
		mov al, [ebx + edx]
		; testing to see if null character SPACE or . 
		cmp	al, 0
		je	endstr		; null character so we skip to end of procedure
		; checking if character is lowercase alphabetic
		cmp al, 97
		jl  notLowerCase
		cmp al, 122
		jg  notLowerCase
		; getting letters index in alphabet
		;sub al, 97
		push edx
		mov ecx, 26
		; looping through the key to find matching letter
		keyLoop:
			dec	ecx
			mov dl, [edi + ecx]
			; when letter found index is saved in ecx
			cmp al, dl
			je  foundLetter
			inc	ecx
		loop keyLoop
		foundLetter:
		pop  edx
		; add the letter's index in the key to 97 getting decrpyed char
		add  ecx, 97
		; moving letter from key into the message
		mov	[ebx + edx], cl
		; jump points to avoid swapping
		notLowerCase:
		inc edx
		jmp	stringprocess
	endstr:
	mov		esp, ebp        
	pop		ebp              
	ret
decryptionPROC ENDP

END main