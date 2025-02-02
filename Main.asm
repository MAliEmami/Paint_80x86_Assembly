; INCLUDE	"./ERASE.asm"
; INCLUDE	"./COLOR_BAR.asm"
; INCLUDE	"./PAINT_PIXEL.asm"
; INCLUDE	"./SET_BACKGROUND_WHITE.asm"
; INCLUDE	"./SET_COLOR.asm"
; INCLUDE	"./SET_CURSOR.asm"
; INCLUDE	"./SET_VIDEO_MODE.asm"
;____________________________________________________________________________
COLOR_BAR  MACRO   COLOR, START_COL
			LOCAL   COL_LOOP, ROW_LOOP
			MOV     CX, START_COL + COLOR_MARGIN
			COL_LOOP:
				MOV     DX, COLOR_MARGIN
				ROW_LOOP:
					PAINT_PIXEL  COLOR
					INC     DX
					CMP     DX, COLOR_SIZE + COLOR_MARGIN
					JB      ROW_LOOP

					INC     CX
					CMP     CX, COLOR_SIZE + START_COL + COLOR_MARGIN
					JB      COL_LOOP
ENDM
;____________________________________________________________________________
ERASE  	MACRO
        PAINT_PIXEL  BLACK
		
		
		DEC         DX
        PAINT_PIXEL  BLACK
        INC         DX
		INC			DX
        PAINT_PIXEL  BLACK
		DEC			CX
		
		
        INC         CX
        PAINT_PIXEL  BLACK
        DEC         CX
		DEC         CX
        PAINT_PIXEL  BLACK
        INC         CX
		
		
		DEC			CX
		DEC         DX
        PAINT_PIXEL  BLACK
		INC			CX
		INC			DX
		
		INC			CX
        INC         DX         
        PAINT_PIXEL  BLACK
		DEC			CX
		DEC         DX
		
		
		INC			DX
        DEC         CX
        PAINT_PIXEL  BLACK
		DEC			DX
		INC			CX
		
		
		DEC			DX
        INC         CX
        PAINT_PIXEL  BLACK
		INC			DX
		DEC			CX
ENDM
;____________________________________________________________________________
PAINT_PIXEL MACRO COLOR	
			MOV AH,0CH
			MOV AL,COLOR
			INT 10H
ENDM
;____________________________________________________________________________
SET_BACKGROUND_WHITE MACRO
                     MOV AH,0B
                     MOV BH,0
                     MOV BL,WHITE
                     INT 10H
                     INT 3H
ENDM
;____________________________________________________________________________
SET_COLOR    MACRO
			LOCAL   SET_WHITE, SET_BLUE, SET_GREEN, SET_RED, END_CHOOSE
			CMP 	DX, COLOR_MARGIN + COLOR_SIZE
			JA 		END_CHOOSE
			CMP		DX, COLOR_MARGIN
			JB		END_CHOOSE
			CMP		CX, COLOR_MARGIN
			JB		END_CHOOSE
				CMP     CX, COLOR_MARGIN + WHITE_COL + COLOR_SIZE
				JB      SET_WHITE
				CMP     CX, RED_COL + COLOR_MARGIN + COLOR_SIZE
				JB      SET_RED
				CMP     CX, GREEN_COL + COLOR_MARGIN + COLOR_SIZE
				JB      SET_GREEN
				CMP     CX, BLUE_COL + COLOR_MARGIN + COLOR_SIZE
				JB      SET_BLUE
				JMP     END_CHOOSE
				
				SET_WHITE:
					MOV     PENCIL, WHITE
					JMP     END_CHOOSE
				SET_BLUE:
					MOV     PENCIL, BLUE
					JMP     END_CHOOSE
				SET_GREEN:
					MOV     PENCIL, GREEN
					JMP     END_CHOOSE
				SET_RED:
					MOV     PENCIL, RED
			END_CHOOSE:
ENDM
;____________________________________________________________________________
SET_CURSOR	MACRO	ROW, COL
			MOV		DH, ROW
			MOV		DL, COL
			MOV		BH, 0
			MOV		AH, 2
			INT		10H
ENDM
;____________________________________________________________________________
WAIT_FOR_KEY_PRESS	MACRO
					MOV AH,07
					INT 21H
ENDM


