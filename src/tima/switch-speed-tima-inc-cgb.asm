ROM_IS_CGB_ONLY = 1
INCLUDE "test-setup.inc"
SECTION "main", ROMX



; Verify the TIMA value right after switching speeds.

WRITE_RESULTS: MACRO
    BEGIN_WRITE_RESULTS

    ; store current TIMA
    ld a, [rTIMA]
    ld [hl+], a

    ; store number of nops after speed change
    ld a, \1
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
    RUN_TEST_DS $F5, TACF_4KHZ
    RUN_TEST_DS $F6, TACF_4KHZ
    RUN_TEST_DS $01, TACF_262KHZ
    RUN_TEST_DS $02, TACF_262KHZ
    RUN_TEST_DS $05, TACF_65KHZ
    RUN_TEST_DS $06, TACF_65KHZ
    RUN_TEST_DS $35, TACF_16KHZ
    RUN_TEST_DS $36, TACF_16KHZ

    RUN_TEST_SS $F5, TACF_4KHZ
    RUN_TEST_SS $F6, TACF_4KHZ
    RUN_TEST_SS $01, TACF_262KHZ
    RUN_TEST_SS $02, TACF_262KHZ
    RUN_TEST_SS $05, TACF_65KHZ
    RUN_TEST_SS $06, TACF_65KHZ
    RUN_TEST_SS $35, TACF_16KHZ
    RUN_TEST_SS $36, TACF_16KHZ

    FINISH_TEST .EXPECTED_RESULT_CGB_AB

; 2021-06-15 - verified on my Game Boy Color
; (CPU CGB A/B according to which.gb 0.3)
.EXPECTED_RESULT_CGB_AB:
    DB 16 + 16
    ;
    ;  switch to double speed
    ;  TIMA NOPS
    DB $80, $F5
    DB $81, $F6
    DB $06, $01
    DB $07, $02
    DB $01, $05
    DB $02, $06
    DB $00, $35
    DB $01, $36
    ;
    ;  switch to single speed
    ;  TIMA NOPS
    DB $80, $F5
    DB $81, $F6
    DB $06, $01
    DB $07, $02
    DB $01, $05
    DB $02, $06
    DB $00, $35
    DB $01, $36
