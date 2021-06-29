DEF ROM_IS_CGB_COMPATIBLE EQU 1
INCLUDE "test-setup.inc"
INCLUDE "lcd/stat-mode-timing.inc"



; Verified:
;    fails on CPU CGB E - CPU-CGB-06 (2021-06-28)
;   passes on CPU CGB B - CPU-CGB-02 (2021-06-28)
;   passes on DMG-CPU C (blob) - DMG-CPU-08 (2021-06-29)
EXPECTED_TEST_RESULTS:
    ; number of test result rows
    DB 14
    ; mode 0
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
    ; mode 1,2
    DB $FF, $FF, $FF, $00, $00, $00, $00, $00 ; SCX 0
    DB $FF, $FF, $FF, $00, $00, $00, $00, $00 ; SCX 4
    ; mode 3
    DB $FF, $FF, $00, $00, $00, $00, $00, $00 ; SCX 0
    DB $FF, $FF, $00, $00, $00, $00, $00, $00 ; SCX 4

; no mode-0 m-cycle at the end of mode-1 on CGB-E
IF DEF(CGB_E)
    DEF M1E EQU $81
ELSE
    DEF M1E EQU $80
ENDC

EXPECTED_SCANLINE_STATS:
    ; *includes scanlines of the next frame
    ;
    ; mode 0 beginning depends on SCX
    ; (and more, but this test is limited to SCX)
    ; -------------------------------------------
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
    ;
    ; mode 1,2 beginning does not depend on SCX
    ; -----------------------------------------
    ; scanlines 0-3         scanlines 142-145    scanlines 152-155*
    DB $80, $80, $80, $80,  $80, $80, $81, $81,  $81, $81, $80, $80 ; SCX 0
    DB $80, $80, $80, $80,  $80, $80, $81, $81,  $81, M1E, $80, $80
    DB $82, $82, $82, $82,  $82, $81, $81, $81,  $81, $82, $82, $82
    ; scanlines 0-3         scanlines 142-145    scanlines 152-155*
    DB $80, $80, $80, $80,  $80, $80, $81, $81,  $81, $81, $80, $80 ; SCX 7
    DB $80, $80, $80, $80,  $80, $80, $81, $81,  $81, M1E, $80, $80
    DB $82, $82, $82, $82,  $82, $81, $81, $81,  $81, $82, $82, $82
    ;
    ; mode 3 beginning does not depend on SCX
    ; ---------------------------------------
    ; scanlines 0-3         scanlines 142-145    scanlines 152-155*
    DB $80, $82, $82, $82,  $82, $82, $81, $81,  $81, $81, $82, $82 ; SCX 0
    DB $83, $83, $83, $83,  $83, $83, $81, $81,  $81, $81, $83, $83
    ; scanlines 0-3         scanlines 142-145    scanlines 152-155*
    DB $80, $82, $82, $82,  $82, $82, $81, $81,  $81, $81, $82, $82 ; SCX 7
    DB $83, $83, $83, $83,  $83, $83, $81, $81,  $81, $81, $83, $83

DEF M0_INITIAL_M_CYCLES  EQU ((80 + 172) / 4 - 12)
DEF M12_INITIAL_M_CYCLES EQU (456 / 4 - 13)
DEF M3_INITIAL_M_CYCLES  EQU (80 / 4 - 12)



run_test:
    ld hl, SCANLINE_STATS
    FOR SCX, 10
        READ_LINES_STAT SCX, M0_INITIAL_M_CYCLES
        READ_LINES_STAT SCX, M0_INITIAL_M_CYCLES + 1
        READ_LINES_STAT SCX, M0_INITIAL_M_CYCLES + 2
    ENDR

    READ_LINES_STAT 0, M12_INITIAL_M_CYCLES
    READ_LINES_STAT 0, M12_INITIAL_M_CYCLES + 1
    READ_LINES_STAT 0, M12_INITIAL_M_CYCLES + 2
    READ_LINES_STAT 7, M12_INITIAL_M_CYCLES
    READ_LINES_STAT 7, M12_INITIAL_M_CYCLES + 1
    READ_LINES_STAT 7, M12_INITIAL_M_CYCLES + 2

    READ_LINES_STAT 0, M3_INITIAL_M_CYCLES
    READ_LINES_STAT 0, M3_INITIAL_M_CYCLES + 1
    READ_LINES_STAT 7, M3_INITIAL_M_CYCLES
    READ_LINES_STAT 7, M3_INITIAL_M_CYCLES + 1

    PREPRAE_RESULT_COMPARISON
    FOR N, 12
        COMPARE_RESULTS 3
    ENDR
    COMPARE_RESULTS 2
    COMPARE_RESULTS 2

    ld hl, EXPECTED_TEST_RESULTS
    ret
