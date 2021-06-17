ROM_IS_CGB_ONLY = 1
INCLUDE "test-setup.inc"
SECTION "main", ROMX



; - sound off/on
; - double speed (=> length counter delayed by 1 machine cycle)
; - single speed
; - sound off
; - 0-1 nops
; - sound on (=> "reactivates" length counter delay for next switch to double speed)
; - 0-1 nops
; - double speed
; - length counter always delayed by 1 machine cycle

WRITE_RESULTS: MACRO
    BEGIN_WRITE_RESULTS

    ; store number of nops before the second & the third switch to double speed
    ld a, (\1) * $10 + (\2)
    ld [hl+], a

    ; store number of additional nops (lower byte) before reading NR52
    ld a, (\3) & $FF
    ld [hl+], a

    ; store NR52
    ld a, [rNR52]
    ld [hl+], a

    END_WRITE_RESULTS
ENDM

RUN_TEST: MACRO
    xor a, a
    ld [rNR52], a ; all sound off
    ld [rDIV], a  ; reset DIV

    ld a, $80
    ld [rNR52], a ; sound on

    SWITCH_SPEED ; switch to double speed
    SWITCH_SPEED ; switch to single speed

    xor a, a
    ld [rNR52], a ; all sound off

    NOPS \1
    ld a, $80
    ld [rNR52], a ; sound on
    ld a, $3B
    ld [rNR21], a ; channel 2 length counter = 5
    ld a, $F0
    ld [rNR22], a
    ld a, $00
    ld [rNR23], a
    ld a, $C7
    ld [rNR24], a ; initialize channel 2 with length counter

    NOPS \2
    SWITCH_SPEED ; switch to double speed

    NOPS \3
    WRITE_RESULTS \1, \2, \3 ; store test results

    SWITCH_SPEED ; switch to single speed
ENDM



main:
    RUN_TEST 0, 0, 4078
    RUN_TEST 0, 0, 4079

    RUN_TEST 0, 1, 4078
    RUN_TEST 0, 1, 4079

    RUN_TEST 1, 0, 4078
    RUN_TEST 1, 0, 4079

    RUN_TEST 1, 1, 4078
    RUN_TEST 1, 1, 4079

    FINISH_TEST .EXPECTED_RESULT_CGB_AB

; 2021-06-17 - verified on my Game Boy Color
; (CPU CGB A/B according to which.gb 0.3)
.EXPECTED_RESULT_CGB_AB:
    DB 8 + 8 + 8
    ;
    ;  NOPS1&2 NOPS3 NR52
    DB $00,    $EE,  $F2
    DB $00,    $EF,  $F0

    DB $01,    $EE,  $F2
    DB $01,    $EF,  $F0

    DB $10,    $EE,  $F2
    DB $10,    $EF,  $F0

    DB $11,    $EE,  $F2
    DB $11,    $EF,  $F0
