IF !DEF(INC_UTILITIES)
INC_UTILITIES = 1

INCLUDE "hardware.inc"

SECTION "utilities", ROM0[$400]



; ----------------------------------------------------------------------------
;
;   LCD macros
;
; ----------------------------------------------------------------------------

; Wait for LY == \1.
;
; @destroys af
WAIT_FOR_LY: MACRO
.loop\@
    ld a, [rLY]
    cp a, \1
    jr nz, .loop\@
ENDM

; Wait for v-blank beginning.
;
; @see WAIT_FOR_LY
; @destroys af
WAIT_FOR_VBLANK: MACRO
    WAIT_FOR_LY 144
ENDM

; Wait for V-Blank and turn of the LCD.
;
; @see WAIT_FOR_VBLANK
; @destroys af, hl
LCD_OFF: MACRO
    ld hl, rLCDC
    bit 7, [hl]
    ret z ; LCD already off
    WAIT_FOR_VBLANK
    res 7, [hl]
ENDM



; ----------------------------------------------------------------------------
;
;   miscellaneous macros
;
; ----------------------------------------------------------------------------

; Zero a chunk of memory.
;
; @param \1 address of the memory to clear
; @param \2 number of bytes to clear
; @destroys af, bc, hl
CLEAR_MEMORY: MACRO
    ld hl, \1
    ld bc, \2
.clear\@:
    xor a, a
    ld [hli], a
    dec bc
    ld a, b
    or a, c
    jr nz, .clear\@
ENDM

; Reset the `div` counter.
RESET_DIV: MACRO
    ld [rDIV], a ; the value does not really matter
ENDM

; Generate `nop` instructions.
;
; @param \1 the number of `nop` instructions to generate
NOPS: MACRO
    REPT \1
        nop
    ENDR
ENDM

; Enter an infinite loop.
FREEZE: MACRO
.loop\@:
    jr .loop\@
ENDM



; ----------------------------------------------------------------------------
;
;   font
;
; ----------------------------------------------------------------------------

; Setup VRAM tile data for rendering ASCII strings.
;
; @param hl font data destination
; @destroys af, bc, de, hl
copy_ascii_font:
    ; clear tile data for ASCII characters 0 - 31
    ld bc, 32 * 16
.clear_loop:
    xor a, a
    ld [hli], a
    dec bc
    ld a, b
    or a, c
    jr nz, .clear_loop

    ; copy data for ASCII characters 32 - 127
    ld de, .FONT_DATA_BEGIN
    ld bc, .FONT_DATA_END - .FONT_DATA_BEGIN
.copy_loop:
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or a, c
    jr nz, .copy_loop
    ret

; font based on the "small blocky font" created by Jerom
; https://opengameart.org/content/small-blocky-font
; https://opengameart.org/users/jerom
.FONT_DATA_BEGIN:
    INCBIN "font_small.2bpp"
.FONT_DATA_END:

; Print a null-terminated ASCII string to $9800.
;
; @param de pointer to the ascii string to print
; @destroys af, de, hl
print_ascii:
    WAIT_FOR_VBLANK
    ld hl, _SCRN0
.print:
    ld a, [de]
    or a, a
    ret z ; found null-terminator
    ld [hli], a
    inc de
    jr .print



; ----------------------------------------------------------------------------
;
;   test success / failure
;
; ----------------------------------------------------------------------------

; Indicate a successful test.
;
; This method will never return.
test_success:
    ld a, 2
    ld b, 3
    ld c, 5
    ld d, 8
    ld e, 13
    ld h, 21
    ld l, 34
    ld b, b
    FREEZE

; Indicate a failed test.
;
; This method will never return.
test_failure:
    ld a, 0
    ld b, 0
    ld c, 0
    ld d, 0
    ld e, 0
    ld h, 0
    ld l, 0
    ld b, b
    FREEZE



ENDC
