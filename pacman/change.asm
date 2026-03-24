IDEAL
macro SHOW_MOUSE
    mov ax, 1
    int 33h
endm


macro HIDE_MOUSE
    mov ax, 2
    int 33h
endm

macro freight
	mov [bluefreight], 1
	mov [redfreight], 1
	mov [orangefreight], 1
	mov [freightcnt], 0

endm

macro nofreight
	mov [bluefreight], 0
	
	push offset blueshadowarray	
	push [blue_X]
    push [blue_y]
	call RemoveghostFromScreen

	mov [redfreight], 0
	
	push offset redshadow
	push [red_X]
    push [red_y]
	call RemoveghostFromScreen
	
	mov [orangefreight], 0
	
	push offset orangeshadow
	push [orange_X]
    push [orange_y]
	call RemoveghostFromScreen
endm

macro resetorangeplaces
	mov [bottomleft], 0
	mov [bottomrightcorener], 0
	mov [topright], 0
	mov [topleft], 0

	
endm

MODEL small
STACK 0f500h

SCREEN_WIDTH = 320  
SCREEN_HEIGHT = 200

RIGHT_ARROW = 4d00h
LEFT_ARROW = 4b00h
DOWN_ARROW = 5000H
UP_ARROW = 4800H
ENTERKey = 1c0dh 
white = 0f6h
lightblue = 0d2h
pointcollor = 0ffh

pointcol = 066h

BLUE = 0FCH

blueghostcol = 0FEH

redghostcol = 0f9h

orangeghostcol = 067h

paccollor = 0fbh

ESCAPE = 011BH


freightcollor = 0c4h
BLOCK_SIZE = 32

DATASEG
	
	IntStr db 7 dup (' '), "$"
	FileLength dw ?
	FileFound db ?
	FileCreated  db ?
	FatalError db ?
	scorefile db 'Score.txt',0
	ReadBuff db BLOCK_SIZE dup(?),'$' 

	pacnotes dw 10000, 9000 
	pacnotesduration dw 100, 100
	winbool db 0
	gotdir db 4
	highscore dw 0
	health db 3

	result dw 0
	number dw ?		
	hs db 'HS.bmp', 0
	MainMenu db 'MainM.bmp', 0
	redexit db 'redexit.BMP', 0
	redplay db 'REDPLAY.bmp',0 
	whiteexit db 'WHITEE.bmp', 0
	whiteplay db 'WHITEP.bmp', 0
	
	freightanim db 'freight.bmp', 0
	
	boolean db 0
	pacmap db 'green.bmp', 0
	pacleft db 'Pachal.bmp', 0,'PacOpL.bmp', 0
	pacclose db 'Paclose.bmp', 0
	deletebmp db 'delete.bmp', 0
	pacright db 'PacHR.bmp',0, 'PacOR.bmp', 0
	pacup db 'PacHU.bmp', 0, 'PacOU.bmp', 0
	pacdown db 'PacDH.bmp',0, 'pacDO.bmp', 0
	
	resetip dw 4dh
	
	BIGWIN DB 'BIGWIN.bmp', 0
	
	redghostleft db 'REDLEFT.bmp', 0
	redghostright db 'REDRIGHT.bmp', 0
	redghostup db 'REDUP.bmp', 0
	redghostdown db 'REDDOWN.bmp',0
	
	blueghostright db 'BLUER.bmp', 0
	blueghostleft db 'BLUELEFT.bmp', 0
	blueghostup db 'BLUEUP.bmp', 0
	blueghostdown db'BLUEDOWN.bmp', 0

	blueghostforcedir db 0
	
	orangeghostleft db 'ORANGEL.bmp', 0
	orangeghostright db 'ORANGER.bmp', 0
	orangeghostdown db 'ORANGED.bmp',0
	orangeghostup db 'ORANGEUP.bmp', 0
	
	ghostcnt db 0
	skipeat dw 0
	
	orangeshadow db 11*11 dup(?)
	blueshadowarray	db 11*11 dup(?)
	redshadow db 11*11 dup(?)
	
	mmexit db 0
	
	orangeforceleft db 0
	orangeforceright db 0
	orangeforcedown db 0
	
	bottomrightcorener db 0
	topright db 0
	bottomleft db 0
	topleft db 0

	
	ghostorpac db 0
	
	
	redghostlastdir db 0
	redghostlastcol db 0
	
	orange_x dw 158
	orange_y dw 79
	orangenomove db 0
	orangeonscreen dw 0
	orangelastdir db 0 ; 1 = left 2 = right 3 = up 4 = down
	
	
	cantmove db 0
	red_x dw 130
	red_y dw 79
	redonscreen dw 0
	
	
	
	blue_x dw 178
	blue_y dw 79
	blueonscreen dw 0
	
	
	pac_X dw 150 ; 150
	pac_y dw 152 ; 152
	paconscreen dw 0
	
	minonscreen dw 0
	
	resetrandomdir db 0
	
	ghostfreightned db 0
	bluefreight db 0
	orangefreight db 0
	redfreight db 0
	freightcnt dw 0
	
	gameover db 0
	clear db 0
	FileHandle dw ?
	header db 54 dup(0)
	Palette db 400h dup (0)
	BmpLeft dw ?
	BmpTop dw ?
	BmpWidth dw ?
	BmpHeight dw ?
	ErrorFile db 0
	BmpFileErrorMsg db 'Error At Opening Bmp File ', 0dh, 0ah,'$'
	ScrLine 	db SCREEN_WIDTH dup (0)
	
	clearbmp db 'clear.bmp', 0
	
	StrScore db "Score: "
    lenStrScore = $-StrScore
	score dw 0
	gamescore dw 0
	checker dw ?
	ipsave dw ?
	lastdirection db 0
	waitfordirection db ?
	cnt db ?
	foundpoint db 0
	skipmm db 0
	
	
	
		    tones dw 830, 622, 740, 554, 830, 622, 740, 554, 830, 622, 740, 554, 659, 494, 784, 523, 659, 494, 784, 523, 659, 494, 784, 523, 659, 494, 784, 523, 698, 466
    duration dw 100       ; Duration of each tone (in milliseconds)
    short_duration dw 20  ; Short duration for spacing between tones (in milliseconds)
    divisor dd 1193180    ; Divisor constant for PIT
    counter dw 0          ; Counter for loop iterations
	
	
	
	
	
	
	
	
	CODESEG
	
start:

	mov ax, @data
	mov ds, ax
	call SetGraphic
	
	call mouse
	cmp [skipmm], 1
	je skipmainmenu
	call MainMenuproc
checkexit:
	cmp [mmexit], 1
	je TOexit
	
skipmainmenu:
	push 0
	push 0
	mov [BmpWidth], 320
	mov [BmpHeight], 200
	lea dx, [pacmap]
	call OpenShowBmp       ;print map

	

	jmp resetpoint ;if no exit go to start the game
TOexit:
	jmp exit

resetpoint:
	

	mov [BmpWidth], 11
	mov [BmpHeight] ,11

	push offset redshadow
	push offset redghostdown
	push [red_x]
	push [red_y]
	call PutghostOnScreen ; print red ghost

	


	push offset blueshadowarray	
	push offset	blueghostup
	push [blue_X]
    push [blue_y]
	call PutghostOnScreen	;same as red
	

	
	push offset orangeshadow	
	push offset orangeghostleft
	push [orange_X]
    push [orange_y]
	call PutghostOnScreen	;same as red
	

	
	
	
	
	lea dx,[pacclose]
	push [pac_X]
	push [pac_y]
	call OpenShowBmp ; print pacman


	call checklife ;print the life of pacman at the top left of the screen


gameloop:
	call tunnels
	call checkwin
	cmp [winbool], 1
	je win
	; cmp [lastdirection], 0
	; je checkforkey
	call showscore
	call ghostAlgo
checkforkey:	
	call movment
	cmp ax, ESCAPE
	je exit
	; mov ah, 0
	; int 16h
	jmp gameloop
	
win:
	mov [health], 3
	mov [BmpWidth], 320
	mov [BmpHeight], 200
	push 0
	push 0
	lea dx, [BIGWIN]
	call OpenShowBmp
	mov ah, 0
	int 16h
	jmp start
exit:

	
	
	mov ax,2
	int 10h
	
	mov ax, 4c00h
	int 21h
	
;30, 8
;144,120
	
proc endsleep
	mov cx, 65000
endloop:

loop endloop
	ret
endp endsleep

proc checkwin
	cmp [gamescore], 1220
	je movewin
	mov [winbool], 0
	ret              ; Return
	
movewin:
	mov [winbool], 1 ; Set winbool to 1
	mov [gamescore], 0
	mov [skipmm], 1
	call reset
	ret              ; Return

endp checkwin


proc tunnels
	cmp [bluefreight], 1
	je @@orangecheck
	push offset blue_X
	push offset blue_y
	call movethroughtunnels
@@orangecheck:
	cmp [orangefreight], 1
	je @@redcheck
	push offset orange_x
	push offset orange_y
	call movethroughtunnels
@@redcheck:
	cmp [redfreight], 1
	je @@pac
	push offset red_X
	push offset red_y
	call movethroughtunnels
@@pac:
	push offset pac_X
	push offset pac_y
	call movethroughtunnels
	ret
	

endp tunnels



proc movethroughtunnels
	push bp
	mov bp, sp
	mov si, [bp+4]  ;yoffset
	mov di, [bp+6] ;xoffset
	
	cmp [word ptr di], 1
	jnl nexttun

	mov [word ptr di], 319
	dec [word ptr si]
	jmp @@ret
nexttun:
	cmp [word ptr di], 319
	jng @@ret
	mov [word ptr di], 0
	inc [word ptr si]

	
@@ret:
	pop bp
	ret 4
endp movethroughtunnels



proc checklife
	
	cmp [health], 3
	je print3
	
	cmp [health], 2
	je print2
	
	
	jmp print1
	
print3:
	lea dx, [pacclose]
	push 0
	push 0
	call OpenShowBMP
	
	lea dx, [pacclose]
	push 11
	push 0
	call OpenShowBMP
	
	lea dx, [pacclose]
	push 22
	push 0
	call OpenShowBMP
	ret
print2:
	lea dx, [pacclose]
	push 0
	push 0
	call OpenShowBMP
	
	lea dx, [pacclose]
	push 11
	push 0
	call OpenShowBMP
	
	lea dx, [deletebmp]
	push 22
	push 0
	call OpenShowBmp
	ret
print1:
	lea dx, [pacclose]
	push 0
	push 0
	call OpenShowBMP
	
	lea dx, [deletebmp]
	push 11
	push 0
	call OpenShowBMP
	ret
endp checklife

proc MainMenuproc
	
	push 0
	push 0
	mov [BmpWidth], 320
	mov [BmpHeight], 200
	lea dx, [MainMenu]
	call OpenShowBMP

	mov [BmpWidth], 30
	mov [BmpHeight], 8
	lea dx, [redplay]
	push 144 ; x
	push 120 ; y
	call OpenShowBmp
