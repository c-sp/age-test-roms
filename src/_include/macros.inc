IF !DEF(INC_MACROS)
INC_MACROS = 1

INCLUDE "hardware.inc"



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
;   timer & div macros
;
; ----------------------------------------------------------------------------

; (Re-)start the timer with the specified frequency.
; We also reset the `DIV` and clear `IF`.
;
; @param \1 `TAC` frequency flags
; @destroys a
;
RESTART_TIMER_CLEAN: MACRO
    ; turn off timer
    xor a, a
    ld [rTAC], a
    ld [rTIMA], a
    ; clear all interrupts
    ld [rIF], a
    ; make sure we have a well defined DIV state
    ; (to prevent arbitrary TIMA increments by future DIV resets)
    ld [rDIV], a
    ; start timer
    ld a, TACF_START | \1
    ld [rTAC], a
ENDM



; ----------------------------------------------------------------------------
;
;   miscellaneous macros
;
; ----------------------------------------------------------------------------

; @param \1 the number of `nop` instructions to generate
; @destroys
;
NOPS: MACRO
    REPT \1
        nop
    ENDR
ENDM



; @param \1 the number of 256-`nop` delays to generate (0-255)
; @destroys
;
NOPS256: MACRO
    IF \1 > 0
        ; 8 m-cycles for this block
        push af ; 4 m-cycles
        push bc ; 4 m-cycles

        ; 8 m-cycles for this block
        ld b, \1          ; 2 m-cycles
        ld c, 62 - 24     ; 2 m-cycles
        nop               ; 1 m-cycle
        jr .loop_inner\@: ; 3 m-cycles

.loop\@:
        ; it takes 256 m-cycles for one .loop\@ iteration
        ; 4 m-cycles for this block
        ld c, 62 ; 2 m-cycles
        nop      ; 1 m-cycle
        nop      ; 1 m-cycle

.loop_inner\@:
        dec c                ; 1 m-cycle
        jr nz, .loop_inner\@ ; 3 m-cycles for jump, 2 m-cycles else
        nop                  ; 1 m-cycle (-> 4 m-cycles for each decrement)

        dec b          ; 1 m-cycle
        jr nz, .loop\@ ; 3 m-cycles for jump, 2 m-cycles else
        nop            ; 1 m-cycle (-> 4 m-cycles for each decrement)

        ; 8 m-cycles for this block
        nop    ; 1 m-cycle
        nop    ; 1 m-cycle
        pop bc ; 3 m-cycles
        pop af ; 3 m-cycles
    ENDC
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
	ld a, $30
    ld [rP1], a
	ld a, 1
	ld [rKEY1], a
	stop
ENDM



ENDC
