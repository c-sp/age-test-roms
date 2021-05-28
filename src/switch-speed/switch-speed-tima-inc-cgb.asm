ROM_IS_CGB_ONLY = 1
INCLUDE "test-setup.inc"
SECTION "main", ROMX



WRITE_RESULTS: MACRO
    BEGIN_WRITE_RESULTS

    ; store current TAC
    ;ld a, [rTAC]
    ;and a, %00000111
    ;ld [hl+], a
    NOPS 3
    NOPS 2
    NOPS 2

    ; store number of nops
    ;ld a, \1
    ;ld [hl+], a
    NOPS 2
    NOPS 2

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
    ; TODO find TIMA increment edges
    RUN_TEST_DS $00, TACF_4KHZ
    RUN_TEST_DS $10, TACF_4KHZ
    RUN_TEST_DS $20, TACF_4KHZ
    RUN_TEST_DS $30, TACF_4KHZ
    RUN_TEST_DS $40, TACF_4KHZ
    RUN_TEST_DS $50, TACF_4KHZ
    RUN_TEST_DS $60, TACF_4KHZ
    RUN_TEST_DS $70, TACF_4KHZ
    RUN_TEST_DS $80, TACF_4KHZ
    RUN_TEST_DS $90, TACF_4KHZ
    RUN_TEST_DS $A0, TACF_4KHZ
    RUN_TEST_DS $B0, TACF_4KHZ
    RUN_TEST_DS $C0, TACF_4KHZ
    RUN_TEST_DS $D0, TACF_4KHZ
    RUN_TEST_DS $E0, TACF_4KHZ
    RUN_TEST_DS $F0, TACF_4KHZ

    RUN_TEST_DS $00, TACF_262KHZ
    RUN_TEST_DS $02, TACF_262KHZ
    RUN_TEST_DS $04, TACF_262KHZ
    RUN_TEST_DS $06, TACF_262KHZ

    RUN_TEST_DS $00, TACF_65KHZ
    RUN_TEST_DS $08, TACF_65KHZ
    RUN_TEST_DS $10, TACF_65KHZ
    RUN_TEST_DS $18, TACF_65KHZ
    RUN_TEST_DS $20, TACF_65KHZ
    RUN_TEST_DS $28, TACF_65KHZ

    ; RUN_TEST_DS 1, TACF_4KHZ
    ; RUN_TEST_DS 1, TACF_262KHZ
    ; RUN_TEST_DS 1, TACF_65KHZ
    ; RUN_TEST_DS 1, TACF_16KHZ

    ; RUN_TEST_SS 1, TACF_4KHZ
    ; RUN_TEST_SS 1, TACF_262KHZ
    ; RUN_TEST_SS 1, TACF_65KHZ
    ; RUN_TEST_SS 1, TACF_16KHZ

    FINISH_TEST .EXPECTED_RESULT_CGB_AB

; TODO verify
.EXPECTED_RESULT_CGB_AB:
    DB 0
