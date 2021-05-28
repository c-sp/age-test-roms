ROM_IS_CGB_ONLY = 1
INCLUDE "test-setup.inc"
SECTION "main", ROMX



WRITE_RESULTS: MACRO
    BEGIN_WRITE_RESULTS

    ; store number of nops before speed switch
    ld a, \1
    ld [hl+], a

    ; store number of nops after speed switch
    ld a, \2
    ld [hl+], a

    ; store current DIV
    ld a, [rDIV]
    ld [hl+], a

    END_WRITE_RESULTS
ENDM

RUN_TEST_DS: MACRO
    ; reset DIV
    ld [rDIV], a
    ; do some nops to switch speed at different DIV values
    NOPS \1
    ; switch to double speed
    SWITCH_SPEED
    ; do some nops to find the DIV increment edge
    NOPS \2
    ; store test results
    WRITE_RESULTS \1, \2
    ; switch to single speed
    SWITCH_SPEED
ENDM

RUN_TEST_SS: MACRO
    ; switch to double speed
    SWITCH_SPEED
    ; reset DIV
    ld [rDIV], a
    ; do some nops to switch speed at different DIV values
    NOPS \1
    ; switch to single speed
    SWITCH_SPEED
    ; do some nops to find the DIV increment edge
    NOPS \2
    ; store test results
    WRITE_RESULTS \1, \2
ENDM



main:
    ; TODO find DIV increment edge
    RUN_TEST_DS $0, $00
    RUN_TEST_DS $0, $10
    RUN_TEST_DS $0, $20
    RUN_TEST_DS $0, $30
    RUN_TEST_DS $0, $40
    RUN_TEST_DS $0, $50
    RUN_TEST_DS $0, $60
    RUN_TEST_DS $0, $70

    FINISH_TEST .EXPECTED_RESULT_CGB_AB

; TODO verify
.EXPECTED_RESULT_CGB_AB:
    DB 0
