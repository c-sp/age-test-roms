ROM_IS_CGB_ONLY = 1
INCLUDE "test-setup.inc"
SECTION "main", ROMX



; Estimate the number of machine cycles DIV and TIMA are
; active during speed change but the CPU is not.
; The estimation's accuracy is 4 machine cycles
; (based on the 262KHz timer).
;
; Additionally the number of machine cycles until the first
; TIMA increment after speed change is checked.

WRITE_RESULTS: MACRO
    BEGIN_WRITE_RESULTS

    ; store number of nops after speed change
    ld a, \1
    ld [hl+], a

    ; store current TIMA
    ld a, [rTIMA]
    ld [hl+], a

    END_WRITE_RESULTS
ENDM

RUN_TEST_DS: MACRO
    ; start timer
    RESTART_TIMER_CLEAN \2
    ; switch to double speed
    SWITCH_SPEED
    ; do some nops to find the TIMA increment edge
    NOPS \1
    ; store test results
    WRITE_RESULTS \1
    ; switch to single speed
    SWITCH_SPEED
ENDM

RUN_TEST_SS: MACRO
    ; switch to double speed
    SWITCH_SPEED
    ; start timer
    RESTART_TIMER_CLEAN \2
    ; switch to single speed
    SWITCH_SPEED
    ; do some nops to find the TIMA increment edge
    NOPS \1
    ; store test results
    WRITE_RESULTS \1
ENDM



main:
    RUN_TEST_DS $F1, TACF_4KHZ
    RUN_TEST_DS $F2, TACF_4KHZ
    RUN_TEST_DS $01, TACF_262KHZ
    RUN_TEST_DS $02, TACF_262KHZ
    RUN_TEST_DS $01, TACF_65KHZ
    RUN_TEST_DS $02, TACF_65KHZ
    RUN_TEST_DS $31, TACF_16KHZ
    RUN_TEST_DS $32, TACF_16KHZ

    RUN_TEST_SS $F1, TACF_4KHZ
    RUN_TEST_SS $F2, TACF_4KHZ
    RUN_TEST_SS $01, TACF_262KHZ
    RUN_TEST_SS $02, TACF_262KHZ
    RUN_TEST_SS $01, TACF_65KHZ
    RUN_TEST_SS $02, TACF_65KHZ
    RUN_TEST_SS $31, TACF_16KHZ
    RUN_TEST_SS $32, TACF_16KHZ

    FINISH_TEST .EXPECTED_RESULT_CGB_AB

; 2021-06-01 - verified on my Game Boy Color
; (CPU CGB A/B according to which.gb 0.3)
.EXPECTED_RESULT_CGB_AB:
    DB 16 + 16
    ;
    ;  switch to double speed
    ;  NOPS rTIMA
    DB $F1, $80
    DB $F2, $81
    DB $01, $07
    DB $02, $08
    DB $01, $01
    DB $02, $02
    DB $31, $00
    DB $32, $01
    ;
    ;  switch to single speed
    ;  NOPS rTIMA
    DB $F1, $80
    DB $F2, $81
    DB $01, $07
    DB $02, $08
    DB $01, $01
    DB $02, $02
    DB $31, $00
    DB $32, $01
