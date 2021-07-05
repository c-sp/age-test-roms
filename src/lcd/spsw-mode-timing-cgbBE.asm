; The LCD-to-CPU alignment can change when switching
; to double speed and back to single speed.
;
; Verified:
;   passes on CPU CGB E - CPU-CGB-06 (2021-07-05)
;   passes on CPU CGB B - CPU-CGB-02 (2021-07-05)
;
DEF ROM_IS_CGB_ONLY EQU 1
INCLUDE "test-setup.inc"



EXPECTED_TEST_RESULTS:
    DB 9
    ; single speed
    DB $02, $03, $03, $04, $83, $80, $83, $80
    DB $83, $80, $83, $80, $83, $80, $83, $80
    DB $83, $80, $83, $80, $83, $80, $83, $80
    ; double speed
    DB $0D, $0E, $0E, $0F, $83, $80, $83, $80
    DB $83, $80, $83, $80, $83, $80, $83, $80
    DB $83, $80, $83, $80, $83, $80, $83, $80
    ; single speed
    DB $0E, $0F, $0F, $10, $83, $80, $83, $80
    DB $83, $80, $83, $80, $83, $80, $83, $80
    DB $83, $80, $83, $80, $83, $80, $83, $80



MACRO SCX_TEST
    ld a, \1      ; 2 m-cycles
    ldh [rSCX], a ; 3 m-cycles
    DELAY \2
    ld a, [de]    ; 2 m-cycles
    ld [hl+], a   ; 2 m-cycles
    DELAY \3
    ld a, [de]    ; 2 m-cycles
    ld [hl+], a   ; 2 m-cycles
ENDM



run_test:
    call lcd_off
    ld hl, TEST_RESULTS
    ld a, LCDCF_ON | LCDCF_BGON
    ldh [rLCDC], a

    ; read rLY right before and right after it is incremented
    DELAY 456 * 3 / 4 - 10
    ld de, rLY   ; 3 m-cycles
    ld a, [de]   ; 2 m-cycles
    ld [hl+], a  ; 2 m-cycles
    ld a, [de]   ; 2 m-cycles
    ld [hl+], a  ; 2 m-cycles
    ; read rLY right before and right after it is incremented
    DELAY 456 / 4 - 5
    ld a, [de]   ; 2 m-cycles
    ld [hl+], a  ; 2 m-cycles
    ld a, [de]   ; 2 m-cycles
    ld [hl+], a  ; 2 m-cycles
    ; read mode3/0 edges for different SCX values
    ld de, rSTAT ; 3 m-cycles
    SCX_TEST 0,  48, 456 / 4 - 3
    SCX_TEST 1, 104, 456 / 4 - 3
    SCX_TEST 2, 104, 456 / 4 - 3
    SCX_TEST 3, 104, 456 / 4 - 3
    SCX_TEST 4, 105, 456 / 4 - 3
    SCX_TEST 5, 104, 456 / 4 - 3
    SCX_TEST 6, 104, 456 / 4 - 3
    SCX_TEST 7, 104, 456 / 4 - 3
    SCX_TEST 8, 103, 456 / 4 - 3
    SCX_TEST 9, 104, 456 / 4 - 3


    ; switch to double speed
    SWITCH_SPEED
    ; read rLY right before it is incremented
    DELAY 125
    ld de, rLY   ; 3 m-cycles
    ld a, [de]   ; 2 m-cycles
    ld [hl+], a  ; 2 m-cycles
    ; read rLY right after it was incremented
    ld a, [de]   ; 2 m-cycles
    ld [hl+], a  ; 2 m-cycles
    ; read rLY right before it is incremented
    DELAY 456 / 2 - 5
    ld a, [de]   ; 2 m-cycles
    ld [hl+], a  ; 2 m-cycles
    ; read rLY right after it was incremented
    ld a, [de]   ; 2 m-cycles
    ld [hl+], a  ; 2 m-cycles
    ; read mode3/0 edges for different SCX values
    ld de, rSTAT ; 3 m-cycles
    SCX_TEST 0, 111, 456 / 2 - 3
    SCX_TEST 1, 219, 456 / 2 - 3
    SCX_TEST 2, 218, 456 / 2 - 3
    SCX_TEST 3, 219, 456 / 2 - 3
    SCX_TEST 4, 218, 456 / 2 - 3
    SCX_TEST 5, 219, 456 / 2 - 3
    SCX_TEST 6, 218, 456 / 2 - 3
    SCX_TEST 7, 219, 456 / 2 - 3
    SCX_TEST 8, 214, 456 / 2 - 3
    SCX_TEST 9, 219, 456 / 2 - 3


    ; switch to single speed
    ; TODO try this on different 2Mhz edges
    SWITCH_SPEED
    ; read rLY right before and right after it is incremented
    DELAY 98
    ld de, rLY   ; 3 m-cycles
    ld a, [de]   ; 2 m-cycles
    ld [hl+], a  ; 2 m-cycles
    ld a, [de]   ; 2 m-cycles
    ld [hl+], a  ; 2 m-cycles
    ; read rLY right before and right after it is incremented
    DELAY 456 / 4 - 5
    ld a, [de]   ; 2 m-cycles
    ld [hl+], a  ; 2 m-cycles
    ld a, [de]   ; 2 m-cycles
    ld [hl+], a  ; 2 m-cycles
    ; read mode3/0 edges for different SCX values
    ld de, rSTAT ; 3 m-cycles
    SCX_TEST 0,  47, 456 / 4 - 3
    SCX_TEST 1, 105, 456 / 4 - 3
    SCX_TEST 2, 104, 456 / 4 - 3
    SCX_TEST 3, 104, 456 / 4 - 3
    SCX_TEST 4, 104, 456 / 4 - 3
    SCX_TEST 5, 105, 456 / 4 - 3
    SCX_TEST 6, 104, 456 / 4 - 3
    SCX_TEST 7, 104, 456 / 4 - 3
    SCX_TEST 8, 102, 456 / 4 - 3
    SCX_TEST 9, 105, 456 / 4 - 3


    ld hl, EXPECTED_TEST_RESULTS
    ret
