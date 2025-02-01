SET_BACKGROUND_WHITE MACRO
                     MOV AH,0B
                     MOV BH,0
                     MOV BL,WHITE
                     INT 10H
                     INT 3H
ENDM