mainmenuloop:	
	call CheckAndReadKey
	cmp ax, DOWN_ARROW
	jne ok
	mov [mmexit], 1
	
	lea dx, [whiteplay]
	push 144
	push 120
	call OpenShowBmp
	
	lea dx, [redexit]
	push 143
	push 140
	call OpenShowBmp
ok:
	cmp ax, UP_ARROW
	jne checkenter
	mov [mmexit], 0
	lea dx, [whiteexit]
	push 143 
	push 140 
	call OpenShowBmp
	
	lea dx, [redplay]
	push 144
	push 120
	call OpenShowBmp
checkenter:
	cmp ax, ENTERKey
	je @@ret
	inc [ghostcnt]
	jmp mainmenuloop
	
	
@@ret:
	ret
endp MainMenuproc
	
proc checkghosts
	
	cmp [ghostorpac], 1
	jne @@pacman
	jmp death

	
@@pacman:

	cmp al, blueghostcol
	je death
	
	cmp al, orangeghostcol
	je death

	cmp al, BLUEghostcol
	je death

	ret


death:	
	call eatghost
	cmp di, 1
	jne downlife
	
downlife:
	dec [health]
	cmp [health], 0
	je finaldeath
	
	call reset
	push [resetip]
	ret 10
	
	
	
	
finaldeath:
	call bestscore
	
	mov ax,2
	int 10h
	
	mov ax, 4c00h
	int 21h
	
		
endp checkghosts



proc ClearScreen
	mov [BmpWidth], 320
	mov [BmpHeight], 200
	push 0
	push 0
	lea dx, [clearbmp]
	call OpenShowBmp
	ret

endp ClearScreen


proc resetorange
	mov [orangefreight], 0
	
	push offset orangeshadow
	push [orange_X]
    push [orange_y]
	call RemoveghostFromScreen
	
	
	mov [orange_x], 178
	mov [orange_y], 79
	
	lea dx, [orangeghostup]
	push offset orangeshadow
	push dx
	push [orange_x]
	push [orange_y]
	call PutghostOnScreen
	
	lea dx, [orangeghostup]
	push [orange_X]
    push [orange_y]
	call OpenShowBMP

	ret
endp resetorange

proc resetred
	mov [redfreight], 0
	
	push offset redshadow
	push [red_X]
    push [red_y]
	call RemoveghostFromScreen
	
	mov [red_x], 178
	mov [red_y], 79


	lea dx, [redghostup]
	push offset redshadow
	push dx
	push [red_x]
	push [red_y]
	call PutghostOnScreen
	
	lea dx, [redghostup]
	push [red_X]
    push [red_y]
	call OpenShowBMP
	ret
endp resetred

proc resetblue
	mov [bluefreight], 0
	
	push offset blueshadowarray	
	push [blue_X]
    push [blue_y]
	call RemoveghostFromScreen
	
	mov [blue_x], 178
	mov [blue_y], 79
	
	
	lea dx, [blueghostup]
	push offset blueshadowarray
	push dx
	push [blue_x]
	push [blue_y]
	call PutghostOnScreen
	
	lea dx, [blueghostup]
	push [blue_X]
    push [blue_y]
	call OpenShowBMP

	ret
endp resetblue

proc eatghost
	cmp [skipeat], 1
	jne @@noskip
	jmp @@skip
@@noskip:
	mov dx, [blue_X]
	mov cx, [blue_y]
	call getXYonScreen
	mov [blueonscreen],ax
	mov ax, 6
	mov dx, [orange_X]
	mov cx, [orange_y]
	call getXYonScreen
	mov [orangeonscreen],ax
	
	mov dx, [red_X]
	mov cx, [red_y]
	call getXYonScreen
	mov [redonscreen], ax 
	
	mov dx, [pac_X]
	mov cx, [pac_y]
	call getXYonScreen

	mov bx, [blueonscreen]
	mov cx, [orangeonscreen]
	mov dx, [redonscreen]
	
	sub bx, ax
	sub cx, ax
	sub dx, ax
	
	test bx, bx
	jns skipbx
	neg bx
skipbx:
	test cx, cx
	jns skipcx
	neg cx
skipcx:
	test dx, dx
	jns skipdx
	neg dx
	
skipdx: ;blue = 1 orange = 2 red = 3   ; blue = bx 		orange = cx 	red = dx
	mov [minonscreen],1
	cmp bx, cx
	jb checkdx
	mov [minonscreen],2
checkdx:	
	cmp [minonscreen], 1
	je bxdx
	cmp [minonscreen], 2
	je cxdx
	
bxdx:
	cmp bx, dx
	jb eatblue
	mov [minonscreen], 3
cxdx:
	cmp cx,dx
	jb eatorange
	mov [minonscreen], 3
	
	
	cmp [minonscreen], 1
	je eatblue
	
	cmp [minonscreen], 2
	je eatorange
	
	jmp eatred
		
eatblue:
	cmp [skipeat], 0
	jne @@skip
	cmp [bluefreight], 1
	jne eatorange
	call resetblue
	mov di, 1
	mov [skipeat], 1
	ret
eatorange:
	cmp [skipeat], 0
	jne @@skip
	cmp [orangefreight], 1
	jne eatred
	call resetorange
	mov di, 1
	mov [skipeat], 1
	ret
eatred:
	cmp [skipeat], 0
	jne @@skip
	
	cmp [redfreight], 1
	jne @@ret
	call resetred
	mov di, 1
	mov [skipeat], 1
	ret
	
	
	

 @@ret:
	 mov di, 0

	ret
@@skip:
	dec [skipeat]
	ret
endp eatghost





	
proc attemptdown
	call ghostAlgo
	call showscore
	call CheckAndReadKey
	cmp ax, LEFT_ARROW	
	je @@leftret
	
	cmp ax, RIGHT_ARROW
	je @@rightret
	
	cmp ax, UP_ARROW
	je @@upret
	
	inc [pac_y]
	push [pac_X]
	push [pac_y]
	mov [ghostorpac], 0
	call downcollision
	dec [pac_y]
	cmp [cnt], 200
	je @@ret
	cmp al, BLUE
	jne @@ret

	cmp [lastdirection], 1
	jne @@right
	call leftanimation
	inc [cnt]
	jmp attemptdown
	
@@right:



	call rightanimation
	inc [cnt]
	jmp attemptdown

	mov ax, 19
@@ret:
	ret
	
	
@@upret:
	inc [ghostcnt]
	call upanimation
	ret
@@rightret:
	call rightanimation
	ret
@@leftret:
	call leftanimation
	ret
endp attemptdown

proc attemptup
	call ghostAlgo
	call showscore
	call CheckAndReadKey
	cmp ax, LEFT_ARROW	
	je @@leftret
	
	cmp ax, RIGHT_ARROW
	je @@rightret
	
	cmp ax, DOWN_ARROW
	je @@downret
	dec [pac_y]
	push [pac_X]
	push [pac_y]
	mov [ghostorpac], 0
	call upcollision
	inc [pac_y]
	cmp [cnt], 200
	je @@ret
	cmp al, BLUE
	jne @@ret
	
	cmp [lastdirection], 1
	jne @@right
	call leftanimation
	inc [cnt]
	jmp attemptup
	
@@right:



	call rightanimation
	inc [cnt]
	jmp attemptup



@@ret:
	ret
	
@@downret:
	call downanimation
	ret
@@rightret:
	call rightanimation
	ret
@@leftret:
	call leftanimation
	ret
endp attemptup





proc attemptright
	call showscore
	call ghostAlgo
	call CheckAndReadKey
	cmp ax, LEFT_ARROW	
	je @@leftret
	
	cmp ax, UP_ARROW
	je @@upret
	
	cmp ax, DOWN_ARROW
	je @@downret
	inc [pac_X]
	push [pac_X]
	push [pac_y]
	mov [ghostorpac], 0
	call rightcollision
	dec [pac_X]
	cmp [cnt], 200
	je @@ret
	cmp al, BLUE
	jne @@ret


	cmp [lastdirection], 3
	jne @@up
	call downanimation
	inc [cnt]
	jmp attemptright
	
@@up:


	call upanimation
	inc [cnt]
	jmp attemptright




@@ret:
	ret
	
@@downret:
	inc [ghostcnt]

	call downanimation
	ret
@@upret:
	call upanimation
	ret
@@leftret:
	inc [ghostcnt]

	call leftanimation
	ret
endp attemptright


proc attemptleft
	call showscore
	call ghostAlgo
	call CheckAndReadKey
	cmp ax, RIGHT_ARROW	
	je @@rightret
	
	cmp ax, UP_ARROW
	je @@upret
	
	cmp ax, DOWN_ARROW
	je @@downret
	dec [pac_X]
	push [pac_X]
	push [pac_y]
	mov [ghostorpac], 0
	call leftcollision
	inc [pac_X]
	cmp [cnt], 200
	je @@ret
	cmp al, BLUE
	jne @@ret


	cmp [lastdirection], 3
	jne @@up
	call downanimation
	inc [cnt]
	jmp attemptleft
	
@@up:


	call upanimation
	inc [cnt]
	jmp attemptleft




@@ret:
	ret
	
@@downret:
	inc [ghostcnt]

	call downanimation
	ret
@@upret:
	inc [ghostcnt]

	call upanimation
	ret
@@rightret:
	call rightanimation
	ret
endp attemptleft





proc PrintScore

	call ClearScreen
	mov ah ,1 
	int 21h
    mov dx, offset HS
    push 52
    push 3
    mov [BmpWidth], 216
    mov [BmpHeight], 261
    call OpenShowBmp

    ; jc @@ErrorFile

    ; Position cursor
    mov ah, 02h
    xor bh, bh
    mov dh, 2
    mov dl, 19
    int 10h

    call getscore;return score in intstr to str_to_int
	
	call str_to_int ;return score in ax
	
	call SaveScore
	jmp @@ret
 @@ErrorFile:
    ; Handle error in file operations
    mov dx, offset BmpFileErrorMsg
    mov ah, 09h
    int 21h
@@ret:	 
	ret
endp PrintScore 



proc bestscore
	call PrintScore
	mov ah, 0
	int 16h
	call ClearScreen
	ret
	
	
	

endp bestscore








proc leftanimation
    lea dx, [pacclose]
    push [pac_X]
    push [pac_y]
    call OpenShowBmp
    call sleep

    dec [pac_x]
    push [pac_X]
    push [pac_y]
	mov [ghostorpac], 0
    call leftcollision
    cmp al, BLUE
    je @@collisionfound
    cmp [foundpoint], 1 
    jne @@continue
    add [score], 5
	add [gamescore], 5
    mov [foundpoint], 0

@@continue:
    cmp [boolean], 0
    jne @@booleantrue
    mov si, 11
    xor [boolean], 1

@@booleantrue2:
    lea dx, [pacleft]
    add dx, si
    push [pac_x]
    push [pac_y]
    call OpenShowBMP
    call sleep

    mov [lastdirection], 1
    ret

@@booleantrue:
    mov si, 0
    xor [boolean], 1
    jmp @@booleantrue2