;____________________________________________________________________________
SET_VIDEO_MODE	MACRO	MODE
				MOV 	AH,00H ;Set new video mode
				MOV		AL,MODE
				INT		10H
ENDM
GET_OLD_VIDEO_MODE  MACRO
					MOV AH,0FH ;Get the current video mode
					INT 10H
					MOV [OLDVIDEO],AL ;Save it
ENDM
CLEAR_SCREEN	MACRO
				MOV AX,0600H ;Clear screen
				MOV BH,07
				MOV CX,0
				MOV DX,184FH
				INT 10H
ENDM
;____________________________________________________________________________
INITIAL_MOUSE	MACRO
				MOV AX,0000H ;Initialize mouse
				INT 33H
ENDM
SHOW_MOUSE_CURSOR	MACRO
					MOV AX,01H	;Show mouse cursor
					INT 33H 
ENDM

MOUSE_STATUS	MACRO
				MOV AX,03H ;check for mouse button event
				INT 33H
ENDM
; CHECK_LEFT_CLICK_PRESS	MACRO
						; LOCAL BACK
						; BACK: MOV AX,03H ;check for mouse button press
						; INT 33H
						; MOV [X1],CX
						; MOV [Y1],DX
						; CMP BX,0001H
						; JNE BACK
; ENDM
CHECK_LEFT_CLICK_RELEASE	MACRO
							LOCAL BACK
							BACK: MOV AX,03H ;check for mouse button release
							INT 33H
							MOV [X2],CX
							MOV [Y2],DX
							CMP BX,0000H
							JNE BACK			
ENDM
;____________________________________________________________________________
PLOT_LOW	MACRO X_1,Y_1,X_2,Y_2
			LOCAL NEXT,AGAIN,G,EXIT,L1
			MOV BX,0
			MOV SI,X_2
			SUB SI,X_1
			MOV DI,Y_2
			SUB DI,Y_1
			MOV [Yi],1
			CMP DI,0
			JGE	NEXT
			NOT [Yi]
			INC [Yi]
			NOT DI
			INC DI
			;NEG DI
			NEXT:
			SHL DI,1
			MOV [SLOPE_ERROR],DI
			SUB [SLOPE_ERROR],SI
			MOV DX,Y_1
			MOV CX,X_1
			AGAIN:
			;PAINT_PIXEL	PENCIL
			MOV AH,0CH
			MOV AL,PENCIL
			INT 10H
			CMP [SLOPE_ERROR],0
			JG G
				ADD [SLOPE_ERROR],DI
				JMP L1
			G:
			ADD DX,[Yi]
			MOV AX,DI
			SHL SI,1
			SUB AX,SI
			SHR SI,1
			ADD	[SLOPE_ERROR],AX
			L1:
			CMP CX,X_2
			JE EXIT
			INC CX
			JMP AGAIN
			EXIT:
ENDM
PLOT_HIGH 	MACRO X_1,Y_1,X_2,Y_2
			LOCAL NEXT,AGAIN,G,EXIT,L1
			MOV BX,0
			MOV SI,X_2
			SUB SI,X_1
			MOV DI,Y_2
			SUB DI,Y_1
			MOV [Xi],1
			CMP SI,0
			JGE	NEXT
			NOT [Xi]
			INC [Xi]
			NOT SI
			INC SI
			
			;NEG [Xi]
			;NEG SI
			NEXT:
			SHL SI,1
			MOV [SLOPE_ERROR],SI
			SUB [SLOPE_ERROR],DI
			MOV DX,Y_1
			MOV CX,X_1
			AGAIN:
			;PAINT_PIXEL PENCIL
			MOV AH,0CH
			MOV AL,PENCIL
			INT 10H
			CMP [SLOPE_ERROR],0
			JG G
				ADD [SLOPE_ERROR],SI
				JMP L1
			G:
			ADD CX,[Xi]
			MOV AX,SI
			SHL DI,1
			SUB AX,DI
			SHR DI,1
			ADD	[SLOPE_ERROR],AX
			L1:
			CMP DX,Y_2
			JE EXIT
			INC DX
			JMP AGAIN
			EXIT:
