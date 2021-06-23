ROM_IS_CGB_ONLY = 1
INCLUDE "test-setup.inc"



; TODO add sound off/on tests

; Verified:
;   2021-06-23 pass on CPU CGB E (CPU-CGB-06)
;   2021-06-23 pass on CPU CGB B (CPU-CGB-02)
EXPECTED_TEST_RESULTS:
    ; number of test result rows
    DB 6
    ; ch2 init -> double speed
    DB $F2, $F0,  $F2, $F0,  $F2, $F0,  $F2, $F0
    ; ch2 init -> double speed -> channel init
    DB $F2, $F0,  $F2, $F0,  $00, $00,  $00, $00
    ; ch2 init -> double speed -> div reset
    DB $F2, $F0,  $F2, $F0,  $00, $00,  $00, $00
    ; ch2 init -> double speed -> single speed -> double speed
    DB $F2, $F0,  $F2, $F0,  $F2, $F0,  $F2, $F0
    ; ch2 init -> double speed -> div reset -> single speed -> double speed
    DB $F2, $F0,  $F2, $F0,  $F2, $F0,  $F2, $F0
    ; ch2 init -> double speed -> single speed -> double speed -> single speed -> double speed
    DB $F2, $F0,  $F2, $F0,  $F2, $F0,  $F2, $F0



STORE_NR52: MACRO
    ld a, [rNR52]
    ld [hl+], a
ENDM

INIT_TEST: MACRO
    xor a, a
    ld [rNR52], a ; sound off
    ld [rDIV], a  ; reset DIV
ENDM

SOUND_ON: MACRO
    ld a, $80
    ld [rNR52], a
ENDM

INIT_CH2_LC: MACRO
    ld a, \1
    ld [rNR21], a ; channel 2 length counter = \1
    ld a, $F0
    ld [rNR22], a
    ld a, $00
    ld [rNR23], a
    ld a, $C7
    ld [rNR24], a ; initialize channel 2 with length counter
ENDM



; Length counter ticks are delayed by 1 m-cycle after
; switching to double speed no matter on what 1MHz edge
; sound was activated and speeds were switched.
TEST_DS: MACRO
    INIT_TEST
    NOPS \1
    SOUND_ON
    INIT_CH2_LC $3B ; channel 2 length counter = 5
    NOPS \2
    SWITCH_SPEED    ; switch to double speed (length counter ticks delayed by 1 m-cycle)
    NOPS \3
    STORE_NR52      ; read channel 2 on flag
    SWITCH_SPEED    ; switch to single speed
ENDM

; TODO describe
TEST_DS_CH2_INIT: MACRO
    INIT_TEST
    SOUND_ON
    SWITCH_SPEED    ; switch to double speed (length counter ticks delayed by 1 m-cycle)
    NOPS \1
    INIT_CH2_LC $3F ; channel 2 length counter = 1
    NOPS \2
    STORE_NR52      ; read channel 2 on flag
    SWITCH_SPEED    ; switch to single speed
ENDM

; TODO describe
TEST_DS_DIV_RESET: MACRO
    INIT_TEST
    SOUND_ON
    INIT_CH2_LC $3B ; channel 2 length counter = 5
    SWITCH_SPEED    ; switch to double speed (length counter ticks delayed by 1 m-cycle)
    NOPS \1
    ld [rDIV], a    ; reset DIV (length counter ticks not delayed any more)
    NOPS \2
    STORE_NR52      ; read channel 2 on flag
    SWITCH_SPEED    ; switch to single speed
ENDM

; The second switch to double speed does not introduce
; a 1 m-cycle length counter delay no matter on what 2MHz
; edge the switch to single speed occurred and on what
; 1MHz edge double speed was activated.
TEST_DS_SS_DS: MACRO
    INIT_TEST
    SOUND_ON
    INIT_CH2_LC $2F ; channel 2 length counter = 17
    SWITCH_SPEED    ; switch to double speed (length counter ticks delayed by 1 m-cycle)
    NOPS \1
    SWITCH_SPEED    ; switch to single speed
    NOPS \2
    SWITCH_SPEED    ; switch to double speed (length counter ticks not delayed)
    NOPS \3
    STORE_NR52      ; read channel 2 on flag
    SWITCH_SPEED    ; switch to single speed
