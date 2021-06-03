ROM_IS_CGB_ONLY = 1
INCLUDE "test-setup.inc"
SECTION "main", ROMX



WRITE_RESULTS: MACRO
    BEGIN_WRITE_RESULTS

    ; store current TIMA
    ld a, [rTIMA]
    ld [hl+], a

    ; number of additional nops before speed change
    ld a, \1
    ld [hl+], a

    ; number of additional nops after speed change
    ld a, \2
    ld [hl+], a

    END_WRITE_RESULTS
ENDM

RUN_TEST_DS: MACRO
    ; start timer
    RESTART_TIMER_CLEAN \3
    ; do some nops before speed change
    NOPS \1
    ; switch to double speed
    SWITCH_SPEED
    ; do some nops to find the TIMA increment edge
    NOPS \2
    ; store test results
    WRITE_RESULTS \1, \2
    ; switch to single speed
    SWITCH_SPEED
ENDM

RUN_TEST_SS: MACRO
    ; switch to double speed
    SWITCH_SPEED
    ; start timer
    RESTART_TIMER_CLEAN \3
    ; do some nops before speed change
    NOPS \1
    ; switch to single speed
    SWITCH_SPEED
    ; do some nops to find the TIMA increment edge
    NOPS \2
    ; store test results
    WRITE_RESULTS \1, \2
ENDM