@@collisionfound:
    lea dx, [pacclose]
    inc [pac_x]
    push [pac_X]
    push [pac_y]
    call OpenShowBmp
    ret
endp leftanimation

proc rightanimation
    lea dx, [pacclose]
    push [pac_X]
    push [pac_y]
    call OpenShowBmp
    call sleep

    inc [pac_x]
    push [pac_X]
    push [pac_y]
	mov [ghostorpac], 0
    call rightcollision
    cmp al, BLUE
    je @@collisionfound
    cmp [foundpoint], 1 
    jne @@continue
    add [score], 5
		add [gamescore], 5
    mov [foundpoint], 0

@@continue:
    cmp [boolean], 0
    jne @@rightanimcheck2
    mov si, 10
    xor [boolean], 1

@@rightanimcheck:
    push [pac_x]
    push [pac_y]
    lea dx, [pacright]
    call OpenShowBMP
    call sleep

    mov [lastdirection], 2
    ret

@@rightanimcheck2:
    mov si, 0
    xor [boolean], 1
    jmp @@rightanimcheck

@@collisionfound:
    lea dx, [pacclose]
    dec [pac_x]
    push [pac_X]
    push [pac_y]
    call OpenShowBmp
    ret
endp rightanimation




proc upanimation
    lea dx, [pacclose]
    push [pac_X]
    push [pac_y]
    call OpenShowBmp
    call sleep
    
    dec [pac_y]  
    push [pac_X]
    push [pac_y]
	mov [ghostorpac], 0
    call upcollision  
    cmp al, BLUE
    je @@collisionfound
    cmp [foundpoint], 1 
    jne @@continue
    add [score], 5 
		add [gamescore], 5
    mov [foundpoint], 0

@@continue:
    mov si, 0  
    cmp [boolean], 0
    jne @@checkupanim2
    mov si, 10
    xor [boolean], 1

@@checkupanim:
    lea dx, [pacup]
    add dx, si  
    push [pac_X]
    push [pac_y]
    call OpenShowBmp
    call sleep
    
    mov [lastdirection], 4
    ret

@@checkupanim2:
    xor [boolean], 1
    jmp @@checkupanim

@@collisionfound:
    lea dx, [pacclose]
    inc [pac_y] 
    push [pac_X]
    push [pac_y]
    call OpenShowBmp
    ret
endp upanimation

proc downanimation
    lea dx, [pacclose]
    push [pac_X]
    push [pac_y]
    call OpenShowBmp
    call sleep

    inc [pac_y]  
    push [pac_X]
    push [pac_y]
	mov [ghostorpac], 0
    call downcollision 
    cmp al, BLUE
    je @@collisionfound
    cmp [foundpoint], 1 
    jne @@continue
    add [score], 5 
	add [gamescore], 5
    mov [foundpoint], 0

@@continue:
    mov si, 0 
    cmp [boolean], 0
    jne @@checkdownaim2
    mov si, 10
    xor [boolean], 1

@@checkdownaim:
    lea dx, [pacdown]
    add dx, si  
    push [pac_X]
    push [pac_y]
    call OpenShowBmp
    call sleep

    mov [lastdirection], 3
    ret

@@checkdownaim2:
    xor [boolean], 1
    jmp @@checkdownaim

@@collisionfound:
    lea dx, [pacclose]
    dec [pac_y]  ; Move the sprite up to its previous position
    push [pac_X]
    push [pac_y]
    call OpenShowBmp
    ret 
endp downanimation




objX equ [bp + 6]
objY equ [bp + 4]

proc leftcollision
	push bp
	mov bp, sp
	
	mov dx, objY
	mov di, 0
	mov cx, objX
leftcollisionloop:
	mov ah, 0dh
	mov bh, 0
	int 10h
	mov ah, 0
	cmp [ghostorpac], 1
	jne @@pacman
	
	cmp al, BLUE	
	je @@ret
	cmp al, blueghostcol
	je @@ret
	cmp al, redghostcol
	je @@ret
	cmp al, orangeghostcol
	je @@ret
	cmp al, paccollor
	jne @@nopoint
	jmp @@ret
	
@@pacman:	

	call checkghosts
	
	cmp al, freightcollor
	jne @@noeat
	call eatghost
@@noeat:
	
	cmp al, pointcol
	jne @@notfreight
	freight
@@notfreight:
	
	
	cmp al, BLUE	
	je @@ret
	
	cmp al, pointcollor
	jne @@nopoint
	mov [foundpoint], 1
@@nopoint:
	inc dx
	inc di
	cmp di, 11 
	jne leftcollisionloop
	
	
@@ret:
	pop bp
	ret 4
endp leftcollision


proc upcollision
	push bp
	mov bp, sp
	mov dx, objY
	mov cx, objX
	mov di, 0
upcollisionloop:
	mov ah, 0dh
	mov bh, 0
	int 10h
	mov ah, 0
	cmp [ghostorpac], 1
	jne @@pacman
	cmp al, BLUE	
	je @@ret
	
	cmp al, blueghostcol
	je @@ret
	cmp al, redghostcol
	je @@ret
	cmp al, orangeghostcol
	je @@ret
	
	cmp al, paccollor
	jne @@nopoint
	jmp @@ret
@@pacman:	
	call checkghosts
	cmp al, freightcollor
	jne @@noeat
	call eatghost
@@noeat:
	
	cmp al, pointcol
	jne @@notfreight
	freight
@@notfreight:
	cmp al, BLUE	
	je @@ret
	
	cmp al, pointcollor
	jne @@nopoint
	mov [foundpoint], 1
@@nopoint:
	inc cx
	inc di
	cmp di, 11
	jne upcollisionloop


@@ret:
	pop bp
	ret 4
endp upcollision


proc rightcollision
	push bp
	mov bp, sp
	
	mov dx, objY
	mov cx, objX
	add cx, 10
	mov di, 0
rightcollisionloop:
	mov ah, 0dh
	mov bh, 0
	int 10h
	mov ah, 0
	cmp [ghostorpac], 1
	jne @@pacman
	cmp al, BLUE	
	je @@ret
	cmp al, blueghostcol
	je @@ret
	cmp al, redghostcol
	je @@ret
	cmp al, orangeghostcol
	je @@ret
	cmp al, paccollor
	jne @@nopoint
	jmp @@ret
@@pacman:	
	call checkghosts
	cmp al, freightcollor
	jne @@noeat
	call eatghost
@@noeat:
	
	cmp al, pointcol
	jne @@notfreight
	freight
@@notfreight:
	
	
	cmp al, BLUE	
	je @@ret
	
	cmp al, pointcollor
	jne @@nopoint
	mov [foundpoint], 1
@@nopoint:	
	inc dx
	inc di
	cmp di, 11
	jne rightcollisionloop
	
	
	
@@ret:	
	pop bp
	ret 4
endp rightcollision


proc downcollision
	push bp
	mov bp, sp
	
	mov cx, objX
	mov di, 0
	mov dx, objY
	add dx, 10
	mov di, 0
downcollisionloop:
	mov ah, 0dh
	mov bh, 0
	int 10h
	mov ah, 0
	
	cmp [ghostorpac], 1
	jne @@pacman
	
	cmp al, BLUE	
	je @@ret
	cmp al, blueghostcol
	je @@ret
	cmp al, redghostcol
	je @@ret
	cmp al, orangeghostcol
	je @@ret
	cmp al, paccollor
	jne @@nopoint
	jmp @@ret
@@pacman:	
	call checkghosts
	
	cmp al, freightcollor
	jne @@noeat
	call eatghost
@@noeat:
	cmp al, pointcol
	jne @@notfreight
	freight
@@notfreight:
	cmp al, BLUE	
	je @@ret
	
	cmp al, pointcollor
	jne @@nopoint
	mov [foundpoint], 1
	

@@nopoint:	
	inc cx
	inc di
	cmp di, 11
	jne downcollisionloop


@@ret:
	pop bp
	ret 4
	
endp downcollision



proc 	CheckAndReadKey
	  mov ah ,1
	  int 16h
	  pushf
	  jz @@return 
	  mov ah ,0
	  int 16h

@@return:	
	  popf
	  ret
endp CheckAndReadKey
	
proc delete
	push bp
	mov bp, sp
	
	lea dx, [deletebmp]

	push objX
	push objy
	call OpenShowBmp
	
	pop bp
	ret 4
endp delete

	
proc reset 
	
	nofreight
	lea dx, [deletebmp]
	push [pac_x]
	push [pac_y]
	call OpenShowBMP
	
	push offset redshadow
	push [red_x]
	push [red_y]
	call RemoveghostFromScreen
	
	push offset blueshadowarray	
	push [blue_X]
    push [blue_y]
	call RemoveghostFromScreen
	
	
	push offset orangeshadow	
	push [orange_X]
    push [orange_y]
	call RemoveghostFromScreen
	
	
	mov [lastdirection], 0
	mov [topright], 0
	mov [bottomrightcorener], 0
	

	mov [pac_X], 168
	mov [pac_y], 152
	
	mov [blue_x], 178
	mov [blue_y], 79
	
	
	mov [red_X], 129
	mov [red_y], 79
	
	mov [orange_X], 155
	mov [orange_y], 79
	

	mov cx, 11*11
	mov si, 0
loopredshadow:
	mov [redshadow+si], 0
	mov [orangeshadow+si], 0
	mov [blueshadowarray+si], 0
	inc si
	loop loopredshadow

	mov [lastdirection], 0
	ret

endp reset

proc OpenShowBmp 
	pop [ipsave]
	mov [ErrorFile],0
	 
	call OpenBmpFile
	cmp [ErrorFile],1
	je @@ExitProc
	
	call ReadBmpHeader
	
	call ReadBmpPalette
	
	call CopyBmpPalette
	
	call ShowBMP
	
	 
	call CloseBmpFile

@@ExitProc:
	push [ipsave]
	ret 4
endp OpenShowBmp

 
 
	
proc OpenBmpFile							 
	mov ah, 3Dh
	xor al, al
	int 21h
	jc @@ErrorAtOpen
	mov [FileHandle], ax
	jmp @@ExitProc
	
@@ErrorAtOpen:
	mov [ErrorFile],1
@@ExitProc:	
	ret
endp OpenBmpFile
 
 
 



proc CloseBmpFile 
	mov ah,3Eh
	mov bx, [FileHandle]
	int 21h
	ret
endp CloseBmpFile




proc ReadBmpHeader	
	push cx
	push dx
	
	mov ah,3fh
	mov bx, [FileHandle]
	mov cx,54
	mov dx,offset Header
	int 21h
	
	pop dx
	pop cx
	ret
endp ReadBmpHeader

proc ShowAxDecimal
       push ax
	   push bx
	   push cx
	   push dx
	   
	   ; check if negative
	   test ax,08000h
	   jz PositiveAx
			
	   ;  put '-' on the screen
	   push ax
	   mov dl,'-'
	   mov ah,2
	   int 21h
	   pop ax

	   neg ax ; make it positive
PositiveAx:
       mov cx,0   ; will count how many time we did push 
       mov bx,10  ; the divider
   
