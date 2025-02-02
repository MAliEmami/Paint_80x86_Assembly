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
        DEC         CX
        PAINT_PIXEL  BLACK
        DEC         DX
        PAINT_PIXEL  BLACK
        INC         CX
        PAINT_PIXEL  BLACK
        INC         CX
        PAINT_PIXEL  BLACK
        INC         DX 
        PAINT_PIXEL  BLACK
        INC         DX         
        PAINT_PIXEL  BLACK
        DEC         CX
        PAINT_PIXEL  BLACK
        DEC         CX
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
			LOCAL   SET_BLACK, SET_BLUE, SET_CYAN, SET_GREEN,SET_LIGHT_GREEN, SET_RED, SET_MAGENTA, SET_YELLOW, END_CHOOSE

			CMP 	DX, COLOR_MRGIN + COLOR_SIZE
			JA 		END_CHOOSE
			CMP		DX, COLOR_MRGIN
			JB		END_CHOOSE
			CMP		CX, COLOR_MRGIN
			JB		END_CHOOSE
				CMP     CX, BLACK_COL + COLOR_MRGIN + COLOR_SIZE
				JB      SET_BLACK
				CMP     CX, BLUE_COL + COLOR_MRGIN + COLOR_SIZE
				JB      SET_BLUE
				CMP     CX, CYAN_COL + COLOR_MRGIN + COLOR_SIZE
				JB      SET_CYAN
				CMP     CX, GREEN_COL + COLOR_MRGIN + COLOR_SIZE
				JB      SET_GREEN
				CMP     CX, LIGHT_GREEN_COL + COLOR_MRGIN + COLOR_SIZE
				JB      SET_LIGHT_GREEN
				CMP     CX, RED_COL + COLOR_MRGIN + COLOR_SIZE
				JB      SET_RED
				CMP     CX, MAGENTA_COL + COLOR_MRGIN + COLOR_SIZE
				JB      SET_MAGENTA
				CMP     CX, YELLOW_COL + COLOR_MRGIN + COLOR_SIZE
				JB      SET_YELLOW
				JMP       END_CHOOSE
				
				SET_BLACK:
					MOV     PENCIL, BLACK
					JMP     END_CHOOSE
				SET_BLUE:
					MOV     PENCIL, BLUE
					JMP     END_CHOOSE
				SET_CYAN:
					MOV     PENCIL, CYAN
					JMP     END_CHOOSE
				SET_GREEN:
					MOV     PENCIL, GREEN
					JMP     END_CHOOSE
				SET_LIGHT_GREEN:
					MOV     PENCIL, LIGHT_GREEN
					JMP     END_CHOOSE
				SET_RED:
					MOV     PENCIL, RED
					JMP     END_CHOOSE
				SET_MAGENTA:
					MOV     PENCIL, MAGENTA
					JMP     END_CHOOSE
				SET_YELLOW:
					MOV     PENCIL, YELLOW
					JMP     END_CHOOSE
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
.MODEL LARGE
;___________________________STACK SEGMEMT____________________________________
.STACK 64
;___________________________DATA SEGMEMT____________________________________
.DATA

		COLOR_SIZE  		EQU	20
		COLOR_MRGIN			EQU 20

		WHITE				EQU 00001111B

		BLACK				EQU 00000000B
		BLACK_COL			EQU 0

		BLUE				EQU	00001001B
		BLUE_COL			EQU	25

		CYAN				EQU 00000011B
		CYAN_COL			EQU 50

		GREEN				EQU	00000010B
		GREEN_COL			EQU	75

		LIGHT_GREEN			EQU 00001010B
		LIGHT_GREEN_COL		EQU 100

		RED					EQU	00000100B
		RED_COL				EQU	125

		MAGENTA				EQU 00000101B
		MAGENTA_COL			EQU 150

		YELLOW				EQU 00001110B
		YELLOW_COL			EQU 175

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
		COLOR_BAR	BLACK, BLACK_COL
		COLOR_BAR	BLUE, BLUE_COL
		COLOR_BAR	CYAN, CYAN_COL
		COLOR_BAR	GREEN, GREEN_COL
		COLOR_BAR   LIGHT_GREEN, LIGHT_GREEN_COL
		COLOR_BAR	RED, RED_COL
		COLOR_BAR	MAGENTA, MAGENTA_COL
		COLOR_BAR	YELLOW, YELLOW_COL
;_____________________________DRAWING___________________________________

		MOV AX,0000H
		INT 33H
		MOV AX,01H
		INT 33H
		BACK: MOV AX,03H
			  INT 33H
			  CMP BX, 01H
			  JNE  BACK
		      SET_COLOR
		      PAINT_PIXEL PENCIL
			  jmp BACK
	;   ERASER: ERASE
	; 	      jmp GO
		MOV AH,07
		INT 21H

MAIN 	ENDP
		END MAIN
		



