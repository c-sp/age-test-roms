; Test OAM write access
;
; Verified (DMG_C undefined):
;    fails on CPU CGB E - CPU-CGB-06 (2021-07-08) (single speed passes)
;    fails on CPU CGB B - CPU-CGB-02 (2021-07-08) (single speed passes)
;    fails on DMG-CPU C (blob) - DMG-CPU-08 (2021-07-08)
;
; Verified (DMG_C set):
;    fails on CPU CGB E - CPU-CGB-06 (2021-07-08)
;    fails on CPU CGB B - CPU-CGB-02 (2021-07-08)
;   passes on DMG-CPU C (blob) - DMG-CPU-08 (2021-07-08)
;
;
IF DEF(DMG_C)
    DEF ROM_IS_CGB_COMPATIBLE EQU 1
    DEF C81 EQU $81
    DEF C00 EQU $00
ELSE
    DEF ROM_IS_CGB_COMPATIBLE EQU 1
    DEF C81 EQU $00
    DEF C00 EQU $81
ENDC

INCLUDE "lcd/write-timing.inc"



EXPECTED_TEST_RESULTS_DMG:
    DB 8
    DB $FF, $FF, $FF, $FF, $FF, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $FF, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $FF, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $FF, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $FF, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $FF, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $FF, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $FF, $00, $00, $00

EXPECTED_TEST_RESULTS_CGB:
    DB 16
    ; single speed
    DB $FF, $FF, $FF, $FF, $FF, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $FF, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $FF, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $FF, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $FF, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $FF, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $FF, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $FF, $00, $00, $00
    ; double speed
    DB $FF, $FF, $FF, $FF, $FF, $FF, $FF, $00
    DB $FF, $FF, $FF, $FF, $FF, $FF, $FF, $00
    DB $FF, $FF, $FF, $FF, $FF, $FF, $FF, $00
    DB $FF, $FF, $FF, $FF, $FF, $FF, $FF, $00
    DB $FF, $FF, $FF, $FF, $FF, $FF, $FF, $00
    DB $FF, $FF, $FF, $FF, $FF, $FF, $FF, $00
    DB $FF, $FF, $FF, $FF, $FF, $FF, $FF, $00
    DB $FF, $FF, $FF, $FF, $FF, $FF, $FF, $00

EXPECTED_TIMING_RESULTS:
    ;
    ; single speed
    ;
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00 ; SCX 0
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00
    DB C81, C00, $00, C00, $00, C00,  $00, C00, C81, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00 ; SCX 1
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00
    DB C81, C00, $00, $81, $00, $81,  $00, $81, C81, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00 ; SCX 2
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00
    DB C81, $00, $00, $81, $00, $81,  $00, $81, C81, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00 ; SCX 3
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00
    DB C81, $00, $00, $81, $00, $81,  $00, $81, C81, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00 ; SCX 4
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00
    DB C81, $00, $00, C81, $00, C81,  $00, C81, C81, $00
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00 ; SCX 5
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00
    DB C81, $00, $00, C81, $00, C81,  $00, C81, C81, $00
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00 ; SCX 6
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00
    DB C81, $00, $00, C81, $00, C81,  $00, C81, C81, $00
    DB $00, $00, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00 ; SCX 7
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00
    DB C81, $00, $00, C81, $00, C81,  $00, C81, C81, $00
    DB $00, $00, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    ;
    ; double speed
    ;
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00 ; SCX 0
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00 ; SCX 1
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00
    DB $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00 ; SCX 2
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00
    DB $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00 ; SCX 3
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00
    DB $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00
    DB $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00 ; SCX 4
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00
    DB $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00
    DB $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00 ; SCX 5
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00
    DB $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00
    DB $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00
    DB $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00 ; SCX 6
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00
    DB $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00
    DB $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00
    DB $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00 ; SCX 7
    DB $81, $00, $81, $00, $81, $00,  $81, $00, $81, $00
    DB $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00
    DB $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00
    DB $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00
    DB $00, $00, $00, $00, $00, $00,  $00, $00, $00, $00
    DB $00, $81, $00, $81, $00, $81,  $00, $81, $00, $81



timed_writes:
    ; write on the edge of line 0 mode 3
    DELAY 10
    ld [hl+], a ; 2 m-cycles
    ; write on the edge of line 0 mode 0
    DELAY 172 / 4 - 2
    ld [hl+], a

    ; write on the edge of line 1 mode 2
    DELAY 48
    ld [hl+], a
    ; write on the edge of line 1 mode 0
    DELAY (4 + 80 + 172) / 4 - 2
    ld [hl+], a

    ; write on the edge of line 143 mode 2
    DELAY 48 + (141 * 456) / 4
    ld [hl+], a
    ; write on the edge of line 143 mode 0
    DELAY (4 + 80 + 172) / 4 - 2
    ld [hl+], a

    ; write on the edge of line 154 mode 2 (line 0 next frame)
    DELAY 48 + (10 * 456) / 4
    ld [hl+], a
    ; write on the edge of line 154 mode 0 (line 0 next frame)
    DELAY (4 + 80 + 172) / 4 - 2
    ld [hl+], a

    ; write on the edge of line 155 mode 2 (line 1 next frame)
    DELAY 48
    ld [hl+], a
    ; write on the edge of line 155 mode 0 (line 1 next frame)
    DELAY (4 + 80 + 172) / 4 - 2
    ld [hl+], a
    ret

timed_writes_ds:
    ; write on the edge of line 0 mode 3
    DELAY 32
    ld [hl+], a       ; 2 m-cycles
    ; write on the edge of line 0 mode 0
    DELAY 172 / 2 - 2 ; 84 m-cycles
    ld [hl+], a       ; 2 m-cycles

    ; write on the edge of line 1 mode 2
    DELAY 99
    ld [hl+], a
    ; write on the edge of line 1 mode 0
    DELAY (80 + 172) / 2 - 2
    ld [hl+], a

    ; write on the edge of line 143 mode 2
    DELAY 100 + (141 * 456) / 2
    ld [hl+], a
    ; write on the edge of line 143 mode 0
    DELAY (80 + 172) / 2 - 2
    ld [hl+], a

    ; write on the edge of line 154 mode 2 (line 0 next frame)
    DELAY 100 + (10 * 456) / 2
    ld [hl+], a
    ; write on the edge of line 154 mode 0 (line 0 next frame)
    DELAY (80 + 172) / 2 - 2
    ld [hl+], a

    ; write on the edge of line 155 mode 2 (line 1 next frame)
    DELAY 100
    ld [hl+], a
    ; write on the edge of line 155 mode 0 (line 1 next frame)
    DELAY (80 + 172) / 2 - 2
    ld [hl+], a
    ret

run_test:
    RUN_TEST _OAMRAM
