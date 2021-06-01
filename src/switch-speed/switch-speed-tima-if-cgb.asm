ROM_IS_CGB_ONLY = 1
INCLUDE "test-setup.inc"
SECTION "main", ROMX



; Verify that DIV and TIMA are running during speed change
; and that a TIMA overflow may be signalled in IF.

WRITE_RESULTS: MACRO
    BEGIN_WRITE_RESULTS

    ; store current TAC
    ld a, [rTAC]
    and a, %00000111
    ld [hl+], a

    ; store timer IF bit
    ld a, [rIF]
    and a, IEF_TIMER
    ld [hl+], a

    ; store current TIMA
    ld a, [rTIMA]
    ld [hl+], a

    END_WRITE_RESULTS
ENDM

RUN_TEST_DS: MACRO
    ; start timer
    RESTART_TIMER_CLEAN \1
    ; switch to double speed
    SWITCH_SPEED
    ; store test results
    WRITE_RESULTS
    ; switch to single speed
    SWITCH_SPEED
ENDM

RUN_TEST_SS: MACRO
    ; switch to double speed
    SWITCH_SPEED
    ; start timer
    RESTART_TIMER_CLEAN \1
    ; switch to single speed
    SWITCH_SPEED
    ; store test results
    WRITE_RESULTS
ENDM



main:
    RUN_TEST_DS TACF_4KHZ
    RUN_TEST_DS TACF_262KHZ
    RUN_TEST_DS TACF_65KHZ
    RUN_TEST_DS TACF_16KHZ

    RUN_TEST_SS TACF_4KHZ
    RUN_TEST_SS TACF_262KHZ
    RUN_TEST_SS TACF_65KHZ
    RUN_TEST_SS TACF_16KHZ

    FINISH_TEST .EXPECTED_RESULT_CGB_AB

; 2021-05-28 - verified on my Game Boy Color
; (CPU CGB A/B according to which.gb 0.3)
.EXPECTED_RESULT_CGB_AB:
    DB 8 + 8 + 8
    ;
    ;  switch to double speed
    ;  TAC  IF   TIMA
    DB $04, $00, $80
    DB $05, $04, $0A
    DB $06, $04, $02
    DB $07, $04, $00
    ;
    ;  switch to single speed
    ;  TAC  IF   TIMA
    DB $04, $00, $80
    DB $05, $04, $0A
    DB $06, $04, $02
    DB $07, $04, $00
