INCLUDE Irvine32.inc

; For this assignment I would like to use two grace days

; Grant Conklin
; ID: 933-821-715
; Asignment Four
; Due: January 13, 2022
; Class: CS 271 section 001

UPPER_LIMIT EQU 300

.data
; Intro variables
titlestr	BYTE	"Hello and welcome to Composite Number Spreadsheet, otherwise known assume Program 4.", 0
myName		BYTE	"This was written by Grant Conklin.", 0
capability	BYTE	"This program is capable of generating a list of composite numbers.", 0
simply		BYTE	"Simply let me know how many you would like to see.", 0
Ill			BYTE	"I can accept orders for up to 300 numbers.", 0
; input variables
ask			BYTE	"How many composites do you want to view? [1 - 300]: ", 0
wrongEntry	BYTE	"You entered and integer outside of the [1 - 300] range, please try again.", 0 
numberIn	DWORD	?
; logic variables
remainder	DWORD	?
testNum		DWORD	4
numOutputed DWORD	0
rowIndex	DWORD	0



goodbyeStr	BYTE	"Thank you for using Grant Conklin's composite calculator, have a great day.", 0

.code
main PROC
;	; driver function to print, take input (has validation call), print the values (calls an is composite function), goodbye
	call intro
	call takeInput
	call crlf
	call printComposites
	call goodbye
	exit
main ENDP

intro PROC
	; simple procedure, 5 print statements where i add an extra line break once
	mov		 edx,			OFFSET	titlestr
	call	 WriteString
	call	 crlf
	mov		 edx,			OFFSET	myName
	call	 WriteString
	call	 crlf
	call	 crlf
	mov		 edx,			OFFSET	capability
	call	 WriteString
	call	 crlf
	mov		 edx,			OFFSET	simply
	call	 WriteString
	call	 crlf
	mov		 edx,			OFFSET	Ill
	call	 WriteString
	call	 crlf
	ret	
intro ENDP

; Procedure to take integer input from the user
; recieves: nothing
; returns: integer value the user entered in the eax register
; preconditions: eax doesn't need to be saved
; registers changed: eax
takeInput PROC
	; Read in an integer from the user
	mov		edx,		OFFSET	ask
	call	writestring
	call	ReadInt
	; Validate
	call validate
	ret
takeInput ENDP

; Procedure to validate a number is between 0 and 301
; recieves: integer value in eax
; returns: value stored in memory that is validated
; preconditions: user input in the eax register
; registers changed: eax
validate PROC
	checkBounds:
		; check the lower bound
		checkLower:
			cmp	eax,				1
			jl	outsideBounds			; outside bounds lower
			; else check upper
		; check the upper bound
		checkUpper:
			cmp	eax,				UPPER_LIMIT
			jg	outsideBounds				; outside bounds upper
			mov numberIn,			eax		; store the value
			jmp endProc						; skip the outside bounds routine
			; else continue with return and logic
	; if the number is outside the required bounds
	outsideBounds:
		mov		edx,				OFFSET	wrongEntry
		call	WriteString
		call	crlf
		call	takeInput
	endProc:
		ret
validate ENDP

; Procedure to print the number of composite numbers the user wants
; recieves: number of composites wanted
; returns: printed list of composite numbers
; preconditions: number wanted in RAM
; registers changed: ebx, eax, edx
printComposites PROC
	; start values (output counter++, test value counter++, remainder from check composite)
	nextNumber:
		call checkComposite
		mov  edx, remainder
		cmp  edx, 0
		je   printValue
		jne  increment

		printValue:
			; print the composite and the tab spacing character
			mov  eax, testNum
			call writeInt
			mov	 al, TAB
			call writeChar
			; increment number of values printed
			mov  eax, numOutputed
			inc  eax
			mov  numOutputed, eax
			cmp  eax, numberIn
			je   return
			; increment row index
			mov  eax, rowindex
			inc  eax
			mov  rowIndex, eax
			; testing to se if there are 10 numbers in the current line
			cmp  eax, 10
			je	 newLine
			jmp  noNewLine

			newLine:
				call crlf
				mov  eax, 0
				mov  rowIndex, eax
			noNewLine:				; this does nothing logically but gives a jump point for row index cmp

			increment:
				mov eax, testNum
				inc eax
				mov testNum, eax
				jmp nextNumber


	return:
		ret
printComposites ENDP

; Procedure to print the number of composite numbers the user wants
; recieves: current test number
; returns: boolean value of if the number is composite in edx 0 is composite
; preconditions: test value is in eax
; registers changed: eax, ebx, ecx, edx
checkComposite	PROC
	mov ebx, 2
	testDivide:
		; start by moving the number to be tested into eax
		mov eax, testNum
		cmp ebx, eax
		je  itself			; tests if we are dividing by the number itself
		; divide the test number by incrimenting values
		cdq
		div ebx
		cmp edx, 0
		je	composite		; if there is no remainder then it is composite

		inc ebx
		jmp testDivide	

	itself:					; returns a value of 1
		mov remainder, 1
		jmp return
	composite:				; returns a value of 0
		mov remainder, 0
		
	return:
		ret
checkComposite	ENDP

; Procedure to print goodbye message to terminal
; recieves: none
; returns: printed goodbye message to terminal
; preconditions: none
; registers changed: edx
goodbye PROC
	; simple enough, a few line breaks one goodbye print message and a return statement
	call	 crlf
	call	 crlf
	mov		 edx,			OFFSET	goodbyeStr
	call	 WriteString
	call	 crlf
	ret
goodbye ENDP

END main