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
			MOV     CX, START_COL + COLOR_MRGIN
			COL_LOOP:
				MOV     DX, COLOR_MRGIN
				ROW_LOOP:
					PAINT_PIXEL  COLOR
					INC     DX
					CMP     DX, COLOR_SIZE + COLOR_MRGIN
					JB      ROW_LOOP

					INC     CX
					CMP     CX, COLOR_SIZE + START_COL + COLOR_MRGIN
					JB      COL_LOOP
ENDM
;____________________________________________________________________________
ERASE  	MACRO
        PAINT_PIXEL  BLACK
        INC         CX
        PAINT_PIXEL  BLACK
        INC         DX
        PAINT_PIXEL  BLACK
        DEC         DX 
        DEC         DX         
        PAINT_PIXEL  BLACK
        DEC         CX
        PAINT_PIXEL  BLACK
        DEC         CX
        PAINT_PIXEL  BLACK
        INC         DX         
        PAINT_PIXEL  BLACK
        INC         DX         
        PAINT_PIXEL  BLACK
        INC         CX         
        PAINT_PIXEL  BLACK
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
			CMP 	DX, COLOR_MRGIN + COLOR_SIZE
			JA 		END_CHOOSE
			CMP		DX, COLOR_MRGIN
			JB		END_CHOOSE
			CMP		CX, COLOR_MRGIN
			JB		END_CHOOSE
				CMP     CX, COLOR_MRGIN + WHITE_COL + COLOR_SIZE
				JB      SET_WHITE
				CMP     CX, RED_COL + COLOR_MRGIN + COLOR_SIZE
				JB      SET_RED
				CMP     CX, GREEN_COL + COLOR_MRGIN + COLOR_SIZE
				JB      SET_GREEN
				CMP     CX, BLUE_COL + COLOR_MRGIN + COLOR_SIZE
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
SET_VIDEO_MODE	MACRO
				MOV		AX, 0012H
				INT		10H
ENDM
;____________________________________________________________________________
.MODEL SMALL
;___________________________STACK SEGMEMT____________________________________
.STACK 64
;___________________________DATA SEGMEMT____________________________________
.DATA

		COLOR_SIZE  		EQU	20
		COLOR_MRGIN			EQU 20

		WHITE				EQU	00001111B
		WHITE_COL			EQU	20

		RED					EQU	00001100B
		RED_COL				EQU	40

		GREEN				EQU	00001010B
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
		SET_VIDEO_MODE
		; SET_BACKGROUND_WHITE
;_____________________________TOOLS BAR___________________________________
		COLOR_BAR	WHITE, WHITE_COL
		COLOR_BAR	RED, RED_COL
		COLOR_BAR	GREEN, GREEN_COL
		COLOR_BAR	BLUE, BLUE_COL
;_____________________________DRAWING___________________________________

		MOV AX,0000H
		INT 33H
		MOV AX,01H
		INT 33H
		BACK: MOV AX,03H
			  INT 33H
			  CMP BX, 02H
			  JE  ERASER
		  GO: SET_COLOR
		      PAINT_PIXEL PENCIL
			  jmp BACK
	  ERASER: ERASE
		      jmp GO
		MOV AH,07
		INT 21H

MAIN 	ENDP
		END MAIN
		



