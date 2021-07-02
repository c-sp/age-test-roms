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
    ; if we're near line 143,
    ; use short delays to reach line 144
    DELAY 50         ; 50 m-cycles
    jr .ly_loop      ; 3 m-cycles
    ; if we're well before line 143,
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
    ; line 144 reached
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



; ----------------------------------------------------------------------------
;
;   test result compaction
;
; ----------------------------------------------------------------------------

COMPACT_RESULTS_LINES: MACRO
    REPT \1
        COMPACT_RESULTS_LINE \2, \3
    ENDR
ENDM

COMPACT_RESULTS_LINE: MACRO
    STATIC_ASSERT (\1 > 0) && (\1 <= 8)
    STATIC_ASSERT \2 > 0

    FOR I, \1
        ld a, \2
        call compact_results
    ENDR
    REPT 8 - \1
        inc hl
    ENDR
ENDM

; @param a  number of bytes to compact
; @param bc address of the test results to compact
; @param de address of the expected test results
; @param hl address to store the compaction result
;
; @return bc input bc incremented by a
; @return de input de incremented by a
; @return hl input hl incremented by one
;
; @destroys af
;
compact_results:
    push hl
    push af
    ld l, a
.compare_byte:
    ld a, [de]
    ld h, a
    ld a, [bc]
    cp a, h
    jr z, .next_byte
    ; test result mismatch:
    ; write the incorrect byte's index to [hl]
    pop af
    sub l
.fast_forward:
    inc de
    inc bc
    dec l
    jr nz, .fast_forward
    jr .return
.next_byte:
    inc de
    inc bc
    dec l
    jr nz, .compare_byte
    ; test result matches:
    ; write $FF to [hl]
    pop af
    ld a, $FF
.return:
    pop hl
    ld [hl+], a
    ret



ENDC