put_mode_to_stack:
       xor dx,dx
       div bx
       add dl,30h
	   ; dl is the current LSB digit 
	   ; we cant push only dl so we push all dx
       push dx    
       inc cx
       cmp ax,9   ; check if it is the last time to div
       jg put_mode_to_stack

	   cmp ax,0
	   jz pop_next  ; jump if ax was totally 0
       add al,30h  
	   mov dl, al    
  	   mov ah, 2h
	   int 21h        ; show first digit MSB
	       
pop_next: 
       pop ax    ; remove all rest LIFO (reverse) (MSB to LSB)
	   mov dl, al
       mov ah, 2h
	   int 21h        ; show all rest digits
       loop pop_next
		

   
	   pop dx
	   pop cx
	   pop bx
	   pop ax
	   
	   ret
endp ShowAxDecimal

proc ReadBmpPalette  ; Read BMP file color palette, 256 colors * 4 bytes (400h)
						 ; 4 bytes for each color BGR + null)			
	push cx
	push dx
	
	mov ah,3fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	
	pop dx
	pop cx
	
	ret
endp ReadBmpPalette


; Will move out to screen memory the colors
; video ports are 3C8h for number of first color
; and 3C9h for all rest
proc CopyBmpPalette							
										
	push cx
	push dx
	
	mov si,offset Palette
	mov cx,256
	mov dx,3C8h
	mov al,0  ; black first							
	out dx,al ;3C8h
	inc dx	  ;3C9h
CopyNextColor:
	mov al,[si+2] 		; Red				
	shr al,2 			; divide by 4 Max (Dos max is 63 and we have here max 255 ) (loosing color resolution).				
	out dx,al 						
	mov al,[si+1] 		; Green.				
	shr al,2            
	out dx,al 							
	mov al,[si] 		; Blue.				
	shr al,2            
	out dx,al 							
	add si,4 			; Point to next color.  (4 bytes for each color BGR + null)				
								
	loop CopyNextColor
	
	pop dx
	pop cx
	
	ret
endp CopyBmpPalette


x equ [bp + 8]
y equ [bp + 6]
proc ShowBMP
; BMP graphics are saved upside-down.
; Read the graphic line by line (BmpHeight lines in VGA format),
; displaying the lines from bottom to top.
	push bp
	push cx
	mov bp, sp
	
	
	mov ax, 0A000h
	mov es, ax
	
 
	mov ax,[BmpWidth] ; row size must dived by 4 so if it less we must calculate the extra padding bytes
	mov [checker], 0
	and ax, 3
	jz @@row_ok
	mov [checker],4
	sub [checker],ax

@@row_ok:	
	mov cx,[BmpHeight]
    dec cx
	add cx,y ; add the Y on entire screen
	; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
	mov di,cx
	shl cx,6
	shl di,8
	add di,cx
	add di,x
	cld ; Clear direction flag, for movsb forward
	
	mov cx, [BmpHeight]
@@NextLine:
	push cx
 
	; small Read one line
	mov ah,3fh
	mov cx,[BmpWidth]  
	add cx,[checker]  ; extra  bytes to each row must be divided by 4
	mov dx,offset ScrLine
	int 21h
	; Copy one line into video memory es:di
	mov cx,[BmpWidth]  
	mov si,offset ScrLine
	rep movsb ; Copy line to the screen
	sub di,[BmpWidth]            ; return to left bmp
	sub di,SCREEN_WIDTH  ; jump one screen line up
	
	pop cx
	loop @@NextLine
	
	pop cx
	pop bp
	ret 
endp ShowBMP

proc mouse
	mov ax,0
	int 33h
	ret
endp mouse

proc showscore
	push dx 
	push ax
	
	mov ax,seg Score
    mov es,ax
    mov ah,13h
    mov bp,offset StrScore
    mov dh,1
    mov dl,13
    mov cx,lenStrScore
    mov al,1
    mov bh,0
    mov bl,255 
    int 10h
	
	mov ah, 2
	mov bh, 0
	mov dh, 1
	mov dl, 19
	int 10h
	mov ax, [Score]
	call ShowAxDecimal
	pop ax
	pop dx
	ret
endp showscore





proc checkcollisioncollors
	
	add [ghostcnt], 20
	
	cmp al, BLUE
	je col
	
	cmp al, paccollor
	je deathcol
	
	cmp al, redghostcol
	je col
	
	cmp al, orangeghostcol
	je col
	
	cmp al , blueghostcol
	je col
	
	cmp al, freightcollor
	je col
	mov di, 0
	mov si, 0
	ret
	
col:
	mov si, 1
	mov di, 0
	mov cx, 0
	ret
deathcol:
	mov cx, 0
	mov si, 0
	mov di, 1
	ret
ghostcol:
	mov cx, 1
	mov si, 0
	mov di, 0
	ret
	
	
endp checkcollisioncollors



proc blueghost
	push offset blueshadowarray	
	push [blue_X]
    push [blue_y]
	call RemoveghostFromScreen

	
	cmp [blueghostforcedir], 1
	je bluemoveleft
	cmp [blueghostforcedir], 2
	je bluemoveright
	cmp [blueghostforcedir], 3
	je tobluemoveup
	cmp [blueghostforcedir], 4
	je tobluemovedown


    mov ax, [blue_x]
    cmp ax, [pac_X]
    ja bluemoveleft
    jb bluemoveright
	jmp @@upordown



bluemoveleft:
	
    dec [blue_x]
    push [blue_x]
    push [blue_y]
	mov [ghostorpac], 1
    call leftcollision
	
	call checkcollisioncollors
	cmp di, 1
	jne @@pacleftnodeath
	call death
@@pacleftnodeath:
	cmp al, redghostcol
	je blueleftchangedir
	cmp al, orangeghostcol
	je blueleftchangedir
	cmp si, 1
	je @@leftcol
	

	
    lea dx, [blueghostleft]
    jmp @@upordown
	
@@leftcol:
	mov [blueghostforcedir], 0
	sub [ghostcnt], 12
	inc [blue_x]
	 lea dx, [blueghostleft]
	jmp @@upordown

blueleftchangedir:
	inc [blue_X]
	mov [blueghostforcedir], 2
	lea dx, [BLUEghostLEFT]
	jmp @@bluemoveret

tobluemovedown:
	jmp bluemovedown
	
tobluemoveup:
	jmp bluemoveup
bluemoveright:


    inc [blue_x]
    push [blue_x]
    push [blue_y]
	mov [ghostorpac], 1
    call rightcollision
	
	call checkcollisioncollors
	cmp di, 1
	jne @@pacrightnodeath
	call death
@@pacrightnodeath:
	cmp al, redghostcol
	je bluerightchangedir
	cmp al, orangeghostcol
	je bluerightchangedir
	cmp si, 1
	je @@rightcol

	
	lea dx, [blueghostright]
    jmp @@upordown
@@rightcol:	
	mov [blueghostforcedir], 0
	dec [blue_x]
	lea dx, [blueghostright]
	jmp @@upordown

bluerightchangedir:
	dec [Blue_x]
	lea dx, [blueghostright]
	mov [blueghostforcedir], 1
	jmp @@bluemoveret


	@@upordown:
    mov ax, [blue_y]
    cmp ax, [pac_y]
    ja bluemoveup
    jb bluemovedown
    jmp bluemovecollision


bluemoveup:
	

    dec [blue_y]
    push [blue_x]
    push [blue_y]
	mov [ghostorpac], 1
    call upcollision
	
	call checkcollisioncollors
	cmp di, 1
	jne @@pacupnodeath
	call death
@@pacupnodeath:
	cmp al, redghostcol
	je blueupchangedir
	cmp al, orangeghostcol
	je blueupchangedir
	cmp si, 1
	je @@upcol



	lea dx, [blueghostup]
    jmp bluemoveupdownret
@@upcol:
	mov [blueghostforcedir], 0
	inc [blue_y]
	lea dx, [blueghostup]
	jmp bluemovecollision
	
blueupchangedir:
	inc [blue_y]
	lea dx, [blueghostup]
	mov [blueghostforcedir], 4
	jmp @@bluemoveret

bluemovedown:
		
    inc [blue_y]
    push [blue_x]
    push [blue_y]
	mov [ghostorpac], 1
    call downcollision
	
	call checkcollisioncollors
	cmp di, 1
	jne @@pacdownnodeath
	call death
@@pacdownnodeath:
	cmp al, redghostcol
	je bluedownchangedir
	cmp al, orangeghostcol
	je  bluedownchangedir
	cmp si, 1
	je @@downcol


	
	lea dx, [blueghostdown]
    jmp bluemoveupdownret
	
@@downcol:
	mov [blueghostforcedir], 0
	lea dx, [blueghostdown]
	inc [ghostcnt]
	dec [blue_y]
	jmp bluemovecollision

bluedownchangedir:
	dec [blue_y]	
	lea dx, [blueghostdown]
	mov [blueghostforcedir], 3


bluemovecollision:

	push offset blueshadowarray	
	push dx
	push [blue_X]
    push [blue_y]
	call PutghostOnScreen
	ret

@@bluemoveret:


	push offset blueshadowarray	
	push dx
	push [blue_X]
    push [blue_y]
	call PutghostOnScreen

    jmp @@upordown
	
bluemoveupdownret:
	push offset blueshadowarray	
	push dx
	push [blue_X]
    push [blue_y]
	call PutghostOnScreen	

	ret
endp blueghost





proc orangeghost
	cmp [gotdir], 1
	je orangeghostai
	cmp [gotdir], 2
	je nextcorner
	cmp [gotdir], 3
	je n
	cmp [gotdir], 4
	je f
	cmp [ghostcnt], 63
	jbe orangeghostai
checkbottomleft:
	cmp [ghostcnt], 127
	jbe nextcorner
checkbottomright:
	cmp [ghostcnt], 191
	jbe n

	jmp f
	
orangeghostai:

	cmp [topright], 1
	je checkbottomleft
	mov [gotdir], 1
	call orangeghosttopright
	ret

nextcorner:
	cmp [bottomleft], 1
	je checkbottomright
	mov [gotdir], 2
	call orangeghostbottomleft
	ret
	
	
	
n:
	cmp [bottomrightcorener], 1
	je f
	mov [gotdir], 3
	call orangeghostbottomright
	ret
	
	

	
	
f:
	cmp [topleft], 1 
	je @@ret
	mov [gotdir], 4
	call orangeghosttopleft
	ret


@@ret:
	ret


endp orangeghost






proc orangeghostbottomleft
	push offset orangeshadow	
	push [orange_X]
    push [orange_y]
	call RemoveghostFromScreen

	cmp [orange_y], 188
	jne @@check
	cmp [orange_X], 8
	jne @@check
@@reset:	
	mov [bottomleft], 1
	mov [topleft], 0
	mov [bottomrightcorener], 0
	mov [topright], 0
	mov [gotdir], 0
	jmp @@orangemoveret

@@check:
	cmp [orangenomove], 0
	je @@upordown
	
@@orangemoveright:
	inc [orange_x]
	push [orange_x]
	push [orange_y]
	mov [ghostorpac], 1
	call rightcollision
	call checkcollisioncollors
	cmp di, 1
	jne @@pacrightnodeath
	call death
