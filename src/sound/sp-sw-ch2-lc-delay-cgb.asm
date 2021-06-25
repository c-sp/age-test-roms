DEF ROM_IS_CGB_ONLY EQU 1
INCLUDE "test-setup.inc"



; Verified:
;   passes on CPU CGB E - CPU-CGB-06 (2021-06-24)
;   passes on CPU CGB B - CPU-CGB-02 (2021-06-24)
EXPECTED_TEST_RESULTS:
    ; number of test result rows
    DB 7
    ; ch2 init -> double speed
    DB $F2, $F0,  $F2, $F0,  $F2, $F0,  $F2, $F0
    ; ch2 init -> double speed -> ch2 init
    DB $F2, $F0,  $F2, $F0,  $00, $00,  $00, $00
    ; ch2 init -> double speed -> div reset
    DB $F2, $F0,  $F2, $F0,  $00, $00,  $00, $00
    ; sound off -> double speed -> sound on, ch2 init
    DB $F2, $F0,  $F2, $F0,  $00, $00,  $00, $00
    ; sound on -> double speed -> sound off, sound on, ch2 init
    DB $F2, $F0,  $F2, $F0,  $F2, $F0,  $F2, $F0
    ; ch2 init -> double speed -> single speed -> double speed
    DB $F2, $F0,  $F2, $F0,  $F2, $F0,  $F2, $F0
    ; ch2 init -> double speed -> single speed -> double speed -> single speed -> double speed
    DB $F2, $F0,  $F2, $F0,  $F2, $F0,  $F2, $F0



SAVE_NR52: MACRO
    ldh a, [rNR52]
    ld [hl+], a
ENDM

ADD_4_BYTE_PADDING: MACRO
    inc hl
    inc hl
    inc hl
    inc hl
ENDM

SOUND_OFF: MACRO
    xor a, a
    ldh [rNR52], a
ENDM

SOUND_ON: MACRO
    ld a, $80
    ldh [rNR52], a
ENDM

INIT_TEST: MACRO
    SOUND_OFF
    ldh [rDIV], a ; reset DIV
ENDM

INIT_CH2_LC: MACRO
    ld a, \1
    ldh [rNR21], a ; channel 2 length counter = \1
    ld a, $F0
    ldh [rNR22], a
    ld a, $00
    ldh [rNR23], a
    ld a, $C7
    ldh [rNR24], a ; initialize channel 2 with length counter
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
    SAVE_NR52       ; read channel-2-on flag
    SWITCH_SPEED    ; switch to single speed
ENDM

; Initialising channel 2 while running at double speed does
; not neutralise the current 1-m-cycle length counter
; delay no matter on what 2MHz edge channel 2 was initialised.
TEST_DS_CH2_INIT: MACRO
    INIT_TEST
    SOUND_ON
    SWITCH_SPEED    ; switch to double speed (length counter ticks delayed by 1 m-cycle)
    NOPS \1
    INIT_CH2_LC $3F ; channel 2 length counter = 1
    NOPS \2
    SAVE_NR52       ; read channel-2-on flag
    SWITCH_SPEED    ; switch to single speed
ENDM

; Resetting the DIV while running at double speed does
; not neutralise the current 1-m-cycle length counter
; delay no matter on what 2MHz edge the DIV was reset.
TEST_DS_DIV_RESET: MACRO
    INIT_TEST
    SOUND_ON
    INIT_CH2_LC $3B ; channel 2 length counter = 5
    SWITCH_SPEED    ; switch to double speed (length counter ticks delayed by 1 m-cycle)
    NOPS \1
    ldh [rDIV], a    ; reset DIV
    NOPS \2
    SAVE_NR52       ; read channel-2-on flag
    SWITCH_SPEED    ; switch to single speed
ENDM

; TODO describe
TEST_DS_ON: MACRO
    INIT_TEST
    SWITCH_SPEED    ; switch to double speed (sound is off)
    NOPS \1
    SOUND_ON
    INIT_CH2_LC $3F ; channel 2 length counter = 1
    NOPS \2
    SAVE_NR52       ; read channel-2-on flag
    SWITCH_SPEED    ; switch to single speed
ENDM

; TODO describe
TEST_DS_OFF_ON: MACRO
    INIT_TEST
    SOUND_ON
    SWITCH_SPEED    ; switch to double speed (length counter ticks delayed by 1 m-cycle)
    NOPS \1
    SOUND_OFF
    NOPS \2
    SOUND_ON
    INIT_CH2_LC $3F ; channel 2 length counter = 1
    NOPS \3
    SAVE_NR52       ; read channel-2-on flag
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
    SAVE_NR52       ; read channel-2-on flag
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
    SAVE_NR52       ; read channel-2-on flag
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
    ADD_4_BYTE_PADDING

    TEST_DS_DIV_RESET 0, 4093
    TEST_DS_DIV_RESET 0, 4094
    TEST_DS_DIV_RESET 1, 4093
    TEST_DS_DIV_RESET 1, 4094
    ADD_4_BYTE_PADDING

    TEST_DS_ON 0, 4067
    TEST_DS_ON 0, 4068
    TEST_DS_ON 1, 4066
    TEST_DS_ON 1, 4067
    ADD_4_BYTE_PADDING

    TEST_DS_OFF_ON 0, 0, 4063
    TEST_DS_OFF_ON 0, 0, 4064
    TEST_DS_OFF_ON 0, 1, 4062
    TEST_DS_OFF_ON 0, 1, 4063
    TEST_DS_OFF_ON 1, 0, 4062
    TEST_DS_OFF_ON 1, 0, 4063
    TEST_DS_OFF_ON 1, 1, 4061
    TEST_DS_OFF_ON 1, 1, 4062

    TEST_DS_SS_DS 0, 0, 4092
    TEST_DS_SS_DS 0, 0, 4093
    TEST_DS_SS_DS 0, 1, 4092
    TEST_DS_SS_DS 0, 1, 4093
    TEST_DS_SS_DS 1, 0, 4092
    TEST_DS_SS_DS 1, 0, 4093
    TEST_DS_SS_DS 1, 1, 4092
    TEST_DS_SS_DS 1, 1, 4093

    TEST_DS_SS_DS_SS_DS 0, 0, 4093
    TEST_DS_SS_DS_SS_DS 0, 0, 4094
    TEST_DS_SS_DS_SS_DS 0, 1, 4093
    TEST_DS_SS_DS_SS_DS 0, 1, 4094
    TEST_DS_SS_DS_SS_DS 1, 0, 4093
    TEST_DS_SS_DS_SS_DS 1, 0, 4094
    TEST_DS_SS_DS_SS_DS 1, 1, 4093
    TEST_DS_SS_DS_SS_DS 1, 1, 4094

    SOUND_OFF
    ret
