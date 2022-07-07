TITLE Random Integer Sorter 

; CS 271
; Assignment Five
; 2/27/2022
; Name: Grant Conklin

INCLUDE Irvine32.inc

MIN EQU 200
MAX EQU 15
LO EQU 100
HI EQU 999

.data
; INTRO strings
titleStr	BYTE	"Random Integer Sorter", 0			; 22 bytes
myName		BYTE	"Programed by Grant Conklin", 0		; 27 bytes
whatDoes	BYTE	"This program generates random numbers in the range [100 .. 999]", 0
displays	BYTE	"displays the original list, sorts the list, and calculates the", 0
median	 	BYTE	"median value. Finally, it displays the list sorted in descending order.", 0
; GET DATA strings
howMany		BYTE	"How many numbers should be generated? [15 .. 200]: ", 0
invalid		BYTE	"Invalid input", 0
; DISPLAY UNSORTED string
unsorted	BYTE	"The unsorted random numbers:", 0
; DISPLAY MEDIAN string
whatMedian	BYTE	"The median is: ", 0
; DISPLAY SORTED string
sorted		BYTE	"The sorted list:", 0
; GOODBYE string
TA		BYTE	"I think my TA is Sadie Thomas.", 0
thanks		BYTE	"Thanks for using my program!", 0
userInput	DWORD	?
ary			DWORD    200    DUP(?)								; set to 200 which is the max number the user can enter to avoid heap memory

.code
; Procedure to drive and push/pop from stack for program
; recieves: nothing
; returns: nothing
; preconditions: .data segment
; registers changed: eax
main PROC
; this is a series of function calls before each the data is pushed on the stack and then popped to clean the stack after a fucntion call
	call	Randomize											; seeding the random number generator
	push	OFFSET			median
	push	OFFSET			displays
	push	OFFSET			whatDoes
	push	OFFSET			myName
	push	OFFSET			titleStr
	call	intro	
	; clean stack of depricated variables
	pop		eax
	pop		eax
	pop		eax
	pop		eax
	pop		eax

	push	OFFSET			userInput							; pass by reference ie address	
	push	OFFSET			invalid
	push	OFFSET			howMany
	call	getData	
	; clean stack of depricated variables
	pop		eax
	pop		eax
	pop		eax

	push	userInput											; pass by value ie without the RAM address (doubles as array lenth)
	push	OFFSET			ary	
	call	fillAry	
	; clean stack of depricated variables
	pop		eax
	pop		eax

	push	OFFSET			unsorted
	push	userInput
	push	OFFSET			ary
	call	displayAry	
	; clean stack of depricated variables
	pop		eax
	pop		eax
	pop		eax

	call	crlf

	push	userInput
	push	OFFSET			ary
	call	sortary	
	; clean stack of depricated variables
	pop		eax
	pop		eax

	call	crlf

	push	OFFSET			whatMedian
	push	userInput
	push	OFFSET			ary
	call	findMedian	
	; clean stack of depricated variables
	pop		eax
	pop		eax
	pop		eax

	call	crlf

	push	OFFSET			sorted
	push	userInput
	push	OFFSET			ary
	call	displayAry	
	; clean stack of depricated variables
	pop		eax
	pop		eax
	pop		eax

	call	crlf

	; STRING Variables pushed onto stack
	;push	OFFSET			thanks
	;push	OFFSET			sorted
	;push	OFFSET			whatMedian
	;push	OFFSET			unsorted
	;push	OFFSET			invalid
	;push	OFFSET			howMany

				
	push	OFFSET			TA
	push	OFFSET			thanks
	call	goodbye		
	pop		eax
	pop		eax
	exit
main ENDP


; Procedure to print hello and other information
; recieves: string pointers on the stack
; returns: nothing
; preconditions: string pointers pushed on stack
; registers changed: edx
intro PROC
	; setting up stack frame
	push    ebp
	mov		ebp, esp
	
	mov		edx, [ebp + 8]										; this is the offset for the address on the stack
	call	WriteString
	call	crlf
	mov		edx, [ebp + 12]										; this is the offset for the address on the stack
	call	WriteString
	call	crlf
	mov		edx, [ebp + 16]										; this is the offset for the address on the stack
	call	WriteString
	call	crlf
	mov		edx, [ebp + 20]										; this is the offset for the address on the stack
	call	WriteString
	call	crlf
	mov		edx, [ebp + 24]										; this is the offset for the address on the stack
	call	WriteString
	call	crlf
	call	crlf

	; returning stack frame to previous value
	mov		esp, ebp        
	pop		ebp              
	ret                  
intro ENDP

; Procedure to print instruction and take integer input
; recieves: string pointers on the stack
; returns: nothing
; preconditions: string pointers pushed on stack
; registers changed: eax, edx
getData PROC
	; setting up stack frame
	push    ebp
	mov		ebp, esp
	askValue:
		mov		edx,		[ebp + 8]							; this is the offset for the address on the stack
		call	WriteString
		call	readInt
		checkLower:												; check the lower bound for validation
			cmp	eax,		MIN
			jg	outsideBounds
		checkUpper:												; check the upper bound for validation
			cmp	eax,		MAX
			jl	outsideBounds
			mov	ebx,		[ebp + 16]
			mov	[ebx],		eax									; storing the input on the stack for later use
			jmp	endProc											
		outsideBounds:											; print statment and while jump if outside bounds 
			mov		edx,		[ebp + 12]
			call	WriteString
			call	crlf
			jmp		askValue
	endProc:
	mov		esp, ebp        
	pop		ebp              
	ret  