@@pacrightnodeath:
	cmp al, redghostcol
	je @@toreset
	cmp al, blueghostcol
	je @@toreset
	cmp si, 1
	je @@rightcol


	lea dx, [orangeghostright]
	mov [orangelastdir], 2
	jmp @@orangemoveret
	
	
@@rightcol:
	mov [orangenomove], 0
	dec [orange_x]
	




	


@@upordown:
	cmp [orange_y], 188
	jb @@orangemovedown

	cmp [orange_X], 6
	ja @@orangemoveleft
	



@@orangemoveleft:
	dec [orange_X]
	push [orange_x]
	push [orange_y]
	mov [ghostorpac], 1
	call leftcollision

	call checkcollisioncollors
	cmp di, 1
	jne @@pacleftnodeath
	call death
@@pacleftnodeath:
	cmp al, redghostcol
	je @@toreset
	cmp al, blueghostcol
	je @@toreset
	cmp si, 1
	je @@leftcol
	
	
	lea dx, [orangeghostleft]
	mov [orangelastdir], 1
	jmp @@orangemoveret
	
@@leftcol:
	inc [orange_X]
	mov [orangenomove],1
	jmp @@orangemoveret


@@toreset:
	jmp @@reset
	


@@orangemovedown:
	inc [orange_y]
	push [orange_x]
	push [orange_y]
	mov [ghostorpac], 1
	call downcollision
	call checkcollisioncollors
	cmp di, 1
	jne @@pacdownnodeath
	call death
@@pacdownnodeath:
	cmp al, redghostcol
	je @@toreset
	cmp al, blueghostcol
	je @@toreset
	cmp si, 1
	je @@downcol	

	lea dx, [orangeghostright]
	mov [orangelastdir], 4
	jmp @@orangemoveupret
	
@@downcol:
	dec [orange_y]
	jmp @@orangemoveleft


@@orangemoveupret:
	lea dx, [orangeghostdown]
	push offset orangeshadow
	push dx
	push [orange_X]
    push [orange_y]
	call PutghostOnScreen	
	ret
	
	
@@orangemoveret:
	lea dx, [orangeghostleft]
	push offset orangeshadow	
	push dx
	push [orange_X]
    push [orange_y]
	call PutghostOnScreen	

	ret	 

endp orangeghostbottomleft

proc orangeghosttopright
	push offset orangeshadow	
	push [orange_X]
    push [orange_y]
	call RemoveghostFromScreen

	cmp [orange_y], 19
	jne @@check
		
	cmp [orange_X], 304
	jne @@check	
@@reset:
	mov [topright], 1
	mov [bottomleft], 0
	mov [bottomrightcorener], 0
	mov [topright], 0
	mov [gotdir], 0
	jmp @@orangemoveret
	
@@check:
	cmp [orangenomove] , 1
	jne @@toupordown
	
	cmp [orangelastdir], 2
	je @@orangemovedown

	
	
@@orangemoveleft:
	dec [orange_X]
	push [orange_x]
	push [orange_y]
	mov [ghostorpac], 1
	call leftcollision
	
	call checkcollisioncollors
	cmp di, 1
	jne @@pacleftnodeath
	call death
@@pacleftnodeath:
	cmp al, redghostcol
	je @@toreset
	cmp al, blueghostcol
	je @@toreset
	cmp si, 1
	je @@leftcol
	
	
	lea dx, [orangeghostleft]
	jmp @@orangemoveret
	
@@leftcol:

	mov [orangelastdir], 1
	mov [orangenomove], 0
	inc [orange_X]
	jmp @@orangemoveup

@@toupordown:
	jmp @@upordown




@@orangemovedown:
	inc [orange_y]
	push [orange_x]
	push [orange_y]
	mov [ghostorpac], 1
	call downcollision
	call checkcollisioncollors
	cmp di, 1
	jne @@pacdownnodeath
	call death
@@pacdownnodeath:
	cmp al, redghostcol
	je @@toreset
	cmp al, blueghostcol
	je @@toreset
	cmp si, 1
	je @@downcol	
	
	

	
	lea dx, [orangeghostup]
	jmp @@orangemoveret
@@downcol:

	dec [orange_y]
	mov [orangelastdir], 4
	mov [orangenomove], 0
	jmp @@orangemoveright

	





@@upordown:
	
	
	cmp [orange_y], 19
	ja @@orangemoveup
	
	cmp [orange_X], 304
	jb @@orangemoveright

@@toreset:
	jmp @@reset

	
@@orangemoveright:
	inc [orange_x]
	push [orange_x]
	push [orange_y]
	mov [ghostorpac], 1
	call rightcollision
	call checkcollisioncollors
	cmp di, 1
	jne @@pacrightnodeath
	call death
@@pacrightnodeath:
	cmp al, redghostcol
	je @@toreset
	cmp al, blueghostcol
	je @@toreset
	cmp si, 1
	je @@rightcol
	
	lea dx, [orangeghostright]
	mov [orangelastdir], 2
	jmp @@orangemoveret

@@rightcol:

	mov [orangenomove], 1
	dec [orange_x]
	jmp @@orangemoveret

	

		
	
@@orangemoveup:
	dec [orange_y]
	push [orange_x]
	push [orange_y]
	mov [ghostorpac], 1
	call upcollision
	call checkcollisioncollors
	cmp di, 1
	jne @@pacupnodeath
	call death
@@pacupnodeath:
	cmp al, redghostcol
	je @@toreset
	cmp al, blueghostcol
	je @@toreset
	cmp si, 1
	je @@upcol
	
	
	lea dx, [orangeghostup]
	mov [orangelastdir], 3
	jmp @@orangemoveret
@@upcol:
	inc [orange_y]
	jmp @@orangemoveright


	
	
@@orangemoveupret:
	lea dx, [orangeghostup]
	push offset orangeshadow	
	push dx
	push [orange_X]
    push [orange_y]
	call PutghostOnScreen	
	ret
	
	
@@orangemoveret:
	lea dx, [orangeghostright]
	push offset orangeshadow	
	push dx
	push [orange_X]
    push [orange_y]
	call PutghostOnScreen	

	ret	 

endp orangeghosttopright



proc orangeghostbottomright
	push offset orangeshadow	
	push [orange_X]
    push [orange_y]
	call RemoveghostFromScreen
	


	cmp [orange_y], 188
	jne @@check
	
	
	cmp [orange_X],303
	jb @@check
@@reset:
	mov [bottomrightcorener], 1
	mov [bottomleft], 0
	mov [topleft], 0
	mov [topright], 0
	mov [gotdir], 0
	jmp @@orangemoveret

@@check:
	cmp [orangenomove], 0
	je @@upordown
@@orangemoveleft:
	dec [orange_X]
	push [orange_x]
	push [orange_y]
	mov [ghostorpac], 1
	call leftcollision
	call checkcollisioncollors
	cmp di, 1
	jne @@pacleftnodeath
	call death
@@pacleftnodeath:
	cmp al, redghostcol
	je @@toreset
	cmp al, blueghostcol
	je @@toreset
	cmp si, 1
	je @@leftcol

	
	lea dx, [orangeghostleft]
	jmp @@orangemoveret
@@leftcol:
	mov [orangelastdir], 1
	mov [orangenomove], 0
	inc [orange_X]
	jmp @@orangemovedown

@@toreset:
	jmp @@reset
	



@@upordown:
	cmp [orange_y], 188
	jl @@orangemovedown

@@orangestart:
	cmp [orange_x],303
	jl @@orangemoveright



@@orangemoveright:
	inc [orange_x]
	push [orange_x]
	push [orange_y]
	mov [ghostorpac], 1
	call rightcollision
	call checkcollisioncollors
	cmp di, 1
	jne @@pacrightnodeath
	call death
@@pacrightnodeath:
	cmp al, redghostcol
	je @@toreset
	cmp al, blueghostcol
	je @@toreset
	cmp si, 1
	je @@rightcol
	
	mov [orangelastdir], 2
	lea dx, [orangeghostright]
	jmp @@orangemoveret
	
@@rightcol:
	dec [orange_x]
	mov [orangenomove], 1
	jmp @@orangemoveret

	
@@orangemovedown:
	inc [orange_y]
	push [orange_x]
	push [orange_y]
	mov [ghostorpac], 1
	call downcollision
	call checkcollisioncollors
	cmp di, 1
	jne @@pacdownnodeath
	call death
@@pacdownnodeath:
	cmp al, redghostcol
	je @@toreset
	cmp al, blueghostcol
	je @@toreset
	cmp si, 1
	je @@downcol
	
	
	lea dx, [orangeghostright]
	mov [orangelastdir], 4
	jmp @@orangemoveupdownret
@@downcol:
	dec [orange_y]
	jmp @@orangemoveright


	
	
@@orangemoveupdownret:
	lea dx, [orangeghostdown]
	push offset orangeshadow	
	push dx
	push [orange_X]
    push [orange_y]
	call PutghostOnScreen	
	ret
	
	
@@orangemoveret:
	lea dx, [orangeghostright]
	push offset orangeshadow	
	push dx
	push [orange_X]
    push [orange_y]
	call PutghostOnScreen	

	ret	 
endp orangeghostbottomright



proc orangeghosttopleft
	push offset orangeshadow	
	push [orange_X]
    push [orange_y]
	call RemoveghostFromScreen

	cmp [orange_y], 19
	jne @@check
	cmp [orange_x], 7
	jne @@check
@@reset:	

	mov [topleft], 1
	mov [bottomleft], 0
	mov [bottomrightcorener], 0
	mov [topright], 0
	mov [gotdir], 0

	jmp @@orangemoveret
	
@@check:
	cmp [orangenomove], 0
	je @@toupordown
	cmp [orangelastdir], 1
	je @@orangemovedown
	
	
@@orangemoveright:
	inc [orange_x]
	push [orange_x]
	push [orange_y]
	mov [ghostorpac], 1
	call rightcollision
	call checkcollisioncollors
	cmp di, 1
	jne @@pacrightnodeath
	call death
@@pacrightnodeath:
	cmp al, redghostcol
	je @@toreset
	cmp al, blueghostcol
	je @@toreset
	cmp si, 1
	je @@rightcol
	
	

		lea dx, [orangeghostright]
	mov [orangelastdir], 2
	jmp @@orangemoveret
	
@@rightcol:
	mov [orangenomove], 0
	dec [orange_x]
	jmp @@orangemoveret



@@toupordown:
	jmp @@upordown

@@orangemovedown:
	inc [orange_y]
	push [orange_x]
	push [orange_y]
	mov [ghostorpac], 1
	call downcollision
	call checkcollisioncollors
	cmp di, 1
	jne @@pacdownnodeath
	call death
@@pacdownnodeath:
	cmp al, redghostcol
	je @@toreset
	cmp si, 1
	je @@downcol
	
	

	lea dx, [orangeghostup]
	jmp @@orangemoveret
	
	
@@toreset:
	jmp @@reset
	
	
