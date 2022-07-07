; Grant Conklin
; conkling@oregonstate.edu
; 1/22/2022
; Program 3

TITLE Fibonacci Calculator       (Grant_Conklin_Assignment_2.asm)

INCLUDE Irvine32.inc
; constant for comparison
UPPERLIMIT = 47

.data
helloOne	BYTE	"Hello and welcome to 'Fibonacci Calculator' with Grant Conklin.", 0
nameAsk		BYTE	"What is your name: ", 0
welcome		BYTE	"It's good to meet you ", 0
period		BYTE	".", 0
; username input
username	BYTE	20	DUP(0)          ; input buffer
byteCount	DWORD	?              ; holds counter
; fibonacci stuff
fibOne		BYTE	"How many fibonacci numbers do you want (1 - 46 please): ", 0
invlaid		BYTE	"You have entered and invalid number please enter an integer between 1 and 46.", 0
numwanted	DWORD	?
lines		DWORD	?
remainder	DWORD	?
outerReg	DWORD	?

; extra credit
ecZero		BYTE	"**EC: DESCRIPTION", 0
ecOne		BYTE	"I did the extra credit for this assignment by aligning the colums.", 0
ecTwo		BYTE	"This was done by printing the TAB char from the al regiseter within the index and finalLine procedures.", 0

; goodbye 
goodOne		BYTE	"Thank you for using 'Fibonacci Calculator'.", 0
goodTwo		BYTE	"Have a great day ", 0

.code
main PROC
	; Intro
	; this is fairly self explanatory 
	; it introduces me and the program title
	mov		edx,		OFFSET	helloOne
	call	writestring
	call	crlf

	; Display Instructions
	; this asks for the user's name
	mov		edx,		OFFSET	nameAsk
	call	writestring

	; Get User Info
	; Take input for user and store
	; also includes asking and taking input for number of fib sequence
	mov		edx,		OFFSET	username
	mov		ecx,		SIZEOF	username
	call	readstring
	mov		bytecount,  eax
	call	crlf
	; Welcome user by name
	mov		edx,		OFFSET	welcome
	call	writestring
	mov		edx,		OFFSET	username
	call	writestring
	mov		edx,		OFFSET	period
	call	writestring
	call	crlf
	; post test loop to validate the input
	takeinput: 
		mov		edx,		OFFSET	fibOne
		call	writestring
		call	ReadInt
		mov		numwanted,	eax
		call	crlf
	; validate between 1 - 46\
	checkUpper:
		mov eax, numwanted
		cmp	eax, UPPERLIMIT
		jge	wrong
		jl	checkLower
	checkLower:
		cmp	eax, 0
		jle	wrong
		jg	initialize
	; does not meet conditons (else)
	wrong:
		mov	edx,	OFFSET invlaid
		call writestring
		call crlf
		jmp takeinput
		call crlf

	; Display Fibs
	; logic for finding and creating the fibonacci nums
	; as well as displaying them in the format needed for the assignment
	initialize:
		; find num rows and number in final row
		mov		eax,  numwanted
		cdq
		mov		ebx, 4
		div		ebx
		mov		lines, eax
		mov		remainder, edx
		; set registers for fibonacii
		mov	ebx, 1
		mov	edx, 0
		mov ecx, eax
	; Checks if user wants less than 4 numbers
	partial:
		mov eax, lines
		cmp	eax, 0
		jne line
		mov ecx, remainder
		singleRow:
			mov     eax, ebx        
			add     eax, edx
			mov     ebx, edx
			mov     edx, eax
			call writedec
			mov	 al, TAB
			call writeChar
			call writeChar
			loop singleRow
		call crlf
		call crlf
		jmp	extraCredit
	; user wants greater than 4 numbers
	; loops rows of output
	line:
		mov	outerReg, ecx
		mov	 ecx, 4
		; loops columns of outputs
		index:
			; set regiseters
			mov     eax, ebx        
			add     eax, edx
			mov     ebx, edx
			mov     edx, eax
			; write output
			call writedec
			mov	 al, TAB
			call writeChar
			call writeChar
			loop index
			; reset ecx for line loop
			mov  ecx, outerReg
			call crlf
			loop line
	; checks if there is need for a partial line
	checkRemainder:
		mov	eax, remainder
		cmp	eax, 0
		je	preEC
	; prints partial line
	mov	ecx, remainder
	finalLine:
		mov     eax, ebx        
		add     eax, edx
		mov     ebx, edx
		mov     edx, eax
		
		call writeDec
		mov  al, TAB
		call writeChar
		call writeChar
		loop finalLine
	; add spacing
	call crlf
	call crlf
	jmp	 extraCredit
	; extra Credit
	preEC:
		call crlf
	extraCredit:
		mov		edx, OFFSET		ecZero
		call	WriteString
		call	Crlf
		mov		edx, OFFSET		ecOne
		call	WriteString
		call	Crlf
		mov		edx, OFFSET		ecTwo
		call	WriteString
		call	Crlf

	; Goodbye
	; displays a parting message with the user's name and a thank you
	mov		edx,		OFFSET	goodOne
	call	writestring
	call	crlf
	mov		edx,		OFFSET	goodTwo
	call	writestring
	mov		edx,		OFFSET	username
	call	writestring
	mov		edx,		OFFSET	period
	call	writestring
	call	crlf

	exit

main ENDP
END main
