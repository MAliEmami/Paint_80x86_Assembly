
INCLUDE	MACROS.MAC
;____________________________________________________________________________

.MODEL SMALL
;___________________________STACK SEGMEMT____________________________________
.STACK 64
;___________________________DATA SEGMEMT____________________________________
.DATA

	X1              DW  ?
	X2              DW  ?
	Y1              DW  ?
	Y2              DW  ?
	Xi              DW  ?
	Yi              DW  ?

	DELTA_X         DW  ?
	DELTA_Y         DW  ?

	SLOPE_ERROR     DW  ?

	OLDVIDEO        DB  ?
	NEWVIDEO        DB  12H

	MONITOR_LENGH  	EQU 639
	MONITOR_WIDTH   EQU 479

	COLOR_SIZE      EQU 20
	COLOR_MARGIN    EQU 20
	BAR_LINE_MARGIN EQU 7


	BLACKGROUND_ATT	EQU 0700H

	WHITE           EQU 00001111B
	
	BLACK           EQU 00000000B
	BLACK_COL       EQU 0

	BLUE            EQU 00000001B
	BLUE_COL        EQU 25

	CYAN            EQU 00000011B
	CYAN_COL        EQU 50

	GREEN           EQU 00000010B
	GREEN_COL       EQU 75

	LIGHT_GREEN     EQU 00001010B
	LIGHT_GREEN_COL EQU 100

	RED             EQU 00000100B
	RED_COL         EQU 125

	MAGENTA         EQU 00000101B
	MAGENTA_COL     EQU 150

	YELLOW          EQU 00000110B
	YELLOW_COL      EQU 175

	PENCIL          DB  BLACK
	;___________________________CODE SEGMEMT____________________________________
.CODE
MAIN PROC
	             MOV                      AX,@DATA
			     MOV                      DS,AX
	;_____________________________PLAY GROUND____________________________________
				
				 GET_OLD_VIDEO_MODE
	             SET_VIDEO_MODE           NEWVIDEO
				 ;CLEAR_SCREEN
	             SET_BACKGROUND_WHITE
	;_____________________________TOOLS BAR___________________________________
	             PRINT                	0,1
	             FILL					BLACK, BLACK_COL + COLOR_MARGIN , COLOR_MARGIN,COLOR_SIZE + BLACK_COL + COLOR_MARGIN,COLOR_SIZE + COLOR_MARGIN
	             
				 FILL                	BLUE, BLUE_COL + COLOR_MARGIN , COLOR_MARGIN,COLOR_SIZE + BLUE_COL + COLOR_MARGIN,COLOR_SIZE + COLOR_MARGIN
	             
				 FILL                	CYAN, CYAN_COL + COLOR_MARGIN , COLOR_MARGIN , COLOR_SIZE + CYAN_COL + COLOR_MARGIN,COLOR_SIZE + COLOR_MARGIN
	             
				 FILL                	GREEN, GREEN_COL+ COLOR_MARGIN , COLOR_MARGIN,COLOR_SIZE + GREEN_COL + COLOR_MARGIN,COLOR_SIZE + COLOR_MARGIN
	             
				 FILL                	LIGHT_GREEN, LIGHT_GREEN_COL+ COLOR_MARGIN , COLOR_MARGIN,COLOR_SIZE + LIGHT_GREEN_COL + COLOR_MARGIN,COLOR_SIZE + COLOR_MARGIN
	             
				 FILL                	RED, RED_COL+ COLOR_MARGIN , COLOR_MARGIN,COLOR_SIZE + RED_COL + COLOR_MARGIN,COLOR_SIZE + COLOR_MARGIN
	             
				 FILL                	MAGENTA, MAGENTA_COL+ COLOR_MARGIN , COLOR_MARGIN,COLOR_SIZE + MAGENTA_COL + COLOR_MARGIN,COLOR_SIZE + COLOR_MARGIN
	             
				 FILL                	YELLOW, YELLOW_COL+ COLOR_MARGIN , COLOR_MARGIN,COLOR_SIZE + YELLOW_COL + COLOR_MARGIN,COLOR_SIZE + COLOR_MARGIN
	             
				 MOV                      [X1],0
	             MOV                      [Y1],COLOR_MARGIN + COLOR_SIZE + BAR_LINE_MARGIN
	             MOV                      [X2],MONITOR_LENGH
	             MOV                      [Y2],COLOR_MARGIN + COLOR_SIZE + BAR_LINE_MARGIN
	             DRAW_LINE
	;_____________________________DRAWING______________________________________

		
	        INITIAL_MOUSE
	        SHOW_MOUSE_CURSOR
		
	PAINT:  
			WAIT_FOR_KEY_PRESS
			JNZ EXIT
	        MOUSE_STATUS
	        CMP                      BX,0002H
	        JE                       ERASE_OP
	        CMP                      BX,0001H
	        JE                       DRAW_OP
			CMP					  	 BX,0004H
			JE						 RESET
	        JMP                      PAINT
			RESET:
			CLEAR_SCREEN
			MOV PENCIL,BLACK
			SHOW_MOUSE_CURSOR
			JMP PAINT
			
			ERASE_OP:    
			;CHECK POSITION
					 CMP                      DX,COLOR_MARGIN + COLOR_SIZE + BAR_LINE_MARGIN + 2
					 JB                       PAINT
					 ERASE
					 MOUSE_STATUS
					 CMP                      BX,0002H
					 JNE                      PAINT
					 JMP                      ERASE_OP
				
				
				
				
			DRAW_OP:     
					 CMP                      DX,COLOR_MARGIN + COLOR_SIZE + BAR_LINE_MARGIN + 2
					 JB                       COLOR_CHOOSE
					 JMP                      LINE
			COLOR_CHOOSE:
					 MOV                      AX,03H
					 INT                      33H
					 CMP                      BX,0001H
					 JNE                      COLOR_CHOOSE
					 SET_COLOR
					 JMP                      PAINT
					
			LINE:        
					 MOV                      [X1],CX
					 MOV                      [Y1],DX
					 CHECK_LEFT_CLICK_RELEASE
					 CMP                      DX,COLOR_MARGIN + COLOR_SIZE + BAR_LINE_MARGIN + 2
					 JB                       PAINT
					 DRAW_LINE
					 JMP                      PAINT
					 EXIT:
					 HIDE_MOUSE
					 SET_VIDEO_MODE	OLDVIDEO
					 MOV                      AH,4CH
					 INT                      21H

MAIN ENDP
		END MAIN