@@downcol:
	dec [orange_y]
	mov [orangelastdir], 4
	mov [orangenomove], 0
	jmp @@orangemoveleft



@@upordown:
	cmp [orange_y], 19
	ja @@orangemoveup
	
	
	cmp [orange_X],15
	ja @@orangemoveleft
	
@@orangemoveleft:
	dec [orange_X]
	push [orange_x]
	push [orange_y]
	mov [ghostorpac], 1
	call leftcollision
	call checkcollisioncollors
	cmp di, 1
	jne @@pacleftnodeath
	call death
@@pacleftnodeath:
	cmp al, redghostcol
	je @@toreset
	cmp al, blueghostcol
	je @@toreset
	cmp si, 1
	je @@leftcol
	
	
	lea dx, [orangeghostleft]
	mov [orangelastdir], 1
	jmp @@orangemoveret
	
@@leftcol:
	inc [orange_X]
	mov [orangenomove], 1
	jmp @@orangemoveret


	
@@orangemoveup:
	dec [orange_y]
	push [orange_x]
	push [orange_y]
	mov [ghostorpac], 1
	call upcollision
	call checkcollisioncollors
	cmp di, 1
	jne @@pacupnodeath
	call death
@@pacupnodeath:
	cmp al, redghostcol
	je @@totoreset
	cmp al, blueghostcol
	je @@totoreset
	cmp si, 1
	je @@upcol
	
	
	lea dx, [orangeghostup]
	mov [orangelastdir], 3
	jmp @@orangemoveret
@@upcol:
	inc [orange_y]
	jmp @@orangemoveleft



	
@@orangemoveret:
	lea dx, [orangeghostright]
	push offset orangeshadow	
	push dx
	push [orange_X]
    push [orange_y]
	call PutghostOnScreen	

	ret	 
@@totoreset:
	jmp @@reset
endp orangeghosttopleft



proc checkcross
	
	cmp [red_y],42
	jne lefttopcross
	cmp [red_x], 248
	jne lefttopcross

	mov di, 1
	ret
	
lefttopcross:
	cmp [red_y],42
	jne botleftcross
	
	cmp [red_X],61
	jne botleftcross

	mov di,1 
	ret
botleftcross:
	cmp [red_y], 133
	jne botrightcross
	
	cmp [red_x], 249
	jne botrightcross

	mov di, 1
	ret
	
botrightcross:
	cmp [red_x], 61
	jne @@ret
	
	cmp [red_y], 133
	jne @@ret
	mov di, 1

	ret

@@ret:
	mov di, 0
	ret


endp checkcross




proc getrandomdir
	cmp [resetrandomdir], 2
	jne checkleft
	
	mov [cantmove], 1
	jmp @@ret
checkleft:
	cmp [ghostcnt], 63
	jbe @@left
checkup:
	cmp [ghostcnt], 127
	jbe @@up
@@checkright:
	cmp [ghostcnt], 191
	jbe @@right

	jmp checkdown


@@left:
	dec [red_x]
	push [red_x]
	push [red_y]
	mov [ghostorpac], 1
	call leftcollision
	inc [red_x]
	call checkcollisioncollors
	cmp si,1
	je checkup
	cmp [redghostlastcol], 1
	je checkup
	cmp [redghostlastdir], 1
	je checkup 
	mov [redghostlastdir], 1
	mov [resetrandomdir], 0
	ret
@@up:
	dec [red_y]
	push [red_x]
	push [red_y]
	mov [ghostorpac], 1
	call upcollision
	inc [red_y]
	call checkcollisioncollors
	cmp si,1
	je gotocheckright
	cmp [redghostlastcol], 3
	je gotocheckright
	cmp [redghostlastdir], 3
	je gotocheckright
	mov [redghostlastdir], 3
	mov [resetrandomdir], 0
	ret
gotocheckright:
	jmp @@checkright
@@right:
	inc [red_x]
	push [red_x]
	push [red_y]
	mov [ghostorpac], 1
	call rightcollision
	dec [red_x]
	call checkcollisioncollors
	cmp si,1
	je gotocheckdown
	cmp [redghostlastcol], 2
	je gotocheckdown
	cmp [redghostlastdir], 2
	je gotocheckdown
	mov [redghostlastdir], 2

	mov [resetrandomdir], 0
	ret
gotocheckdown:
	jmp checkdown
	
checkdown:
	cmp al, 255
	jbe @@down
	jmp getrandomdir
@@down:
	inc [red_y]
	push [red_x]
	push [red_y]
	mov [ghostorpac], 1
	call downcollision
	dec [red_y]
	cmp al, BLUE
	je gotoleft
	cmp [redghostlastcol], 4
	je gotoleft
	cmp [redghostlastdir], 4
	je gotoleft
	mov [redghostlastdir], 4
	mov [resetrandomdir], 0
	ret
gotoleft:
	mov [ghostcnt], 0
	inc [resetrandomdir]
	jmp getrandomdir
	
@@ret:	
	mov [redghostlastdir], 0
	mov [redghostlastcol], 0
	ret
endp getrandomdir



proc redghost
	push offset redshadow	
	push [red_X]
    push [red_y]
	call RemoveghostFromScreen
	
jmp @@after
toredmoveup:
	dec [red_y]
	push [red_x]
	push [red_y]
	mov [ghostorpac], 1
	call upcollision
	inc [red_y]
	cmp al, BLUE
	je redcheckcross
	jmp @@redmoveup
	
toredmovedown:
	inc [red_y]
	push [red_x]
	push [red_y]
	mov [ghostorpac], 1
	call downcollision
	dec [red_y]
	cmp al, orangeghostcol
	je redcheckcross
	cmp al, blueghostcol
	je redcheckcross
	cmp al, BLUE
	je redcheckcross
	jmp @@redmovedown

@@after:
	mov ax, [pac_x]
	cmp [red_x], ax
	jne redcheckcross
	mov ax, [pac_y]
	cmp [red_y], ax
	ja toredmoveup
	jb toredmovedown
	
redcheckcross:
	call checkcross
	cmp di, 1
	jne @@redstart
	call getrandomdir
@@redstart:
	cmp [redghostlastdir], 1
	je @@redmoveleft
	cmp [redghostlastdir], 2
	je @@redmoveright
	jmp @@upordown
	


@@redmoveleft:
	dec [red_x]
	push [red_x]
	push [red_y]
	mov [ghostorpac], 1
	call leftcollision
	call checkcollisioncollors
	cmp di, 1
	jne @@pacleftnodeath
	call death
@@pacleftnodeath:
	cmp al, orangeghostcol
	je leftchangedir
	cmp al, blueghostcol
	je leftchangedir
	cmp si, 1
	je @@leftcol
	
	mov [redghostlastdir], 1
	jmp @@redmoveret
	
@@leftcol:

inc [red_x]
	mov [redghostlastcol], 2
	jmp randomdir
	
leftchangedir:
	mov [redghostlastdir], 1
	jmp @@redmoveret
	

@@redmoveright:
	inc [red_x]
	push [red_x]
	push [red_y]
	mov [ghostorpac], 1
	call rightcollision
	call checkcollisioncollors
	cmp di, 1
	jne @@pacrightnodeath
	call death
@@pacrightnodeath:
	cmp al, orangeghostcol
	je rightchangedir
	cmp al, blueghostcol
	je rightchangedir
	cmp si, 1
	je @@rightcol
	
	
	mov [redghostlastdir], 2
	inc [ghostcnt]
	jmp @@redmoveret
	
@@rightcol:
	dec [red_x]
	mov [redghostlastcol], 1
	jmp randomdir
	
rightchangedir:
	mov [redghostlastdir],1
	jmp @@redmoveret

	
@@upordown:
	cmp [redghostlastdir], 3
	je @@redmoveup
	jmp @@redmovedown

@@redmoveup:
	dec [red_y]
	push [red_x]
	push [red_y]
	mov [ghostorpac], 1
	call upcollision
	call checkcollisioncollors
	cmp di, 1
	jne @@pacupnodeath
	call death
@@pacupnodeath:
	cmp al, orangeghostcol
	je upchangedir
	cmp al, blueghostcol
	je upchangedir
	cmp si, 1
	je @@upcol
	
	
	mov [redghostlastdir], 3
	jmp @@redmoveret
@@upcol:
	inc [red_y]
	mov [redghostlastcol], 4
	jmp randomdir
	
upchangedir:
	mov [redghostlastdir], 4
	jmp @@redmoveret



@@redmovedown:
	inc [red_y]
	push [red_x]
	push [red_y]
	mov [ghostorpac], 1
	call downcollision
	call checkcollisioncollors
	cmp di, 1
	jne @@pacdownnodeath
	call death
@@pacdownnodeath:
	cmp al, orangeghostcol
	je downchangedir
	cmp al, blueghostcol
	je downchangedir
	cmp si, 1
	je @@downcol

	
	mov [redghostlastdir], 4
	jmp @@redmoveret

@@downcol:

	dec [red_y]
	mov [redghostlastcol], 3
	jmp randomdir

downchangedir:
	mov [redghostlastdir], 3


@@redmoveret:
	lea dx, [redghostright]
	push offset redshadow	
	push dx
	push [red_X]
    push [red_y]
	call PutghostOnScreen	
	ret	 


randomdir:
	call getrandomdir
	cmp [cantmove], 1
	je @@ret
	jmp redghost
@@ret:
	mov [redghostlastdir], 0
	mov [redghostlastcol], 0
	mov [cantmove], 0
	mov [resetrandomdir], 0
	lea dx, [redghostright]
	push offset redshadow	
	push dx
	push [red_X]
    push [red_y]
	call PutghostOnScreen
	ret
endp redghost






proc  SetGraphic
	mov ax,13h		 
	int 10h               
	ret
endp 	SetGraphic
	

proc bluefreightend
	push offset blueshadowarray	
	push [blue_X]
    push [blue_y]
	call RemoveghostFromScreen


@@leftoright:
	cmp [blue_X], 160
	ja @@moveright
	jb @@moveleft



@@moveleft:
	dec [blue_x]
    push [blue_x]
    push [blue_y]
	mov [ghostorpac], 1
    call leftcollision
	cmp al, paccollor
	jne @@leftnocheckdeath
	call eatblue
	ret
@@leftnocheckdeath:
    cmp al, BLUE
    je @@leftcol
	cmp al, freightcollor
	je @@leftcol
	cmp al, orangeghostcol
	je @@leftcol
	cmp al, redghostcol
	je @@leftcol
	cmp al, blueghostcol

	
	
    jmp @@bluemoveret	
@@leftcol:
	inc [blue_x]
	jmp @@upordown


@@moveright:
	
	inc [blue_x]
    push [blue_x]
    push [blue_y]
	mov [ghostorpac], 1
    call rightcollision
	cmp al, paccollor
	jne @@righttnocheckdeath
	call eatblue
	ret
@@righttnocheckdeath:
    cmp al, BLUE
    je @@rightcol
	cmp al, freightcollor
	je @@rightcol
	cmp al, orangeghostcol
	je @@rightcol
	cmp al, redghostcol
	je @@rightcol
	cmp al, blueghostcol
	
    jmp @@bluemoveret
