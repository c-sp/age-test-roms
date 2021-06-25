DEF ROM_IS_CGB_COMPATIBLE EQU 1
INCLUDE "test-setup.inc"
INCLUDE "lcd/stat-timing.inc"



; Verified:
;   passes on CPU CGB E - CPU-CGB-06 (2021-06-25)
;   passes on CPU CGB B - CPU-CGB-02 (2021-06-25)
;   passes on DMG CPU A/B/C TODO what device exactly?
EXPECTED_TEST_RESULTS:
    DB 10 ; number of test result rows

    DB $FF, $FF, $FF, $00, $00, $00, $00, $00 ; SCX 0
    DB $FF, $FF, $FF, $00, $00, $00, $00, $00 ; SCX 1
    DB $FF, $FF, $FF, $00, $00, $00, $00, $00 ; SCX 2
    DB $FF, $FF, $FF, $00, $00, $00, $00, $00 ; SCX 3

    DB $FF, $FF, $FF, $00, $00, $00, $00, $00 ; SCX 4
    DB $FF, $FF, $FF, $00, $00, $00, $00, $00 ; SCX 5
    DB $FF, $FF, $FF, $00, $00, $00, $00, $00 ; SCX 6
    DB $FF, $FF, $FF, $00, $00, $00, $00, $00 ; SCX 7

    DB $FF, $FF, $FF, $00, $00, $00, $00, $00 ; SCX 8
    DB $FF, $FF, $FF, $00, $00, $00, $00, $00 ; SCX 9

EXPECTED_SCANLINE_STATS:
    ; *includes scanlines of the next frame
    ;
    ; scanlines 0-3         scanlines 142-145    scanlines 152-155*
    DB $83, $83, $83, $83,  $83, $83, $81, $81,  $81, $81, $83, $83 ; SCX 0
    DB $80, $80, $80, $80,  $80, $80, $81, $81,  $81, $81, $80, $80
    DB $80, $80, $80, $80,  $80, $80, $81, $81,  $81, $81, $80, $80
    ; scanlines 0-3         scanlines 142-145    scanlines 152-155*
    DB $83, $83, $83, $83,  $83, $83, $81, $81,  $81, $81, $83, $83 ; SCX 1
    DB $80, $80, $80, $80,  $80, $80, $81, $81,  $81, $81, $80, $80
    DB $80, $80, $80, $80,  $80, $80, $81, $81,  $81, $81, $80, $80
    ; scanlines 0-3         scanlines 142-145    scanlines 152-155*
    DB $83, $83, $83, $83,  $83, $83, $81, $81,  $81, $81, $83, $83 ; SCX 2
    DB $83, $80, $80, $80,  $80, $80, $81, $81,  $81, $81, $80, $80
    DB $80, $80, $80, $80,  $80, $80, $81, $81,  $81, $81, $80, $80
    ; scanlines 0-3         scanlines 142-145    scanlines 152-155*
    DB $83, $83, $83, $83,  $83, $83, $81, $81,  $81, $81, $83, $83 ; SCX 3
    DB $83, $80, $80, $80,  $80, $80, $81, $81,  $81, $81, $80, $80
    DB $80, $80, $80, $80,  $80, $80, $81, $81,  $81, $81, $80, $80
    ; scanlines 0-3         scanlines 142-145    scanlines 152-155*
    DB $83, $83, $83, $83,  $83, $83, $81, $81,  $81, $81, $83, $83 ; SCX 4
    DB $83, $83, $83, $83,  $83, $83, $81, $81,  $81, $81, $83, $83
    DB $80, $80, $80, $80,  $80, $80, $81, $81,  $81, $81, $80, $80
    ; scanlines 0-3         scanlines 142-145    scanlines 152-155*
    DB $83, $83, $83, $83,  $83, $83, $81, $81,  $81, $81, $83, $83 ; SCX 5
    DB $83, $83, $83, $83,  $83, $83, $81, $81,  $81, $81, $83, $83
    DB $80, $80, $80, $80,  $80, $80, $81, $81,  $81, $81, $80, $80
    ; scanlines 0-3         scanlines 142-145    scanlines 152-155*
    DB $83, $83, $83, $83,  $83, $83, $81, $81,  $81, $81, $83, $83 ; SCX 6
    DB $83, $83, $83, $83,  $83, $83, $81, $81,  $81, $81, $83, $83
    DB $83, $80, $80, $80,  $80, $80, $81, $81,  $81, $81, $80, $80
    ; scanlines 0-3         scanlines 142-145    scanlines 152-155*
    DB $83, $83, $83, $83,  $83, $83, $81, $81,  $81, $81, $83, $83 ; SCX 7
    DB $83, $83, $83, $83,  $83, $83, $81, $81,  $81, $81, $83, $83
    DB $83, $80, $80, $80,  $80, $80, $81, $81,  $81, $81, $80, $80
    ; scanlines 0-3         scanlines 142-145    scanlines 152-155*
    DB $83, $83, $83, $83,  $83, $83, $81, $81,  $81, $81, $83, $83 ; SCX 8
    DB $80, $80, $80, $80,  $80, $80, $81, $81,  $81, $81, $80, $80
    DB $80, $80, $80, $80,  $80, $80, $81, $81,  $81, $81, $80, $80
    ; scanlines 0-3         scanlines 142-145    scanlines 152-155*
    DB $83, $83, $83, $83,  $83, $83, $81, $81,  $81, $81, $83, $83 ; SCX 9
    DB $80, $80, $80, $80,  $80, $80, $81, $81,  $81, $81, $80, $80
    DB $80, $80, $80, $80,  $80, $80, $81, $81,  $81, $81, $80, $80

DEF SCX_COUNT     EQU 10
DEF TESTS_PER_SCX EQU 3

DEF INITIAL_NOPS  EQU (80 + 172) / 4 - 12



run_test:
    ld hl, SCANLINE_STATS
    FOR S, SCX_COUNT
        FOR I, TESTS_PER_SCX
            READ_LINES_STAT S, INITIAL_NOPS + I
        ENDR
    ENDR

    COMPARE_SCANLINE_RESULTS EXPECTED_SCANLINE_STATS, SCX_COUNT, TESTS_PER_SCX
    ret
