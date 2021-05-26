IF !DEF(INC_TEST_SETUP)
INC_TEST_SETUP = 1

INCLUDE "utilities.inc"


IF DEF(CGB_ONLY)
    SECTION "cgb-mode", ROM0[$143]
        DB $C0
ENDC



SECTION "entry", ROM0[$100]
    di
    jp setup

SECTION "setup", ROM0[$150]
setup:
    LCD_OFF

    ; copy ASCII font
    ld hl, _VRAM8000
    call copy_ascii_font

    ; clear tile map at $9800
    CLEAR_MEMORY _SCRN0, 20 * 18

    ; adjust BGP
    ld a, %11100100
    ld [rBGP], a

    ; adjust LCDC
    ld a, LCDCF_ON | LCDCF_WINOFF | LCDCF_BG8000 | LCDCF_BG9800 | LCDCF_OBJOFF | LCDCF_BGON
    ld [rLCDC], a

    jp main ; must be defined by the code that is including this file



ENDC
