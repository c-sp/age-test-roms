DEF ROM_IS_CGB_ONLY EQU 1
INCLUDE "test-setup.inc"



EXPECTED_TEST_RESULTS:
    ; number of test result rows
    DB 7
    ; TIMA & IF for 4KHz, 262KHz, 65KHz, 16KHz
    DB $80, $E0,  $04, $E4,  $01, $E4,  $00, $E4
    ; 4KHz TIMA (immediate) increment edges
    DB $80, $80, $81, $81,  $81, $81, $82, $82
    ; 4KHz TIMA 1->0 edge
    DB $81, $81, $82, $82,  $81, $81, $82, $82
    DB $81, $81, $82, $82,  $00, $00, $00, $00
    ; 262KHz TIMA (immediate) increment edges
    DB $04, $04, $05, $05,  $05, $05, $06, $06
    ; 65KHz TIMA (immediate) increment edges
    DB $01, $01, $02, $02,  $02, $02, $03, $03
    ; 16KHz TIMA (immediate) increment edges
    DB $00, $00, $01, $01,  $01, $01, $02, $02



SAVE_TIMA: MACRO
    ldh a, [rTIMA]
    ld [hl+], a
ENDM



; Start the timer, Switch to double speed and
; immediately read TIMA & IF.
; During the speed switch the timer keeps running
; while the CPU is inactive for a while.
TEST_DS_IF: MACRO
    TIMER_RESTART_CLEAN \1
    SWITCH_SPEED ; switch to double speed
    SAVE_TIMA
    ldh a, [rIF]
    ld [hl+], a
    SWITCH_SPEED ; switch to single speed
ENDM

; The DIV reset automatically triggered when switching
; speeds may cause immediate TIMA increments.
; For the 4KHz timer the edge for immediate increments
; is 1 m-cycle late.
; However, this 1 m-cycle delay only affects the
; 1->0 edge and not the 0->1 edge.
TEST_INC_EDGE: MACRO
    TIMER_RESTART_CLEAN \3
    DELAY \1
    SWITCH_SPEED ; switch to double speed
    DELAY \2
    SAVE_TIMA

    TIMER_RESTART_CLEAN \3
    DELAY \1
    SWITCH_SPEED ; switch to single speed
    DELAY \2
    SAVE_TIMA
ENDM



run_test:
    LCD_OFF
    ld hl, TEST_RESULTS

    TEST_DS_IF TACF_4KHZ
    TEST_DS_IF TACF_262KHZ
    TEST_DS_IF TACF_65KHZ
    TEST_DS_IF TACF_16KHZ

    TEST_INC_EDGE 110, 252, TACF_4KHZ ; 1 m-cycle before immediate increment by DIV reset
    TEST_INC_EDGE 110, 253, TACF_4KHZ ; 1 m-cycle before immediate increment by DIV reset
    TEST_INC_EDGE 111, 252, TACF_4KHZ ; trigger immediate increment by DIV reset
    TEST_INC_EDGE 111, 253, TACF_4KHZ ; trigger immediate increment by DIV reset

    TEST_INC_EDGE 237, 252, TACF_4KHZ ; 1 m-cycle before the 1->0 edge of the respective DIV bit
    TEST_INC_EDGE 237, 253, TACF_4KHZ ; 1 m-cycle before the 1->0 edge of the respective DIV bit
    TEST_INC_EDGE 238, 252, TACF_4KHZ ; right on the 1->0 edge of the respective DIV bit
    TEST_INC_EDGE 238, 253, TACF_4KHZ ; right on the 1->0 edge of the respective DIV bit
    TEST_INC_EDGE 239, 252, TACF_4KHZ ; 1 m-cycle after the 1->0 edge of the respective DIV bit
    TEST_INC_EDGE 239, 253, TACF_4KHZ ; 1 m-cycle after the 1->0 edge of the respective DIV bit
    inc hl ; result padding
    inc hl
    inc hl
    inc hl

    TEST_INC_EDGE 2, 0, TACF_262KHZ ; 1 m-cycle before immediate increment by DIV reset
    TEST_INC_EDGE 2, 1, TACF_262KHZ ; 1 m-cycle before immediate increment by DIV reset
    TEST_INC_EDGE 4, 0, TACF_262KHZ ; trigger immediate increment by DIV reset
    TEST_INC_EDGE 4, 1, TACF_262KHZ ; trigger immediate increment by DIV reset

    call device_specific_tests ; device dependent behaviour for 65KHz and 16KHz timer

    TIMER_OFF
    ret
