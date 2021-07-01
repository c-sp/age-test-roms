; Test LY timing
;
; Verified (CGB_E undefined):
;    fails on CPU CGB E - CPU-CGB-06 (2021-07-01)
;   passes on CPU CGB B - CPU-CGB-02 (2021-07-01)
;   passes on DMG-CPU C (blob) - DMG-CPU-08 (2021-07-01)
;
; Verified (CGB_E set):
;   passes on CPU CGB E - CPU-CGB-06 (2021-07-01)
;    fails on CPU CGB B - CPU-CGB-02 (2021-07-01)
;    fails on DMG-CPU C (blob) - DMG-CPU-08 (2021-07-01)
;
IF DEF(CGB_E)
    DEF ROM_IS_CGB_ONLY EQU 1
    DEF L99 EQU $99
ELSE
    DEF ROM_IS_CGB_COMPATIBLE EQU 1
    DEF L99 EQU $00
ENDC

INCLUDE "test-setup.inc"



EXPECTED_TEST_RESULTS_DMG:
    DB 4
    DB $00, $00, $01, $02, $8F, $98, $00, $00
    DB $00, $01, $02, $03, $90, $99, $00, $01
    DB $00, $01, $02, $03, $90, $00, $00, $01
    DB $00, $01, $02, $03, $90, $00, $00, $01

EXPECTED_TEST_RESULTS_CGB:
    DB 9
    ; single speed
    DB $00, $00, $01, $02, $8F, $98, $00, $00
    DB $00, $01, $02, $03, $90, $99, $00, $01
    DB $00, $01, $02, $03, $90, L99, $00, $01
    DB $00, $01, $02, $03, $90, $00, $00, $01
    ; double speed
    DB $00, $00, $01, $02, $8F, $98, $00, $00
    DB $00, $01, $02, $03, $90, $99, $00, $01
    DB $00, $01, $02, $03, $90, $99, $00, $01
    DB $00, $01, $02, $03, $90, $99, $00, $01
    DB $00, $01, $02, $03, $90, $00, $00, $01



timed_ly_reads:
    ; read within scanline 0
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
    DELAY (456 / 4) - 4 + (456 / 4) * 140
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
    DELAY (456 / 2) - 4 + (456 / 2) * 140
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
    call lcd_off
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