ENDM
DRAW_LINE 	MACRO
			LOCAL COMPARE,NEXT,HIGH_PLOT,NO_SWAPP_LOW,NO_SWAPP_HIGH,EXIT
			MOV DI,[Y2]
			SUB DI,[Y1]
			JNC NEXT
			NOT DI
			INC DI
			NEXT:
			MOV SI,[X2]
			SUB SI,[X1]
			JNC COMPARE
			NOT SI
			INC SI
			COMPARE:
			CMP DI,SI
			JGE HIGH_PLOT
			MOV BX,[X1]
			CMP BX,[X2]
			JLE NO_SWAPP_LOW
			PLOT_LOW [X2],[Y2],[X1],[Y1]
			JMP EXIT
			NO_SWAPP_LOW:
			PLOT_LOW [X1],[Y1],[X2],[Y2]
			JMP EXIT
			HIGH_PLOT:
			MOV BX,[Y1]
			CMP BX,[Y2]
			JLE NO_SWAPP_HIGH
			PLOT_HIGH [X2],[Y2],[X1],[Y1]
			JMP EXIT
			NO_SWAPP_HIGH:
			PLOT_HIGH [X1],[Y1],[X2],[Y2]
			EXIT:
ENDM


;____________________________________________________________________________

.MODEL SMALL
;___________________________STACK SEGMEMT____________________________________
.STACK 64
;___________________________DATA SEGMEMT____________________________________
.DATA
		X1 					DW ?
		X2 					DW ?
		Y1 					DW ?
		Y2 					DW ?
		Xi 					DW ?
		Yi 					DW ?
		DELTA_X 			DW ?
		DELTA_Y 			DW ?
		SLOPE_ERROR 		DW ?
		OLDVIDEO 			DB ?
		NEWVIDEO 			DB 12H
		
		
		COLOR_SIZE  		EQU	20
		COLOR_MARGIN		EQU 20
		BAR_LINE_MARGIN		EQU	5
		WHITE				EQU	00001111B
		WHITE_COL			EQU	20

		RED					EQU	00000100B
		RED_COL				EQU	40

		GREEN				EQU	00000010B
		GREEN_COL			EQU	60

		BLUE				EQU	00001001B
		BLUE_COL			EQU	80

		BLACK				EQU 00000000B

		PENCIL			    DB  WHITE   
;___________________________CODE SEGMEMT____________________________________
.CODE
MAIN 	PROC
		MOV AX,@DATA
		MOV DS,AX
;_____________________________PLAY GROUND____________________________________
		GET_OLD_VIDEO_MODE
		;CLEAR_SCREEN
		SET_VIDEO_MODE	NEWVIDEO
		; SET_BACKGROUND_WHITE
;_____________________________TOOLS BAR___________________________________
		COLOR_BAR	WHITE, WHITE_COL
		COLOR_BAR	RED, RED_COL
		COLOR_BAR	GREEN, GREEN_COL
		COLOR_BAR	BLUE, BLUE_COL
;_____________________________DRAWING______________________________________

		
		INITIAL_MOUSE
		SHOW_MOUSE_CURSOR
		
		PAINT:
			MOUSE_STATUS
			CMP BX,0002H
			JE	ERASE_OP
			CMP BX,0001H
			JE	DRAW_OP
			JMP	PAINT
			
			ERASE_OP:
				;CHECK POSITION
				CMP	DX,COLOR_MARGIN + COLOR_SIZE + BAR_LINE_MARGIN + 2
				JB	PAINT
				ERASE
				MOUSE_STATUS
				CMP BX,0002H
				JNE	PAINT
				JMP	ERASE_OP
			
			
			
			
			DRAW_OP:
				CMP	DX,COLOR_MARGIN + COLOR_SIZE + BAR_LINE_MARGIN + 2
				JB	COLOR_CHOOSE
				JMP	LINE
				COLOR_CHOOSE: 
				MOV AX,03H
				INT	33H
				CMP BX,0001H
				JNE COLOR_CHOOSE
				SET_COLOR
				JMP PAINT
				
				LINE:
					MOV [X1],CX
					MOV [Y1],DX
					CHECK_LEFT_CLICK_RELEASE
					CMP	DX,COLOR_MARGIN + COLOR_SIZE + BAR_LINE_MARGIN + 2
					JB	PAINT		
					DRAW_LINE
					;WAIT_FOR_KEY_PRESS
					;SET_VIDEO_MODE	OLDVIDEO
					JMP PAINT
			
		MOV AH,0CH
		INT 21H

MAIN 	ENDP
		END MAIN
		