getData	ENDP

; Procedure to fill the ary with random integers
; recieves: ary referecne ary len value
; returns: filled ary which is passed by reference
; preconditions: ary reference and length is pushed on the stack
; registers changed: eax, ecx, edx, esi
fillAry PROC
	; setting up stack frame
	push		ebp
	mov ebp,	esp

	; setting esi and ecx to parse throgh the array
	mov	esi,	[ebp + 8]
	mov ecx,	[ebp + 12]
	; logic to fill the ary
	createNumLoop:
		createRandVal:
			; gets a random value between hi and lo in eax
			mov		eax,		hi											; finding the range from 1 for RandomRange
			sub		eax,		lo
			inc		eax			
			call	RandomRange												; get random number
			add		eax,		lo											; add low to get bottom of range
		storeInAry:
			mov		[esi],		eax											; store random value in array
			add		esi, 4
	loop createNumLoop														; repeat

	mov esp,	ebp        
	pop ebp   
	ret
fillAry ENDP

; Procedure to print an array of integers
; recieves: ary referecne ary len value
; returns: nothing
; preconditions: ary reference and length is pushed on the stack
; registers changed: eax, ecx, edx, esi
displayAry PROC
	; setting up stack frame
	push		ebp
	mov ebp,	esp

	; logic to fill the ary
	mov	esi,	[ebp + 8]
	mov ecx,	[ebp + 12]
	mov edx,	[ebp + 16]
	; printing the title
	call		crlf
	call		WriteString
	call		crlf
	mov	edx,	0
	printLoop:																; outside loop to print the values
		mov		eax, [esi]
		add		esi, 4
		call	WriteInt
		mov		al,	' '														; space between values
		call WriteChar
	checkNewLine:															; check the edx counter to see if 10 values have been printed
			inc		edx
			cmp		edx,		10
			je		newLine
			jmp		noNewLine
		newLine:															; if edx==10 create new line
			call	crlf
			mov		edx,		0
		noNewLine:
	loop printLoop															; repeat for all of the array

	mov esp,	ebp        
	pop ebp   
	ret
displayAry ENDP

; Procedure to fill the ary with random integers
; recieves: ary referecne ary len value
; returns: filled ary which is passed by reference
; preconditions: ary reference and length is pushed on the stack
; registers changed: eax, ecx, esi
sortary PROC
	; setting up stack frame
	push		ebp
	mov ebp,	esp

	; setting up counters
	mov ecx,	[ebp + 12]			
	dec ecx
	L1:																		; outer loop with n-1
		push ecx
		mov	 esi,		[ebp + 8]
	L2:																		; inner loop to check decreasing sizes of space
		mov	 eax,		[esi]
		cmp  [esi + 4],	eax													; check if less than
		jl	 L3																	
		swap:																; swap
			xchg eax,		[esi + 4]	
			mov  [esi],		eax
	L3:																		; incrementing and loop instructions 
		add	 esi,		4
		loop L2
		pop  ecx
		loop L1

	mov esp,	ebp        
	pop ebp   
	ret
sortary ENDP

; Procedure to print the median of a sorted integer array
; recieves: ary referecne ary len value
; returns: filled ary which is passed by reference
; preconditions: ary reference which is sorted and length both pushed on the stack
; registers changed: eax, esi, edx, ebx
findMedian PROC
	; setting up stack frame
	push	ebp
	mov		ebp,	esp

	mov  edx,		[ebp + 16]
	call WriteString														; writing the median text
	mov		esi,	[ebp + 8]
	mov		eax,	[ebp + 12]
	mov		ebx,	2
	mov		edx,	0
	div		ebx	
	cmp		edx,	1
	je		index															; no remainder odd number of items in the array
	jmp		average

	index:
		mov	 ebx,	4
		mul	 ebx															; to get length of DWORD from BYTE
		add	 esi,	eax
		mov  eax,	[esi]
		call WriteInt
		jmp	 endPoint

	average:
		mov	 ebx,	4
		mul	 ebx															; to get length of DWORD from BYTE
		add	 esi,	eax
		mov  eax,	[esi]
		add	 eax,	[esi + 4]
		mov	 ebx,	2
		div  ebx
		call WriteInt
	endPoint:

	mov esp,	ebp        
	pop ebp   
	ret
findMedian ENDP

; Procedure to print goodbye message
; recieves: string pointers on the stack
; returns: nothing
; preconditions: string pointers pushed on stack
; registers changed: edx
goodbye PROC
	; setting up stack frame
	push		ebp
	mov ebp,	esp

	call crlf
	mov	edx,	[ebp + 12]
	call WriteString			; guess the TA
	call crlf
	mov  edx,	[ebp + 8]		; this is the offset for the address on the stack
	call WriteString
	call crlf

	mov esp,	ebp        
	pop ebp   
	ret
goodbye	ENDP
END main