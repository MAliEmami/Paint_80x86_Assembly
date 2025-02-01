INCLUDE	"./ERASE.asm"
INCLUDE	"./COLOR_BAR.asm"
INCLUDE	"./PAINT_PIXEL.asm"
INCLUDE	"./SET_BACKGROUND_WHITE.asm"
INCLUDE	"./SET_COLOR.asm"
INCLUDE	"./SET_CURSOR.asm"
INCLUDE	"./SET_VIDEO_MODE.asm"
;____________________________________________________________________________
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
		