@@rightcol:	
	dec [blue_x]
	jmp @@upordown
 	
	
@@upordown:
	cmp [blue_y], 103
	ja @@movedown
	jb @@moveup	
	

@@moveup:
	dec [blue_y]
    push [blue_x]
    push [blue_y]
	mov [ghostorpac], 1
    call upcollision
	cmp al, paccollor
	jne @@upnocheckdeath
	call eatblue
	ret
@@upnocheckdeath:
    cmp al, BLUE
    je @@upcol
	cmp al, freightcollor
	je @@upcol
	cmp al, orangeghostcol
	je @@upcol
	cmp al, redghostcol
	je @@upcol
	cmp al, blueghostcol
	
	
    jmp @@bluemoveret
@@upcol:
	inc [blue_y]
	jmp @@bluemoveret
	
@@movedown:
    inc [blue_y]
    push [blue_x]
    push [blue_y]
	mov [ghostorpac], 1
    call downcollision
	cmp al, paccollor
	jne @@downtnocheckdeath
	call eatblue
	ret
@@downtnocheckdeath:
    cmp al, BLUE
    je @@downcol
	cmp al, freightcollor
	je @@downcol
	cmp al, orangeghostcol
	je @@downcol
	cmp al, redghostcol
	je @@downcol
	cmp al, blueghostcol


	
    jmp @@bluemoveret
	
@@downcol:
	dec [blue_y]
	jmp @@bluemoveret


@@bluemoveret:
	lea dx, [freightanim]
	push offset blueshadowarray
	push dx
	push [blue_x]
	push [blue_y]
	call PutghostOnScreen
	ret
endp bluefreightend



proc orangefreightend
	push offset orangeshadow	
	push [orange_X]
    push [orange_y]
	call RemoveghostFromScreen


@@leftoright:
	cmp [orange_X], 160
	ja @@moveright
	jb @@moveleft



@@moveleft:
	dec [orange_x]
    push [orange_x]
    push [orange_y]
	mov [ghostorpac], 1
    call leftcollision
	cmp al, paccollor
	jne @@leftnocheckdeath
	call eatorange
	ret
@@leftnocheckdeath:
    cmp al, blue
    je @@leftcol
	cmp al, freightcollor
	je @@leftcol
	cmp al, orangeghostcol
	je @@leftcol
	cmp al, redghostcol
	je @@leftcol
	cmp al, blueghostcol
	
    lea dx, [orangeghostleft]
    jmp @@orangemoveret	
@@leftcol:
	inc [orange_x]
	jmp @@upordown


@@moveright:
	
	inc [orange_x]
    push [orange_x]
    push [orange_y]
	mov [ghostorpac], 1
    call rightcollision
	cmp al, paccollor
	jne @@righttnocheckdeath
	call eatorange
	ret
@@righttnocheckdeath:
    cmp al, blue
    je @@rightcol
	cmp al, freightcollor
	je @@rightcol
	cmp al, orangeghostcol
	je @@rightcol
	cmp al, redghostcol
	je @@rightcol
	cmp al, blueghostcol
	


    jmp @@orangemoveret
@@rightcol:	
	dec [orange_x]
	jmp @@upordown
 	
	
@@upordown:
	cmp [orange_y], 103
	ja @@movedown
	jb @@moveup	
	

@@moveup:
	dec [orange_y]
    push [orange_x]
    push [orange_y]
	mov [ghostorpac], 1
    call upcollision
	cmp al, paccollor
	jne @@upnocheckdeath
	call eatorange
	ret
@@upnocheckdeath:
    cmp al, blue
    je @@upcol
	cmp al, freightcollor
	je @@upcol
	cmp al, orangeghostcol
	je @@upcol
	cmp al, redghostcol
	je @@upcol
	cmp al, blueghostcol

	

    jmp @@orangemoveret
@@upcol:
	inc [orange_y]
	jmp @@orangemoveret
	
@@movedown:
    inc [orange_y]
    push [orange_x]
    push [orange_y]
	mov [ghostorpac], 1
    call downcollision
	cmp al, paccollor
	jne @@downtnocheckdeath
	call eatorange
	ret
@@downtnocheckdeath:
    cmp al, blue
    je @@downcol
	cmp al, freightcollor
	je @@downcol
	cmp al, orangeghostcol
	je @@downcol
	cmp al, redghostcol
	je @@downcol
	cmp al, blueghostcol



    jmp @@orangemoveret
	
@@downcol:
	dec [orange_y]
	jmp @@orangemoveret


@@orangemoveret:
	lea dx, [freightanim]
	push offset orangeshadow
	push dx
	push [orange_x]
	push [orange_y]
	call PutghostOnScreen
	ret
endp orangefreightend


proc redfreightend
	push offset redshadow	
	push [red_X]
    push [red_y]
	call RemoveghostFromScreen


@@leftoright:
	cmp [red_X], 160
	ja @@moveright
	jb @@moveleft



@@moveleft:
	dec [red_x]
    push [red_x]
    push [red_y]
	mov [ghostorpac], 1
    call leftcollision
	cmp al, paccollor
	jne @@leftnocheckdeath
	call eatred
	ret
@@leftnocheckdeath:
    cmp al, blue
    je @@leftcol
	cmp al, freightcollor
	je @@leftcol
	cmp al, redghostcol
	je @@leftcol
	cmp al, redghostcol
	je @@leftcol
	cmp al, blueghostcol
	
    lea dx, [redghostleft]
    jmp @@redmoveret	
@@leftcol:
	inc [red_x]
	jmp @@upordown


@@moveright:
	
	inc [red_x]
    push [red_x]
    push [red_y]
	mov [ghostorpac], 1
    call rightcollision
	cmp al, paccollor
	jne @@righttnocheckdeath
	call eatred
	ret
@@righttnocheckdeath:
    cmp al, blue
    je @@rightcol
	cmp al, freightcollor
	je @@rightcol
	cmp al, redghostcol
	je @@rightcol
	cmp al, redghostcol
	je @@rightcol
	cmp al, blueghostcol
	


    jmp @@redmoveret
@@rightcol:	
	dec [red_x]
	jmp @@upordown
 	
	
@@upordown:
	cmp [red_y], 103
	ja @@movedown
	jb @@moveup	
	

@@moveup:
	dec [red_y]
    push [red_x]
    push [red_y]
	mov [ghostorpac], 1
    call upcollision
	cmp al, paccollor
	jne @@upnocheckdeath
	call eatred
	ret
@@upnocheckdeath:
    cmp al, blue
    je @@upcol
	cmp al, freightcollor
	je @@upcol
	cmp al, redghostcol
	je @@upcol
	cmp al, redghostcol
	je @@upcol
	cmp al, blueghostcol

	

    jmp @@redmoveret
@@upcol:
	inc [red_y]
	jmp @@redmoveret
	
@@movedown:
    inc [red_y]
    push [red_x]
    push [red_y]
	mov [ghostorpac], 1
    call downcollision
	cmp al, paccollor
	jne @@downtnocheckdeath
	call eatred
	ret
@@downtnocheckdeath:
    cmp al, blue
    je @@downcol
	cmp al, freightcollor
	je @@downcol
	cmp al, redghostcol
	je @@downcol
	cmp al, redghostcol
	je @@downcol
	cmp al, blueghostcol



    jmp @@redmoveret
	
@@downcol:
	dec [red_y]
	jmp @@redmoveret


@@redmoveret:
	lea dx, [freightanim]
	push offset redshadow
	push dx
	push [red_x]
	push [red_y]
	call PutghostOnScreen
	ret
endp redfreightend

	
proc ghostAlgo

	cmp [freightcnt], 400
	jne @@continue
	lea dx, [freightanim]
	nofreight

@@continue:
	cmp [bluefreight], 1
	jne bluenormal
	call bluefreightend
	jmp orangecheck
		
bluenormal:
	  call blueghost
	
orangecheck:
	cmp [orangefreight], 1
	jne orangenormal
	call orangefreightend
	jmp redcheck
orangenormal:
	call orangeghost
	
redcheck:
	cmp [redfreight], 1
	jne rednormal
	call redfreightend
	jmp checkifnorm
rednormal:
	   call redghost

checkifnorm:
	cmp [redfreight], 1
	jne normret
	
	cmp [orangefreight], 1
	jne normret
	
	cmp [orangefreight], 1
	jne normret
	inc [ghostcnt]
	inc [freightcnt]
	ret
	
	
normret:
	inc [freightcnt]
	inc [ghostcnt]
	ret
endp ghostAlgo

proc sleep
	push cx
	inc [ghostcnt]
	mov cx, 6000
sleeploop:

	loop sleeploop
	

	pop cx
	ret
endp sleep

proc SaveScore

    cmp [Score], ax
    jle @@KeepHighScore

    mov ax, [Score]
    call int_to_str
    call file_open_to_write
    jc @@ErrorFile

    call write_file_score
    call file_close

	mov ax,[score]
    mov [HighScore], ax
    jmp @@SameHighScore

@@KeepHighScore:
    ; Otherwise, keep the existing high score
    mov [HighScore], ax
	call ShowAxDecimal
	jmp @@DisplayHighScore

@@SameHighScore:	
    ; Display the high score
    mov ax, [HighScore]
	call ShowAxDecimal
@@DisplayHighScore:
	
    ; Position cursor
    mov ah, 02h
    xor bh, bh
    mov dh, 17
    mov dl, 19
    int 10h

	mov ax,[score]
	call ShowAxDecimal

    jmp @@Done

@@ErrorFile:
    ; Handle error in file operations
    mov dx, offset BmpFileErrorMsg
    mov ah, 09h
    int 21h

@@Done:
	ret

endp SaveScore


proc str_to_int 
	push bx
	push cx
	push dx
	push si
	push di
	
	mov si, 0  ; num of digits
	mov di,10
	xor ax, ax
	
@@NextDigit:
    mov bl, [IntStr + si]   ; read next ascii byte
	cmp bl,0dh  ; stop condition LF
	je @@ret
	cmp bl,13  ; or 13  CR
	je @@ret
	
	mul di
	
	mov bh ,0
	
	sub bl, '0'
	add ax , bx

	inc si
	cmp si, 5     ;one more stop condition
	jb @@NextDigit
	 
@@ret:
	; ax contains the number 	
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	
	ret
endp str_to_int 


;================================================
; Description - Write to IntStr the num inside ax and put 13 10 after 
;			 
; INPUT: AX
; OUTPUT: IntStr 
; Register Usage: AX  
;================================================
proc int_to_str
	   push ax
	   push bx
	   push cx
	   push dx
	   
	   xor si,si
	   mov cx,0   ; will count how many time we did push 
	   mov bx,10  ; the divider
   
put_mode_to_stackA:
	   xor dx,dx
	   div bx
	   add dl,30h
	   ; dl is the current LSB digit 
	   ; we cant push only dl so we push all dx
	   push dx    
	   inc cx
	   cmp ax,9   ; check if it is the last time to div
	   jg put_mode_to_stackA

	   cmp ax,0
	   jz pop_nextA  ; jump if ax was totally 0
	   add al,30h  
	   xor si, si
	   mov [IntStr], al
	   inc si
	   
		   
