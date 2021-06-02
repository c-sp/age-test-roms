ROM_IS_CGB_ONLY = 1
INCLUDE "test-setup.inc"
SECTION "main", ROMX



; The number of machine cylces after speed change until the
; next DIV increment is constant regardless of the DIV's
; state right before speed change.
; Reading rDIV right after speed change always yields zero.
;
; => We know that changing speeds resets the DIV
;    (most likely due to STOP being executed),
;    but it is not yet clear when exactly this reset happens.

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
    ; do some nops to switch speeds at different DIV values
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
    ; do some nops to switch speeds at different DIV values
    NOPS \1
    ; switch to single speed
    SWITCH_SPEED
    ; do some nops to find the DIV increment edge
    NOPS \2
    ; store test results
    WRITE_RESULTS \1, \2
ENDM



main:
    RUN_TEST_DS $00, $2D
    RUN_TEST_DS $00, $2E
    RUN_TEST_DS $80, $2D
    RUN_TEST_DS $80, $2E

    RUN_TEST_SS $00, $2D
    RUN_TEST_SS $00, $2E
    RUN_TEST_SS $80, $2D
    RUN_TEST_SS $80, $2E

    FINISH_TEST .EXPECTED_RESULT_CGB_AB

; 2021-05-28 - verified on my Game Boy Color
; (CPU CGB A/B according to which.gb 0.3)
.EXPECTED_RESULT_CGB_AB:
    DB 8 + 8 + 8
    ;
    ;  NOPS1: number of nops before switching speeds
    ;  NOPS2: number of nops after switching speeds
    ;         and before reading rDIV
    ;
    ;  switch to double speed
    ;  NOPS1 NOPS2 rDIV
    DB $00,  $2D,  $00
    DB $00,  $2E,  $01
    DB $80,  $2D,  $00
    DB $80,  $2E,  $01
    ;
    ;  switch to single speed
    ;  NOPS1 NOPS2 rDIV
    DB $00,  $2D,  $00
    DB $00,  $2E,  $01
    DB $80,  $2D,  $00
    DB $80,  $2E,  $01
