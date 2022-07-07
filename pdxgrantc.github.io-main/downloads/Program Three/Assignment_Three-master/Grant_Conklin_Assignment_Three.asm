TITLE Add and Subtract, Version 2         (AddSub2.asm)

LOWERLIMIT = -100

; Grant Conklin
; Asignment Three
; Due: January 30, 2022

; OBJECTIVES
; 1. implementin data validation
; 2. Implementing an accumulator
; 3. Integer arithmetic
; 4. Defining variables (integer and string)
; 5. Using library procedures for I/O
; 6. Implementing control structures (decision, loop)

INCLUDE Irvine32.inc

.data
; Intro variables
titlestr	BYTE	"Hello and welcome to Average Calculator, otherwise known assume Program 3, with Grant Conklin", 0
nameAsk		BYTE	"What is your name: ", 0
welcome		BYTE	"It's good to meet you ", 0
period		BYTE	".", 0
; Users name and length
username	BYTE	20		DUP(0)							    ; input buffer
byteCount	DWORD	?											; holds counter

; Explanation of the program's purpose
exOne		BYTE	"This program will take n number of integers (-100 to -1) and find their average.", 0
exTwo		BYTE	"If you enter and integer below -100 it will not end the program but that value will not be in the average.", 0
exThree		BYTE	"At the end the average will be printed to the terminal.", 0

; Directions
dirOne		BYTE	"Please enter an integer between -100 and -1.", 0
dirTwo		BYTE	"If you would like to quit please enter a positive integer.", 0

; Ask for numbers
askNum		BYTE	"Press enter to input your integer here: ", 0

; Logic variables
currentNum	DWORD	?											; the number the user just enterd on the current loop iteration
runningSum	DWORD	0											; stores the running sum for all numbers enterd
halfNums	DWORD	?

; value outputs
numOfNums	DWORD	0											; stores the number of numbers that sum represents
quotient	DWORD	?											; stores the value after dividing
remainder	DWORD	?
numPrintOne	BYTE	"You entered ", 0
NumPrintTwo	BYTE	" numbers.", 0
totalOne	BYTE	"The sum of the numbers you entered is ", 0
qPrint		BYTE	"The average of your numbers is ", 0		; print statement when printing the quotient to the user


; special end where the user doen't enter any negative numbers
specialOne	BYTE	"You didn't enter any negative numbers; the program will now quit.", 0

; goodbye 
goodOne		BYTE	"Thank you for using Average Calculator (Assignment 3).", 0
goodTwo		BYTE	"Have a great day ", 0

.code
main PROC

	; Intro
	; this is fairly self explanatory ,"K

	; it introduces me and the program title
	mov		 edx,			OFFSET	titlestr
	call	 WriteString
	call	 crlf

	; Display Instructions
	; Explain the product what the outputs are
	mov		edx,		OFFSET	exOne
	call	writestring
	call	crlf
	mov		edx,		OFFSET	exTwo
	call	writestring
	call	crlf
	mov		edx,		OFFSET	exThree
	call	writestring
	call	crlf
	call	crlf
	; asks for the user's name
	mov		edx,		OFFSET	nameAsk
	call	writestring

	; Get User Info
	; Take input for user and store
	mov		edx,		OFFSET	username
	mov		ecx,		SIZEOF	username
	call	readstring						; read string into buffer
	mov		bytecount,  eax					; read length into memory

	; Welcome user by name by printing text then name then period
	mov		edx,		OFFSET	welcome
	call	writestring
	mov		edx,		OFFSET	username
	call	writestring
	mov		edx,		OFFSET	period
	call	writestring
	call	crlf
	call	crlf

	; Directions one and two string printouts
	; string one
	mov		edx,		OFFSET	dirOne
	call	writestring
	call	crlf
	; string two
	mov		edx,		OFFSET	dirTwo
	call	writestring
	call	crlf


	; Logic area
	mov ecx, 2
	mainLoop:
	; take the integer input from the use
	takeinput: 
		mov		edx,		OFFSET	askNum
		call	writestring
		call	ReadInt
		mov		currentNum,	eax
	; Validate the input for the bounds
	checkBounds:
		; check the lower bound
		checkLower:
			mov eax,			currentNum
			cmp	eax,			LOWERLIMIT
			jl	doneLogic					; outside bounds
			; else check upper
		; check the upper bound
		checkUpper:
			mov eax,			currentNum
			cmp	eax,			-1
			jg	outsideBounds				; outside bounds
			jle	addToSum
		; called when the user entered number is outside the -100 to -1 range
		outsideBounds:
			; check if this was the first number entered
			firstNum:
				mov eax,		numOfNums
				cmp	eax,		0
				je	specialEnd
				jmp	average				; this is the instruction when the user wants to quit it will find the average and quit normaly

		; add the number to the running total and increment the number of numbers
		addToSum:
			mov	eax,			runningSum
			add eax,			currentNum
			mov runningSum,		eax
			inc numOfNums

	; add to ecx to continue the loop
	doneLogic:
		mov ecx, 2
		loop mainLoop
					
	average:
		call	crlf
		; impliment division logic to print the average
		mov		eax,			runningSum
		cdq
		mov		ebx,			numOfNums
		idiv	ebx
		mov		quotient,		eax
		mov		remainder,		edx
		; remainder in edx
	
	round:
		; checking if the average division ended without remainder
		mov		eax,			remainder
		cmp		eax,			0
		je		printOutPuts
		cdq		
		mov		ebx,			-1		; multiply by -1 to be able to compare a
		imul	ebx
		mov		remainder,		eax

		; check if you need to round
		; find half the num of num
		mov		eax,			numOfNums
		;cdq		
		;mov		ebx,			-1		; multiply by -1 to be able to compare a
		;imul	ebx

		cdq
		mov		ebx,			-2
		idiv	ebx						; quotient in the eax remainder in edx
		mov		halfNums,		eax
		mov		eax,			edx		; move the remainder to eax
		cdq		
		mov		ebx,			-1		; multiply by -1 to be able to compare a
		imul	ebx

		cmp		eax,		0
		je		equal
		jne		notEqual

	equal:
		mov		eax,			halfNums
		cmp		eax,			remainder
		jle		subtractOne				; subrtract one from the average		
		jmp		printOutPuts			; no rounding needed

	notEqual:
		mov		eax,			halfNums
		add		eax,			1
		cmp		eax,			remainder
		jle		subtractOne				; add -1
		jmp		printOutPuts			; no rounding needed

	subtractOne:
		mov		eax,			quotient
		sub		eax,			1
		mov		quotient,		eax

	printOutPuts:
		; printing the strings to describe and number of numbers the user entered
		mov		edx,		OFFSET	numPrintOne
		call	writestring
		mov		eax,		numOfNums
		call	writeInt 
		mov		edx,		OFFSET	numPrintTwo
		call	writestring
		call	crlf
		mov		edx,		OFFSET	totalOne
		call	writestring
		mov		eax,		runningSum
		call	writeInt
		mov		edx,		OFFSET	period
		call	writestring
		call	crlf
		; printing the strings to intoduce the average as well as the average itself
		mov		edx,		OFFSET	qPrint
		call	writestring
		mov		eax,		quotient
		call	writeInt
		mov		edx,		OFFSET	period
		call	writestring
		call	crlf
		call	crlf

		jmp		goodbye
	; this is the ending if the user doens't enter any negative numbers
	specialEnd:
		mov		edx,		OFFSET	specialOne
		call	writestring
		call	crlf

	; Goodbye
	; displays a parting message with the user's name and a thank you
	goodbye:
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