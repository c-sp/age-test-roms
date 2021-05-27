ROM_IS_CGB_ONLY = 1
INCLUDE "test-setup.inc"
SECTION "main", ROMX



RUN_TEST: MACRO
    ld a, TACF_START | \1
    ld b, a

    ; turn off timer
    xor a, a
    ld [rTAC], a
    ld [rTIMA], a
    ; make sure we have a well defined DIV state
    ; (to prevent unexpected TIMA increments by the DIV reset on STOP)
    ld [rDIV], a
    ; clear all interrupts
    ld [rIF], a
    ; start timer
    ld a, b
    ld [rTAC], a

    ; switch to double speed
    SWITCH_SPEED

    ; store TAC, IF & TIMA values
    LD_HL_RESULT_BUFFER
    ld a, b ; TAC
    ld [hl+], a
    ld a, [rIF]
    and a, IEF_TIMER
    ld [hl+], a
    ld a, [rTIMA]
    ld [hl], a
    ST_RESULT_BUFFER_HL

    ; switch to single speed
    SWITCH_SPEED
ENDM



main:
    RUN_TEST TACF_4KHZ
    RUN_TEST TACF_262KHZ
    RUN_TEST TACF_65KHZ
    RUN_TEST TACF_16KHZ
    FINISH_TEST .EXPECTED_RESULT

; verified 2021-05-27 on my Game Boy Color
; (a CGB A/B according to which.gb 0.3)
.EXPECTED_RESULT:
    DB $0C
    ;  TAC   IF  TIMA
    DB $04, $00, $80
    DB $05, $04, $09
    DB $06, $04, $02
    DB $07, $04, $00
