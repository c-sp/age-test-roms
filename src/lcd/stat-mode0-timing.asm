ROM_IS_CGB_COMPATIBLE = 1
INCLUDE "test-setup.inc"



; Verified:
;   passes on CPU CGB E - CPU-CGB-06 (2021-06-24)
;   passes on CPU CGB B - CPU-CGB-02 (2021-06-24)
;   passes on DMG-CPU A/B/C (2021-06-24) TODO what device exactly?
EXPECTED_TEST_RESULTS:
    ; number of test result rows
    DB 16
    ; SCX = 0
    DB $83, $83, $83, $81, $80, $80, $80, $81
    DB $80, $80, $80, $81, $80, $80, $80, $81
    ; SCX = 1
    DB $83, $83, $83, $81, $80, $80, $80, $81
    DB $80, $80, $80, $81, $80, $80, $80, $81
    ; SCX = 2
    DB $83, $83, $83, $81, $83, $80, $80, $81
    DB $80, $80, $80, $81, $80, $80, $80, $81
    ; SCX = 3
    DB $83, $83, $83, $81, $83, $80, $80, $81
    DB $80, $80, $80, $81, $80, $80, $80, $81
    ; SCX = 4
    DB $83, $83, $83, $81, $83, $83, $83, $81
    DB $80, $80, $80, $81, $80, $80, $80, $81
    ; SCX = 5
    DB $83, $83, $83, $81, $83, $83, $83, $81
    DB $80, $80, $80, $81, $80, $80, $80, $81
    ; SCX = 7
    DB $83, $83, $83, $81, $83, $83, $83, $81
    DB $83, $80, $80, $81, $80, $80, $80, $81
    ; SCX = 8
    DB $83, $83, $83, $81, $80, $80, $80, $81
    DB $80, $80, $80, $81, $80, $80, $80, $81



SUB_TEST: MACRO
    LCD_OFF
    ld a, LCDCF_ON | LCDCF_BGON
    ld [rLCDC], a

    ; align reads on scanline 0
    NOPS \1
    ld a, [rSTAT]
    ld [hl+], a

    NOPS (456 - 20) / 4 ; wait for scanline 1
    ld a, [rSTAT]
    ld [hl+], a

    NOPS (456 - 20) / 4 ; wait for scanline 2
    NOPS 141 * 456 / 4  ; wait for scanline 143
    ld a, [rSTAT]
    ld [hl+], a

    NOPS (456 - 20) / 4 ; wait for scanline 144
    ld a, [rSTAT]
    ld [hl+], a
ENDM

TEST_WITH_SCX: MACRO
    ld a, \1
    ld [rSCX], a
    SUB_TEST (80 + 172) / 4 - 4
    SUB_TEST (80 + 172) / 4 - 3
    SUB_TEST (80 + 172) / 4 - 2
    SUB_TEST (80 + 172) / 4 - 1
ENDM



run_test:
    ld hl, TEST_RESULTS
    xor a, a
    ld [rSTAT], a
    cpl
    ld [rLYC], a

    TEST_WITH_SCX 0
    TEST_WITH_SCX 1
    TEST_WITH_SCX 2
    TEST_WITH_SCX 3
    TEST_WITH_SCX 4
    TEST_WITH_SCX 5
    TEST_WITH_SCX 7
    TEST_WITH_SCX 8

    ret
