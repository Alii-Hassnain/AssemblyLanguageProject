include irvine32.inc
IncludeLib Irvine32.lib
IncludeLib Kernel32.lib
IncludeLib User32.lib
include macros.inc

.data
	;Login Part

	accountFile byte "accountFile.txt",0
	
	passwordFile byte "passwordFile.txt",0

	scoreFile byte "scoreFile.txt",0

	nline byte " ",0dh,0ah,0

	



	userName byte 30 dup(?)
	userPassword byte  30 dup(?)

	userConfirmPassword byte 30 dup(?)

	loginName byte 30 dup(?)
	loginPass byte 30 dup(?)
	result byte 2 dup(?)

	lName dd ?
	lpass dd ?


	hdl1 handle ?
	hdl2 handle ?

	uName dd ?
	uPassword dd ?
	cpassword dd ?
	count dd ?



	;Game Part
	Score dd 10
	random dd ?
	InputNumber dd ?
	YesNo dd ?




	numberstring byte 16 DUP (0)
    numberChar DD 0
    fmt db "%d",0
    number dd 10
.code 

main PROC
	mov eax,black+(white*16)
	call settextcolor
	
	call clrscr
	call crlf
	call crlf
	call crlf
	call crlf
	call crlf
	call crlf
	mwrite "				|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
	call crlf
	call crlf
	call crlf
	call crlf
	mwrite "							WELCOME TO GUESSING GAME"
	call crlf
	call crlf
	call crlf
	call crlf
	mwrite "				|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
	
	call crlf
	call crlf
	call waitmsg

	start1:
	call clrscr
	call crlf
	call crlf
	call crlf
	mwrite ">>>>>>>>>>>>>>>>>>>>>>>>>"
	mwrite "	NOTE:: YOU HAVE TO CREATE THE ACCOUNT FIRST TO PLAY THE GAME"
	mwrite "	<<<<<<<<<<<<<<<<<<<<<<<<<"

	call crlf
	call crlf
	call crlf

	mwrite "			>>>"
	mwrite "	1.CREATE ACCOUNT"
	call crlf
	mwrite "			>>>"
	mwrite "	2.LOGIN"
	call crlf
	mwrite "			>>>"
	mwrite "	3.SHOW HIGHEST SCORE"
	call crlf
	call crlf
	mwrite "			>>>"
	mwrite "	4.EXIT"
	call crlf
	call crlf
	call crlf
	mwrite "	PLEASE ENTER THE NUMBER :: "
	call readint
	
	.if eax != 1 && eax != 2 && eax != 3 && eax != 4
		call crlf 
		call crlf
		call crlf
		mwrite "		WRONG INPUT"
		call crlf 
		call crlf
		call crlf
		call crlf
		call waitmsg
		jmp start1
	.endif

	.if eax == 4
		jmp exit1
		

	.elseif eax == 3
		jmp scoreCheck1
	.endif



	

	.if eax == 2
		call clrscr
		mov ebx,3
		call crlf
		mwrite "		>>>>>>>>>>>>>>>>>>>"
		mwrite "	WELCOME TO LOGIN MENUE"
		mwrite "	<<<<<<<<<<<<<<<<<<<"
		call crlf 
		call crlf
		mwrite "				YOU HAVE 3 ATTEMPTS TO LOGIN ELSE SIGN IN"	
		call crlf
		call crlf
		call crlf


	
		start3:
		.if ebx == 0
			jmp start1
		.endif
		mwrite "			ENTER YOUR NAME : "
		mov edx,offset loginName
		mov ecx,30
		call readstring
		mov lName,eax

		call crlf

		mwrite "			ENTER YOUR PASSWORD : "	
		mov edx,offset loginPass
		mov ecx,30
		call readstring
		mov lpass,eax

		call crlf
		mov edx,offset accountFile
		call openInputFile
		mov hdl1,eax

		mov edx,offset userName
		mov ecx,30
		mov eax,hdl1
		call readfromfile
		
		

		mov edx,offset nline
		mov ecx,3
		mov eax,hdl1
		call readfromfile

		mov edx,offset userPassword
		mov ecx,30
		mov eax,hdl1
		call readfromfile
		
		


		;Compare
		mov edi,0
		mov esi,0
		mov uname,30
		mov ecx,uname
		mov count,0
		Loop2:
			mov al,userName[esi]
			mov ah,loginName[edi]
			.if al == ah
				inc count
			.endif
			inc edi
			inc esi

		loop Loop2

		mov eax,count

		.if eax == uname
		.else
			call clrscr
			call crlf
			call crlf
			mwrite "				USER NAME OR PASSWORD INCORRECT"
			call crlf
			dec ebx
			mov eax,1000
			call delay
			;call waitmsg
			call crlf
			call crlf
			jmp start3
		.endif

		mov edi,0
		mov esi,0
		mov upassword,30
		mov ecx,upassword
		mov count,0
		Loop3:
			mov al,userPassword[esi]
			mov ah,loginPass[edi]
			.if al == ah
				inc count
			.endif
			inc edi
			inc esi

		loop Loop3

		mov eax,count
		.if eax == uPassword
			call crlf
			call crlf
			call crlf
			mwrite "			YOU ARE SUCCESSFULLY LOGGED IN"
			call crlf
			call crlf
			call crlf
			call waitmsg
		.else
			call clrscr
			call crlf
			call crlf
			mwrite "				USER NAME OR PASSWORD INCORRECT"
			call crlf
			dec ebx
			mov eax,1000
			call delay
			;call waitmsg
			call crlf
			call crlf
			jmp start3
		.endif




	.endif




	;Account Menue

	.if eax == 1
		call clrscr
		call crlf
		mwrite "		>>>>>>>>>>>>>>>>>>>"
		mwrite "	WELCOME TO CREATE ACCOUNT MENUE"
		mwrite "		<<<<<<<<<<<<<<<<<<<"
		call crlf 
		call crlf
		call crlf
		call crlf

		
		mwrite "			ENTER YOUR NAME : "
		mov edx,offset userName
		mov ecx,30
		call readstring
		mov uName,eax

		call crlf

		start2:
		mwrite "			ENTER YOUR PASSWORD : "	
		mov edx,offset userPassword
		mov ecx,30
		call readstring
		mov upassword,eax

		call crlf

		mwrite "			CONFIRM YOUR PASSWORD : "
		
		mov edx,offset userConfirmPassword
		mov ecx,30
		call readstring
		mov cpassword,eax

		mov eax,upassword
		.if eax != cpassword
			jmp Tocall1
		.endif
		

						;COMPARE
		mov edi,0
		mov esi,0

		mov ecx,upassword
		mov count,0
		Loop1:
			mov al,userPassword[esi]
			mov ah,userConfirmPassword[edi]
			.if al == ah
				inc count
			.endif
			inc edi
			inc esi

		loop Loop1

		mov eax,count
		.if eax == upassword
		.else
			ToCall1:
			call crlf
			call crlf
			mwrite "				PASSWORD DOES'NT MATCH"
			call crlf
			call crlf
			jmp start2
		.endif


		; writing into file

		mov edx,offset accountFile
		call createoutputfile
		mov hdl1,eax

		mov edx,offset userName
		mov ecx,30
		mov eax,hdl1
		call writetofile

		mov edx,offset nline
		mov ecx,3
		mov eax,hdl1
		call writetofile

		mov edx,offset userPassword
		mov ecx,30
		mov eax,hdl1
		call writetofile

		call closefile

		







		
			







		call crlf
		call crlf
		mwrite "			CREATING ACCOUNT ......."
		call crlf
		call crlf
		mov eax,1500
		call delay
		mwrite "			CONGRATULATIONS YOUR ACCOUNT HAS BEEN CREATED "
		call crlf
		call crlf
		call crlf
		call waitmsg

		jmp start1
		
		call crlf

	.endif
	
	

	




	




										;Game Part
	call clrscr
	call crlf
	call crlf
	call crlf
	mwrite "					WELCOME TO NUMBER GUESSING GAME"
	call crlf
	call crlf

	.repeat

	Check:
	mwrite "DO YOU WANT TO PLAY [yes:1 or No:2] = "
	call readint 
	call crlf
	mov YesNo,eax

	.if eax !=1 && eax !=2
		mwrite "WRONG INPUT"
		call crlf
		jmp Check
	.endif

	.if eax == 2
		jmp start1
	.endif


		
	
	call Randomize
	mov eax,10
	call randomRange
	mov random,eax
	

	
	mov Score,10
	mwrite "					TOTAL SCORES = "
	mov eax,Score
	call writedec


	call crlf


	L1:
	mov eax,Score
	.if eax <= 0
		jmp exit2
	.endif
		
	call crlf

	mwrite "ENTER THE NUMBER B/W 0 & 10 = "
	call readint
	mov InputNumber,eax
	call crlf

	.if eax > random
	call clrscr
		call crlf
		call crlf
		call crlf
		mwrite "					LAST NUMBER ENTERED = "
		call writedec
		call crlf
		mwrite "					Hint :: HIGH - Number THAN GUESS"
		call crlf
		mov eax,Score
		dec eax
		mov Score,eax
		mwrite "					YOUR SCORES ="
		call writedec
		call crlf
		jmp L1

	.elseif eax < random
	call clrscr
		call crlf
		call crlf
		call crlf
		mwrite "					LAST NUMBER ENTERED = "
		call writedec
		call crlf
		mwrite "					Hint :: LOW - Number THAN GUESS"
		call crlf
		mov eax,Score
		dec eax
		mov score,eax
		mwrite "					YOUR SCORES ="
		call writedec
		call crlf
		jmp L1

	.else
	call clrscr
		call crlf
		call crlf
		call crlf
		call crlf
		mwrite "					LAST NUMBER ENTERED = "
		call writedec
		call crlf
		
		mwrite "					NUMBER FOUND HURRAY!"	
		call crlf
		mov eax,Score

		mwrite "					YOU ARE JENIOUS :::::: "
		mov edx,offset loginName
		mov ecx,lName
		call writestring
		call crlf

		mwrite "					YOUR SCORES ="
		call writedec
		call crlf
		
		;;;;;;;;;;;;; converting number into string ;;;;;;;;;;;;;;;;;;;;;
		mov eax,score
		.if eax >= 9

			push score
			push offset fmt
			push offset numberstring
			call wsprintf
			mov numberChar,eax
			add esp,(3*4)
			mov edx,offset numberstring
			mov ecx,numberChar
			call writestring



			mov edx,offset scoreFile
			call createoutputfile
			mov hdl2,eax
		
			mov edx,offset userName
			mov ecx,30
			mov eax,hdl2
			call writetofile

			mov edx,offset nline
			mov ecx,3
			mov eax,hdl2
			call writetofile

			mov edx,offset numberstring
			mov ecx,numberChar
			mov eax,hdl2
			call writetofile

			mov eax,hdl2
			call closefile
		.endif

		mov eax,yesno
		jmp until1



	.endif


	exit2:
		call crlf
		mwrite "					YOU LOST THE GAME BETTER LUCK NEXT TIME"
		call crlf

	
	until1:

	.until eax != 1

	scoreCheck1:
		call clrscr
		mov edx,offset scorefile
		call openinputfile
		mov hdl2,eax

		mov edx,offset userName
		mov ecx,30
		mov eax,hdl2
		call readfromfile
		call writestring

		mov edx,offset nline
		mov ecx,3
		mov eax,hdl2
		call readfromfile

		mov edx,offset numberString
		mov ecx,16
		mov eax,hdl2
		call readfromfile

		call crlf
		call crlf
		
		mwrite "		>>>>>>>>>	WELCOME TO HIGHEST SCORE MENUE	<<<<<<<<"	
		call crlf
		call crlf
		call crlf
		call crlf
		mwrite "	Note: Your name will appear only if you obtain 9 or above score "
		call crlf
		call crlf
		call crlf
		
		mwrite "			NAME : "
		mov edx,offset userName
		mov ecx,30
		call writestring

		call crlf

		mwrite "			SCORE : "
		mov edx,offset numberstring
		mov ecx,16
		call writestring
		call crlf
		call crlf
		call crlf
		call waitmsg
		jmp start1
		
	exit1:
		call clrscr
		call crlf
		call crlf
		call crlf
		call crlf
		call crlf

		mwrite "					SEE YOU SOON"

		call crlf
		call crlf
		call crlf
		call crlf
		call crlf


exit
main endp 
end main


