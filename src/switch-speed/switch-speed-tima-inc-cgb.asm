ROM_IS_CGB_ONLY = 1
INCLUDE "test-setup.inc"
SECTION "main", ROMX



WRITE_RESULTS: MACRO
    BEGIN_WRITE_RESULTS

    ; store number of nops
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
    RUN_TEST_DS $09, TACF_262KHZ
    RUN_TEST_DS $0A, TACF_262KHZ
    RUN_TEST_DS $11, TACF_65KHZ
    RUN_TEST_DS $12, TACF_65KHZ
    RUN_TEST_DS $31, TACF_16KHZ
    RUN_TEST_DS $32, TACF_16KHZ

    RUN_TEST_SS $F1, TACF_4KHZ
    RUN_TEST_SS $F2, TACF_4KHZ
    RUN_TEST_SS $09, TACF_262KHZ
    RUN_TEST_SS $0A, TACF_262KHZ
    RUN_TEST_SS $11, TACF_65KHZ
    RUN_TEST_SS $12, TACF_65KHZ
    RUN_TEST_SS $31, TACF_16KHZ
    RUN_TEST_SS $32, TACF_16KHZ

    FINISH_TEST .EXPECTED_RESULT_CGB_AB

; 2021-05-28 - verified on my Game Boy Color
; (CPU CGB A/B according to which.gb 0.3)
.EXPECTED_RESULT_CGB_AB:
    DB 16 + 16
    ;
    ;  switch to double speed
    ;  NOPS TIMA
    DB $F1, $80
    DB $F2, $81
    DB $09, $09
    DB $0A, $0A
    DB $11, $02
    DB $12, $03
    DB $31, $00
    DB $32, $01
    ;
    ;  switch to single speed
    ;  NOPS TIMA
    DB $F1, $80
    DB $F2, $81
    DB $09, $09
    DB $0A, $0A
    DB $11, $02
    DB $12, $03
    DB $31, $00
    DB $32, $01
