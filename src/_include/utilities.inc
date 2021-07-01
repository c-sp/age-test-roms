IF !DEF(INC_UTILITIES)
INC_UTILITIES = 1

INCLUDE "hardware.inc"
INCLUDE "macros.inc"



; ----------------------------------------------------------------------------
;
;   LCD
;
; ----------------------------------------------------------------------------

; Wait for v-blank beginning.
; To reduce AGE log spam we try to minimize the number of rLY reads.
;
; @destroys
;
wait_for_vblank:
    push af
    push bc
.ly_loop:
    ldh a, [rLY]     ; 3 m-cycles
    cp a, 144        ; 2 m-cycles
    jp z, .finish    ; 2 m-cycles if not jumping
    cp a, 142        ; 2 m-cycles
    jr c, .long_wait ; 2 m-cycles if not jumping, 3 m-cycles else
    ; if we're near scanline 143,
    ; use short delays to reach scanline 144
    DELAY 50         ; 50 m-cycles
    jr .ly_loop      ; 3 m-cycles
    ; if we're well before scanline 143,
    ; use long delays to minimize reading rLY
.long_wait:
    ld b, a
    ld a, 142
    sub a, b
.long_loop:
    DELAY 456 / 4 - 4
    dec a
    jr nz, .long_loop
    jp .ly_loop
    ; scanline 144 reached
.finish:
    pop bc
    pop af
    ret

; Wait for V-Blank and turn of the LCD.
;
; @see wait_for_vblank
; @destroys
;
lcd_off:
    push af
    push hl
    ld hl, rLCDC
    bit 7, [hl]
    jr z, .already_off
    call wait_for_vblank
    res 7, [hl]
.already_off:
    pop hl
    pop af
    ret



ENDC
