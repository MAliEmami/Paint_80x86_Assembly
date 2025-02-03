# Assembly Paint Program
This is a simple paint program written in x86 assembly language. It uses BIOS and DOS interrupts to handle graphics, mouse input, and screen manipulation. The program allows users to draw lines, erase pixels, clear screen and select colors from a menu.

# Features
- Color Menu: Choose from colors in color bar by clicking in the colors area.

- Line Tool: Draw lines between two points using the left mouse button.

- Eraser Tool: Erase a 3x3 area using the right mouse button.

- Clear Screen: Erase all the screeen using the middle mouse button.

- Efficient Line Drawing: Uses Bresenham's line algorithm for smooth and fast line rendering.
  
# Program Structure
- MACROS
  - PRINT_A_CHAR
  - PRINT
  - FILL
  - FILL_PIXEL
  - ERASE
  - PAINT_PIXEL
  - SET_BACKGROUND_WHITE
  - SET_COLOR
  - SET_CURSOR
  - WAIT_FOR_KEY_PRESS
  - SET_VIDEO_MODE
  - GET_OLD_VIDEO_MODE
  - CLEAR_SCREEN
  - INITIAL_MOUSE
  - SHOW_MOUSE_CURSOR
  - HIDE_MOUSE
  - MOUSE_STATUS
  - CHECK_LEFT_CLICK_RELEASE
  - PLOT_LOW
  - PLOT_HIGH
  - DRAW_LINE

- Main

# View ![image](https://github.com/user-attachments/assets/d144da92-3504-4b85-b3e9-2eb664a3cbcf)