pop_nextA: 
	   pop ax    ; remove all rest LIFO (reverse) (MSB to LSB)
	   
	   mov [IntStr + si], al
	   inc si
	   loop pop_nextA
		
	   mov [IntStr + si], 13
	   mov [IntStr + si +1 ], 10
   
	   pop dx
	   pop cx
	   pop bx
	   pop ax
	   
	   ret
endp int_to_str

proc file_open_no_create
	mov ah,3dh
	mov al,2	
	mov dx, offset scorefile
	int 21h
	jc  openError   
	mov [FileHandle],ax
	mov	[FileFound],1
	jmp endopen
openError:
	mov [FatalError],1
	jmp endopen
endopen:
	ret
endp file_open_no_create

proc file_create
	cmp [FatalError],0
	jz endcreate
	mov ah,3ch
	mov al,0
	mov dx, offset scorefile	
	mov cx,0
	int 21h
	jc  createError   
	mov [FileHandle],ax
	mov	[FileCreated],1
	mov [FatalError],0
	jmp endcreate
createError:
	mov [FatalError],1
	jmp endcreate
endcreate:
	call file_close
	ret
endp file_create

proc file_open_to_write
	mov ah,3dh
	mov al,2
	mov dx, offset scorefile	
	int 21h
	jc  openwError   
	mov [FileHandle],ax
	mov	[FileFound],1
	jmp endopen
openwError:
	mov [FatalError],1
	jmp endwopen
endwopen:
	ret
endp file_open_to_write


proc write_file_score

    ;mov ah, 42h           ; Move file pointer
    ;mov al, 02h           ; Move to the end of the file
    ;mov bx, [FileHandle]            ; File handle
    ;xor cx, cx            ; Clear CX (not needed for seeking)
    ;xor dx, dx            ; Clear DX (not needed for seeking)
    ;int 21h

	mov ah,40h
	mov al,0	
	mov cx,5
	mov bx,[FileHandle]
	mov dx,offset IntStr
	int 21h
	ret
endp write_file_score
proc file_close

	mov ah,3eh
	mov bx,[FileHandle]
	int 21h
	ret 
endp file_close 

proc read_file
	mov bx,[FileHandle]
	mov dx,offset ReadBuff
	mov cx,BLOCK_SIZE  
	mov ah,3Fh
	mov al,0
	int 21h 
	ret
endp read_file

proc getscore

	call file_open_no_create
	cmp [FatalError],0
		jnz create1
		jmp nocreate1
create1:
		call file_create
		call file_open_no_create
		jmp Nothing1
nocreate1:
    call read_file
    call file_close	
	xor si,si
continueread:
	mov al,[ReadBuff + si]
	mov [IntStr+si],al
	cmp [ReadBuff + si+1],0Dh
	je EndRead
	cmp [ReadBuff + si+1],0Ah
	je EndRead
	inc si
	jmp continueread

EndRead:
	mov [IntStr+si+1],0Dh
	mov [IntStr+si+2],0Ah

	ret

Nothing1:
	mov [IntStr],0
	jmp EndRead	
endp getscore





proc movment 

call CheckAndReadKey
	cmp ax, LEFT_ARROW	
	je leftmove
	
	cmp ax, RIGHT_ARROW
	je rightmove
	
	cmp ax, DOWN_ARROW
	je downmove

	
	cmp ax, UP_ARROW
	je upmove


	cmp ax, ESCAPE
	je @@ret
	

lastdir:	
	cmp [lastdirection], 1
	je leftmove
	
	cmp [lastdirection], 2
	je rightmove

	cmp [lastdirection], 3
	je downmove

	cmp [lastdirection], 4
	je upmove
	
	ret
leftmove:
	cmp [lastdirection], 1
	je noneedtocheckleft
	mov [cnt], 0
	call attemptleft
noneedtocheckleft:
	call leftanimation
	; call main
	inc [ghostcnt]

	ret	

rightmove:
	cmp [lastdirection], 2
	je noneedtocheckright
	mov [cnt], 0
	call attemptright
noneedtocheckright:
	call rightanimation
	; call main
	ret

downmove:

	cmp [lastdirection], 3
	je noneedtocheckdown
	mov [cnt], 0
	call attemptdown
	
noneedtocheckdown:
	call downanimation
; call main
		inc [ghostcnt]

	ret	

upmove:
	cmp [lastdirection], 4
	je noneedtocheckup
	mov [cnt], 0
	call attemptup
noneedtocheckup:

	call upanimation
 ;call main
	ret

@@ret:
	ret
endp movment



arrayoffset equ [bp+10]
animoffset equ [bp+8]
objX equ [bp + 6]
objY equ [bp + 4]






proc PutghostOnScreen
	push bp
	mov bp, sp
	push cx
	push dx
	push es
	
	mov ax,0a000h
	mov es,ax
	mov [cnt],0
	mov ax,1
	push ax   ; from screen to shadow
	mov cx,objX
	mov dx,objY
	 
	 
	
	mov ax, 11
	push ax
	mov ax, 11
	push ax
	
	call getXYonScreen  ; return ax
	push ax ; from screen 
	
	mov ax, arrayoffset
	push ax
	
	
	
	 
	call FromToShadow  
	 

	mov dx, animoffset
	push objX
	push objY
	call OpenShowBMP
	
	pop es
	pop dx
	pop cx
	pop bp
	ret 8
endp PutghostOnScreen

shadowoffset equ [bp+8]
proc RemoveghostFromScreen
	push bp
	mov bp, sp
	push cx
	push dx
	push es
	mov [cnt],0
	mov ax,0a000h
	mov es,ax
	
	mov ax,0
	push ax   ; from screen to shadow 
	
	mov ax, 11
	push ax

	mov ax, 11
	push ax
	
	mov cx,objX
	mov dx,objY
	call getXYonScreen  ; return ax
	push ax
	mov ax,	shadowoffset
	push ax
 
	call FromToShadow 
	
	pop es
	pop dx
	pop cx
	pop bp
	ret 6
endp RemoveghostFromScreen

proc checkforcollors
	cmp al, blueghostcol
	je makezero
	cmp al, orangeghostcol
	je makezero
	cmp al, redghostcol
	je makezero
	cmp al, freightcollor
	je makezero

	cmp al, white
	je makezero
	cmp al, lightblue
	je makezero
	cmp al, paccollor
	je makezero
	
	ret
makezero:
	mov al, 0
	ret 
endp checkforcollors


 proc FromToShadow
	push bp
	mov bp, sp
	push ax
	push cx
	push dx
	push si
	push di
	 
	cld
	
	mov si, [bp +4] ;  shodowarrayofsett
	mov di, [bp +6] ; screen location
	mov cx, [bp +8] ; 11
	mov dx, [bp +10]   ; 11 

start1:	
	cmp [word bp +12],0 ;direction for clear use 0, for print use 1
	jz @@toScreen

@@r:
	push cx
	mov cx, dx
@@c:
	mov al, [es:di] ; mov al, current pixel
	call checkforcollors
@@continue:

	mov [si],al ;mov to shadowarray the pixel 
	inc si ; move to next pixel on array
	inc di ;mov to next pixel on screen
	loop @@c ; loop to get array of collors
 	
	add di, 320 ;line down
	sub di, dx ;line down
	
	pop cx ; pop for loop
	loop @@r ;loop next line
	
	jmp @@ret ;finished getting array
	 
@@toScreen:
	 
@@r2:
	push cx
	mov cx, dx
	
	rep movsb ;print one Line cx times pointer for screen si showing to di
 	
	add di, 320 ;goto next Line
	sub di, dx ; -------------
	
	pop cx ; pop for loop
	loop @@r2 ;
	
@@ret:	
	 
	pop di
	pop si
	pop dx
	pop cx
	pop ax
	pop bp
	ret 10
	

endp FromToShadow
 
proc getXYonScreen
	mov ax,dx
	shl dx,8
	shl ax, 6
	add ax,dx
	add ax,cx
	ret 
endp getXYonScreen



; proc main 
    ; mov ax, @data
    ; mov ds, ax

   ; Repeat the tones indefinitely, but play only every 30 iterations
; repeat_loop:
    ; inc [counter]
    ; cmp [counter], 30
    ; jne skip_play

   ; Reset the counter
    ; mov [counter], 0

   ; Play each tone in the array
    ; mov cx, 28          ; Number of tones in the array
    ; mov si, offset tones

; play_tones:
    ; mov ax, [si]
    ; call play_tone
    ; call delay
    ; call stop_tone
    ; call delay_short

    ; add si, 2           ; Move to the next tone
    ; loop play_tones

; skip_play:
; ret
; endp main

; proc play_tone
    ;Input: AX = frequency in Hz
    ; push bx
    ; push cx
    ; push dx

    ; mov bx, ax
    ; mov ax, [word ptr divisor]
    ; mov dx,[word ptr divisor + 2]
    ; div bx
    ; mov bx, ax

    ; mov al, 0B6h         ; Set command for channel 2, mode 3, binary
    ; out 43h, al
    ; mov al, bl           ; Send low byte of divisor
    ; out 42h, al
    ; mov al, bh           ; Send high byte of divisor
    ; out 42h, al

    ; in al, 61h           ; Read speaker control port
    ; or al, 3             ; Enable speaker
    ; out 61h, al

    ; pop dx
    ; pop cx
    ; pop bx
    ; ret
; endp play_tone

; proc stop_tone
    ;Stop the tone
    ; in al, 61h           ; Read speaker control port
    ; and al, 0FCh          ; Disable speaker
    ; out 61h, al
    ; ret
; endp stop_tone

; proc delay
   ; Input: AX = duration in milliseconds
    ; push bx
    ; push cx
    ; push dx

    ; mov cx, ax          ; CX = duration
    ; mov dx, 1000        ; DX = 1000 for milliseconds to microseconds conversion

; delay_loop:
    ; mov bx, 4           ; Inner delay loop multiplier
; inner_loop:
    ; nop                 ; No-operation (small delay)
    ; nop
    ; nop
    ; nop
    ; nop
    ; nop
    ; dec bx
    ; jnz inner_loop
    ; dec cx
    ; jnz delay_loop

    ; pop dx
    ; pop cx
    ; pop bx
    ; ret
; endp delay

; proc delay_short
    ;Input: AX = short duration in milliseconds
    ; push bx
    ; push cx
    ; push dx

    ; mov cx, [short_duration] ; CX = short duration
    ; mov dx, 1000           ; DX = 1000 for milliseconds to microseconds conversion

; delay_short_loop:
    ; mov bx, 4              ; Inner delay loop multiplier
; inner_short_loop:
    ; nop                    ; No-operation (small delay)
    ; nop
    ; nop
    ; nop
    ; nop
    ; nop
    ; dec bx
    ; jnz inner_short_loop
    ; dec cx
    ; jnz delay_short_loop

    ; pop dx
    ; pop cx
    ; pop bx
    ; ret
; endp delay_short


END start