IF !DEF(INC_UTILITIES)
INC_UTILITIES = 1

INCLUDE "hardware.inc"

SECTION "utilities", ROM0[$1000]



; ----------------------------------------------------------------------------
;
;   LCD macros
;
; ----------------------------------------------------------------------------

; Wait for LY == \1.
;
; @destroys af
;
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
;
WAIT_FOR_VBLANK: MACRO
    WAIT_FOR_LY 144
ENDM



; Wait for V-Blank and turn of the LCD.
;
; @see WAIT_FOR_VBLANK
; @destroys af, hl
;
LCD_OFF: MACRO
    ld hl, rLCDC
    bit 7, [hl]
    ret z ; LCD already off
    WAIT_FOR_VBLANK
    res 7, [hl]
ENDM



; ----------------------------------------------------------------------------
;
;   memory macros
;
; ----------------------------------------------------------------------------

; clear memory
;
; @param \1 destination address
; @param \2 number of bytes to clear
; @destroys af, bc, hl
;
CLEAR_MEMORY: MACRO
    ld hl, \1
    ld bc, \2
.clear\@:
    xor a, a
    ld [hl+], a
    dec bc
    ld a, b
    or a, c
    jr nz, .clear\@
ENDM



; copy (non-overlapping) memory
;
; @param \1 source address
; @param \2 destination address
; @param \3 number of bytes to copy
; @destroys af, bc, de, hl
;
COPY_MEMORY: MACRO
    ld de, \1
    ld hl, \2
    ld bc, \3
.copy\@:
    ld a, [de]
    ld [hl+], a
    inc de
    dec bc
    ld a, b
    or a, c
    jr nz, .copy\@
ENDM



; ----------------------------------------------------------------------------
;
;   miscellaneous macros
;
; ----------------------------------------------------------------------------

; generate `nop` instructions
;
; @param \1 the number of `nop` instructions to generate
; @destroys
;
NOPS: MACRO
    REPT \1
        nop
    ENDR
ENDM



; enter an infinite loop
;
FREEZE: MACRO
.loop\@:
    jr .loop\@
ENDM



; switch between CGB speed modes
;
; @destroys a
;
SWITCH_SPEED: MACRO
	ld a, 30
    ld [rP1], a
	ld a, 1
	ld [rKEY1], a
	stop
ENDM



ENDC
