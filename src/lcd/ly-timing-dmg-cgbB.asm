DEF ROM_IS_CGB_COMPATIBLE EQU 1
INCLUDE "test-setup.inc"



; Verified:
;    fails on CPU CGB E - CPU-CGB-06 (2021-06-30)
;   passes on CPU CGB B - CPU-CGB-02 (2021-06-30)
;   passes on DMG-CPU C (blob) - DMG-CPU-08 (2021-06-30)
EXPECTED_TEST_RESULTS_DMG:
    DB 4
    DB $00, $00, $01, $02, $8E, $97, $98, $00
    DB $00, $01, $02, $03, $8F, $98, $99, $00
    DB $00, $01, $02, $03, $8F, $98, $00, $00
    DB $00, $01, $02, $03, $8F, $98, $00, $00

IF DEF(CGB_E)
    DEF L99 EQU $99
ELSE
    DEF L99 EQU $00
ENDC

EXPECTED_TEST_RESULTS_CGB:
    DB 9
    ; single speed
    DB $00, $00, $01, $02, $8E, $97, $98, $00
    DB $00, $01, $02, $03, $8F, $98, $99, $00
    DB $00, $01, $02, $03, $8F, $98, L99, $00
    DB $00, $01, $02, $03, $8F, $98, $00, $00
    ; double speed
    DB $00, $00, $01, $02, $8E, $97, $98, $00
    DB $00, $01, $02, $03, $8F, $98, $99, $00
    DB $00, $01, $02, $03, $8F, $98, $99, $00
    DB $00, $01, $02, $03, $8F, $98, $99, $00
    DB $00, $01, $02, $03, $8F, $98, $00, $00



timed_ly_reads:
    ; read within scanline 0
    ; (read rLY 8 m-cycles after the LCD was switched on)
    ld a, [de]  ; 2 m-cycles
    ld [hl+], a ; 2 m-cycles
    ; read on the edge of scanline 0/1
    DELAY (454 / 4) - 13
    ld a, [de]
    ld [hl+], a
    ; read on the edge of scanline 1/2
    DELAY (456 / 4) - 4
    ld a, [de]
    ld [hl+], a
    ; read on the edge of scanline 2/3
    DELAY (456 / 4) - 4
    ld a, [de]
    ld [hl+], a
    ; read on the edge of scanline 143/144
    DELAY (456 / 4) - 4 + (456 / 4) * 139
    ld a, [de]
    ld [hl+], a
    ; read on the edge of scanline 152/153
    DELAY (456 / 4) - 4 + (456 / 4) * 8
    ld a, [de]
    ld [hl+], a
    ; read on the edge of scanline 153/0
    DELAY (456 / 4) - 4
    ld a, [de]
    ld [hl+], a
    ; read on the edge of scanline 0/1
    DELAY (456 / 4) - 4
    ld a, [de]
    ld [hl+], a
    ret

timed_ly_reads_ds:
    ; read within scanline 0
    ; (read rLY 8 m-cycles after the LCD was switched on)
    ld a, [de]  ; 2 m-cycles
    ld [hl+], a ; 2 m-cycles
    ; read on the edge of scanline 0/1
    DELAY (454 / 2) - 14
    ld a, [de]
    ld [hl+], a
    ; read on the edge of scanline 1/2
    DELAY (456 / 2) - 4
    ld a, [de]
    ld [hl+], a
    ; read on the edge of scanline 2/3
    DELAY (456 / 2) - 4
    ld a, [de]
    ld [hl+], a
    ; read on the edge of scanline 143/144
    DELAY (456 / 2) - 4 + (456 / 2) * 139
    ld a, [de]
    ld [hl+], a
    ; read on the edge of scanline 152/153
    DELAY (456 / 2) - 4 + (456 / 2) * 8
    ld a, [de]
    ld [hl+], a
    ; read on the edge of scanline 153/0
    DELAY (456 / 2) - 4
    ld a, [de]
    ld [hl+], a
    ; read on the edge of scanline 0/1
    DELAY (456 / 2) - 4
    ld a, [de]
    ld [hl+], a
    ret

TEST: MACRO
    ld de, rLY
    LCD_OFF
    ld a, LCDCF_ON | LCDCF_BGON
    ldh [rLCDC], a
    DELAY \1
    call \2
ENDM



run_test:
    ld hl, TEST_RESULTS

    TEST 0, timed_ly_reads
    TEST 1, timed_ly_reads
    TEST 2, timed_ly_reads
    TEST 3, timed_ly_reads

    CP_IS_CGB
    jr z, .run_cgb_tests
    ld hl, EXPECTED_TEST_RESULTS_DMG
    ret

.run_cgb_tests:
    SWITCH_SPEED

    TEST 0, timed_ly_reads_ds
    TEST 1, timed_ly_reads_ds
    TEST 2, timed_ly_reads_ds
    TEST 3, timed_ly_reads_ds
    TEST 4, timed_ly_reads_ds

    SWITCH_SPEED
    ld hl, EXPECTED_TEST_RESULTS_CGB
    ret
