INCLUDE Irvine32.inc

.data
; Intro
intro			BYTE	"Welcome to simple calculator with Grant Conklin!", 0
; Input
directions		BYTE	"You will be asked to enter two numbers, hit the enter key to input them.", 0
directionsTwo	BYTE	"Enter the first one here: ", 0
directionsThree	BYTE	"Enter the second one here: ", 0
inputOne		DWORD	?
inputTwo		DWORD	?
; Calculation
sum				DWORD	?
diff			DWORD	?
product			DWORD	?
quotient		DWORD	?
remainder		DWORD	?
; Print Output
sumOne			BYTE	"The sum of your two numbers is: ", 0
sumTwo			BYTE	".", 0
subOne			BYTE	"The difference of your two numbers is: ", 0
subTwo			BYTE	".", 0
prodOne			BYTE	"The product of your two numbers is: ", 0
prodTwo			BYTE	".", 0
divOne			BYTE	"The quotient of your two numbers is: ", 0
divTwo			BYTE	" with a remainder of: ", 0
divThree		BYTE	".", 0
; squares Extra Credit
square			BYTE	"Squares of the numbers extra credit:", 0
squareOne		BYTE	"The square of the first number is: ", 0
squareTwo		BYTE	"The square of the second number is: ", 0
period			BYTE	".", 0
sqOne			DWORD	?
sqTwo			DWORD	?
; goodbye
byeOne			BYTE	"Thank you for using simple calculator.", 0
byeTwo			BYTE	"Have a great day.", 0

.code
main PROC
	; INTRO
	mov		edx, OFFSET		intro
	call	WriteString
	call	Crlf

	; AQUIRE DATA
	mov		edx, OFFSET		directions
	call	WriteString
	call	Crlf
	mov		edx, OFFSET		directionsTwo
	call	Crlf
	call	WriteString

	; Get first num and store
	call	ReadInt
	mov		inputOne, eax
	; Directions plus second num then store
	mov		edx, OFFSET		directionsThree
	call	WriteString
	call	ReadInt
	mov		inputTwo, eax
	call	Crlf

	; CALCULATION
	; add
	mov		eax, inputOne
	add		eax, inputTwo
	mov		sum, eax
	; sub
	mov		eax, inputOne
	sub		eax, inputTwo
	mov		diff, eax
	; multiply
	mov		eax, inputOne
	cdq
	mov		ebx, inputTwo
	mul		ebx
	mov		product, eax
	; divide
	mov		eax, inputOne
	cdq
	mov		ebx, inputTwo
	div		ebx
	mov		quotient, eax
	mov		remainder, edx

	; print values
	; add
	mov		edx, OFFSET		sumOne
	call	WriteString
	mov		eax, sum
	call	WriteInt
	mov		edx, OFFSET		sumTwo
	call	WriteString
	call	Crlf
	; subtract
	mov		edx, OFFSET		subOne
	call	WriteString
	mov		eax, diff
	call	WriteInt
	mov		edx, OFFSET		subTwo
	call	WriteString
	call	Crlf
	; multiply
	mov		edx, OFFSET		prodOne
	call	WriteString
	mov		eax, product
	call	WriteInt
	mov		edx, OFFSET		prodTwo
	call	WriteString
	call	Crlf
	; divide
	mov		edx, OFFSET		divOne
	call	WriteString
	mov		eax, quotient
	call	WriteInt
	mov		edx, OFFSET		divTwo
	call	WriteString
	mov		eax, remainder
	call	WriteInt
	mov		edx, OFFSET		divThree
	call	WriteString
	call	Crlf

	; extra credit
	; calculation
	call	Crlf
	mov		edx, OFFSET		square
	call	WriteString
	call	Crlf
	mov		eax, inputOne
	cdq
	mov		ebx, inputOne
	mul		ebx
	mov		sqOne, eax
	mov		eax, inputTwo
	cdq
	mov		ebx, inputTwo
	mul		ebx
	mov		sqTwo, eax

	; print
	mov		edx, OFFSET		squareOne
	call	WriteString
	mov		eax, sqOne
	call	WriteInt
	mov		edx, OFFSET		period
	call	WriteString
	call	Crlf
	mov		edx, OFFSET		squareTwo
	call	WriteString
	mov		eax, sqTwo
	call	WriteInt
	mov		edx, OFFSET		period
	call	WriteString
	call	Crlf

	; goodbye
	call	Crlf
	mov		edx, OFFSET		byeOne
	call	WriteString
	call	Crlf
	mov		edx, OFFSET		byeTwo
	call	WriteString
	call	Crlf

	exit
main ENDP
END main