ENDM

; TODO describe
TEST_DS_DIV_RESET_SS_DS: MACRO
    INIT_TEST
    SOUND_ON
    INIT_CH2_LC $2F ; channel 2 length counter = 17
    SWITCH_SPEED    ; switch to double speed (length counter ticks delayed by 1 m-cycle)
    NOPS \1
    ld [rDIV], a    ; reset DIV (length counter ticks not delayed any more)
    NOPS \2
    SWITCH_SPEED    ; switch to single speed
    SWITCH_SPEED    ; switch to double speed
    NOPS \3
    STORE_NR52      ; read channel 2 on flag
    SWITCH_SPEED    ; switch to single speed
ENDM

; Length counter ticks are delayed by 1 m-cycle after the
; third switch to double speed no matter on what 2MHz
; edges single speed was activated.
TEST_DS_SS_DS_SS_DS: MACRO
    INIT_TEST
    SOUND_ON
    INIT_CH2_LC $23 ; channel 2 length counter = 29
    SWITCH_SPEED    ; switch to double speed (length counter ticks delayed by 1 m-cycle)
    NOPS \1
    SWITCH_SPEED    ; switch to single speed
    SWITCH_SPEED    ; switch to double speed (length counter ticks not delayed)
    NOPS \2
    SWITCH_SPEED    ; switch to single speed
    SWITCH_SPEED    ; switch to double speed (length counter ticks delayed by 1 m-cycle)
    NOPS \3
    STORE_NR52      ; read channel 2 on flag
    SWITCH_SPEED    ; switch to single speed
ENDM



run_test:
    LCD_OFF
    ld hl, TEST_RESULTS

    TEST_DS 0, 0, 4093
    TEST_DS 0, 0, 4094
    TEST_DS 0, 1, 4093
    TEST_DS 0, 1, 4094
    TEST_DS 1, 0, 4093
    TEST_DS 1, 0, 4094
    TEST_DS 1, 1, 4093
    TEST_DS 1, 1, 4094

    TEST_DS_CH2_INIT 0, 4073
    TEST_DS_CH2_INIT 0, 4074
    TEST_DS_CH2_INIT 1, 4072
    TEST_DS_CH2_INIT 1, 4073
    xor a, a
    ld [hl+], a ; result padding
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a

    TEST_DS_DIV_RESET 0, 4093
    TEST_DS_DIV_RESET 0, 4094
    TEST_DS_DIV_RESET 1, 4093
    TEST_DS_DIV_RESET 1, 4094
    xor a, a
    ld [hl+], a ; result padding
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a

    TEST_DS_SS_DS 0, 0, 4092
    TEST_DS_SS_DS 0, 0, 4093
    TEST_DS_SS_DS 0, 1, 4092
    TEST_DS_SS_DS 0, 1, 4093
    TEST_DS_SS_DS 1, 0, 4092
    TEST_DS_SS_DS 1, 0, 4093
    TEST_DS_SS_DS 1, 1, 4092
    TEST_DS_SS_DS 1, 1, 4093

    TEST_DS_DIV_RESET_SS_DS 0, 0, 4092
    TEST_DS_DIV_RESET_SS_DS 0, 0, 4093
    TEST_DS_DIV_RESET_SS_DS 0, 1, 4092
    TEST_DS_DIV_RESET_SS_DS 0, 1, 4093
    TEST_DS_DIV_RESET_SS_DS 1, 0, 4092
    TEST_DS_DIV_RESET_SS_DS 1, 0, 4093
    TEST_DS_DIV_RESET_SS_DS 1, 1, 4092
    TEST_DS_DIV_RESET_SS_DS 1, 1, 4093

    TEST_DS_SS_DS_SS_DS 0, 0, 4093
    TEST_DS_SS_DS_SS_DS 0, 0, 4094
    TEST_DS_SS_DS_SS_DS 0, 1, 4093
    TEST_DS_SS_DS_SS_DS 0, 1, 4094
    TEST_DS_SS_DS_SS_DS 1, 0, 4093
    TEST_DS_SS_DS_SS_DS 1, 0, 4094
    TEST_DS_SS_DS_SS_DS 1, 1, 4093
    TEST_DS_SS_DS_SS_DS 1, 1, 4094

    ret
