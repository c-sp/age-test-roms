DEF ROM_IS_CGB_COMPATIBLE EQU 1
INCLUDE "test-setup.inc"
INCLUDE "lcd/stat-timing.inc"



; Verified:
;    fails on CPU CGB E - CPU-CGB-06 (2021-06-25)
;   passes on CPU CGB B - CPU-CGB-02 (2021-06-25)
;   passes on DMG CPU A/B/C TODO what device exactly?
EXPECTED_TEST_RESULTS:
    DB 2 ; number of test result rows
    DB $FF, $FF, $FF, $00, $00, $00, $00, $00 ; SCX 0
    DB $FF, $FF, $FF, $00, $00, $00, $00, $00 ; SCX 4

EXPECTED_SCANLINE_STATS:
    ; *includes scanlines of the next frame
    ;
    ; scanlines 0-3         scanlines 142-145    scanlines 152-155*
    DB $80, $80, $80, $80,  $80, $80, $81, $81,  $81, $81, $80, $80 ; SCX 0
    DB $80, $80, $80, $80,  $80, $80, $81, $81,  $81, $80, $80, $80
    DB $82, $82, $82, $82,  $82, $81, $81, $81,  $81, $82, $82, $82
    ; scanlines 0-3         scanlines 142-145    scanlines 152-155*
    DB $80, $80, $80, $80,  $80, $80, $81, $81,  $81, $81, $80, $80 ; SCX 4
    DB $80, $80, $80, $80,  $80, $80, $81, $81,  $81, $80, $80, $80
    DB $82, $82, $82, $82,  $82, $81, $81, $81,  $81, $82, $82, $82

DEF SCX_COUNT     EQU 2
DEF TESTS_PER_SCX EQU 3

DEF INITIAL_NOPS  EQU 456 / 4 - 13



run_test:
    ld hl, SCANLINE_STATS

    FOR I, TESTS_PER_SCX
        READ_LINES_STAT 0, INITIAL_NOPS + I
    ENDR
    FOR I, TESTS_PER_SCX
        READ_LINES_STAT 4, INITIAL_NOPS + I
    ENDR

    COMPARE_SCANLINE_RESULTS EXPECTED_SCANLINE_STATS, SCX_COUNT, TESTS_PER_SCX
    ret
