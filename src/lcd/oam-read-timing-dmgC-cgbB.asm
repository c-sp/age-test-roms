; Test LY timing
;
; Verified (CGB_E undefined):
;    fails on CPU CGB E - CPU-CGB-06 (2021-07-02)
;   passes on CPU CGB B - CPU-CGB-02 (2021-07-02) TODO double speed fails
;   passes on DMG-CPU C (blob) - DMG-CPU-08 (2021-07-02)
;
; Verified (CGB_E set):
;   passes on CPU CGB E - CPU-CGB-06 (2021-07-02) TODO double speed fails
;    fails on CPU CGB B - CPU-CGB-02 (2021-07-02)
;
IF DEF(CGB_E)
    DEF ROM_IS_CGB_ONLY EQU 1
    DEF EFF EQU $FF
ELSE
    DEF ROM_IS_CGB_COMPATIBLE EQU 1
    DEF EFF EQU $00
ENDC

INCLUDE "test-setup.inc"



EXPECTED_TEST_RESULTS_DMG:
    DB 8
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00

EXPECTED_TEST_RESULTS_CGB:
    DB 16
    ; single speed
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00
    ; double speed
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00
    DB $FF, $FF, $FF, $FF, $00, $00, $00, $00



EXPECTED_OAM_VALUES:
    ;
    ; single speed
    ;
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $00, $FF, $00, $FF, $00, $FF,  $00, $FF, $00, $FF ; SCX 0
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $00, $FF, $00, $FF, $00, $FF,  $00, $FF, $00, $FF ; SCX 1
    DB $FF, EFF, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $00, $FF, $00, $FF, $00, $FF,  $00, $FF, $00, $FF ; SCX 2
    DB $FF, $FF, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $00, $FF, $00, $FF, $00, $FF,  $00, $FF, $00, $FF ; SCX 3
    DB $FF, $FF, $FF, EFF, $FF, EFF,  $FF, EFF, $FF, EFF
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $00, $FF, $00, $FF, $00, $FF,  $00, $FF, $00, $FF ; SCX 4
    DB $FF, $FF, $FF, $FF, $FF, $FF,  $FF, $FF, $FF, $FF
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $00, $FF, $00, $FF, $00, $FF,  $00, $FF, $00, $FF ; SCX 5
    DB $FF, $FF, $FF, $FF, $FF, $FF,  $FF, $FF, $FF, $FF
    DB $FF, EFF, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $00, $FF, $00, $FF, $00, $FF,  $00, $FF, $00, $FF ; SCX 6
    DB $FF, $FF, $FF, $FF, $FF, $FF,  $FF, $FF, $FF, $FF
    DB $FF, $FF, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $00, $FF, $00, $FF, $00, $FF,  $00, $FF, $00, $FF ; SCX 7
    DB $FF, $FF, $FF, $FF, $FF, $FF,  $FF, $FF, $FF, $FF
    DB $FF, $FF, $FF, EFF, $FF, EFF,  $FF, EFF, $FF, EFF
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    ;
    ; double speed
    ;
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $00, $FF, $00, $FF, $00, $FF,  $00, $FF, $00, $FF ; SCX 0
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $00, $FF, $00, $FF, $00, $FF,  $00, $FF, $00, $FF ; SCX 1
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $00, $FF, $00, $FF, $00, $FF,  $00, $FF, $00, $FF ; SCX 2
    DB $FF, $FF, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $00, $FF, $00, $FF, $00, $FF,  $00, $FF, $00, $FF ; SCX 3
    DB $FF, $FF, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $00, $FF, $00, $FF, $00, $FF,  $00, $FF, $00, $FF ; SCX 4
    DB $FF, $FF, $FF, $FF, $FF, $FF,  $FF, $FF, $FF, $FF
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $00, $FF, $00, $FF, $00, $FF,  $00, $FF, $00, $FF ; SCX 5
    DB $FF, $FF, $FF, $FF, $FF, $FF,  $FF, $FF, $FF, $FF
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $00, $FF, $00, $FF, $00, $FF,  $00, $FF, $00, $FF ; SCX 6
    DB $FF, $FF, $FF, $FF, $FF, $FF,  $FF, $FF, $FF, $FF
    DB $FF, $FF, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    ; line 0, 1, 143                  line 0, 1 (next frame)
    DB $00, $FF, $00, $FF, $00, $FF,  $00, $FF, $00, $FF ; SCX 7
    DB $FF, $FF, $FF, $FF, $FF, $FF,  $FF, $FF, $FF, $FF
    DB $FF, $FF, $FF, $00, $FF, $00,  $FF, $00, $FF, $00
    DB $FF, $00, $FF, $00, $FF, $00,  $FF, $00, $FF, $00



timed_ly_reads:
    ; read at the edge of line 0 mode 3
    DELAY 11
    ld a, [de]  ; 2 m-cycles
    ld [hl+], a ; 2 m-cycles
    ; read at the edge of line 0 mode 0
    DELAY 172 / 4 - 4
    ld a, [de]
    ld [hl+], a

    ; read at the edge of line 1 mode 2
    DELAY 46
    ld a, [de]
    ld [hl+], a
    ; read at the edge of line 1 mode 0
    DELAY (4 + 80 + 172) / 4 - 4
    ld a, [de]
    ld [hl+], a

    ; read at the edge of line 143 mode 2
    DELAY 46 + (141 * 456) / 4
    ld a, [de]
    ld [hl+], a
    ; read at the edge of line 143 mode 0
    DELAY (4 + 80 + 172) / 4 - 4
    ld a, [de]
    ld [hl+], a

    ; read at the edge of line 154 mode 2 (line 0 next frame)
    DELAY 46 + (10 * 456) / 4
    ld a, [de]
    ld [hl+], a
    ; read at the edge of line 154 mode 0 (line 0 next frame)
    DELAY (4 + 80 + 172) / 4 - 4
    ld a, [de]
    ld [hl+], a

    ; read at the edge of line 155 mode 2 (line 1 next frame)
    DELAY 46
    ld a, [de]
    ld [hl+], a
    ; read at the edge of line 155 mode 0 (line 1 next frame)
    DELAY (4 + 80 + 172) / 4 - 4
    ld a, [de]
    ld [hl+], a
    ret

timed_ly_reads_ds:
    ; read at the edge of line 0 mode 3
    DELAY 30
    ld a, [de]  ; 2 m-cycles
    ld [hl+], a ; 2 m-cycles
    ; read at the edge of line 0 mode 0
    DELAY 172 / 2 - 4
    ld a, [de]
    ld [hl+], a

    ; read at the edge of line 1 mode 2
    DELAY 96
    ld a, [de]
    ld [hl+], a
    ; read at the edge of line 1 mode 0
    DELAY (4 + 80 + 172) / 2 - 4
    ld a, [de]
    ld [hl+], a

    ; read at the edge of line 143 mode 2
    DELAY 96 + (141 * 456) / 2
    ld a, [de]
    ld [hl+], a
    ; read at the edge of line 143 mode 0
    DELAY (4 + 80 + 172) / 2 - 4
    ld a, [de]
    ld [hl+], a

    ; read at the edge of line 154 mode 2 (line 0 next frame)
    DELAY 96 + (10 * 456) / 2
    ld a, [de]
    ld [hl+], a
    ; read at the edge of line 154 mode 0 (line 0 next frame)
    DELAY (4 + 80 + 172) / 2 - 4
    ld a, [de]
    ld [hl+], a

    ; read at the edge of line 155 mode 2 (line 1 next frame)
    DELAY 96
    ld a, [de]
    ld [hl+], a
    ; read at the edge of line 155 mode 0 (line 1 next frame)
    DELAY (4 + 80 + 172) / 2 - 4
    ld a, [de]
    ld [hl+], a
    ret



DEF BYTES_PER_LINE EQU 10

PUSHS
SECTION "oam-values", WRAM0
OAM_VALUES: DS 16 * 8 * BYTES_PER_LINE
POPS

TEST: MACRO
    call lcd_off
    ld a, \1
    ld [rSCX], a
    ld a, LCDCF_ON | LCDCF_BGON
    ldh [rLCDC], a
    DELAY \3
    call \2
ENDM

compact_test_results:
    ld bc, OAM_VALUES
    ld de, EXPECTED_OAM_VALUES
    ld hl, TEST_RESULTS
    COMPACT_RESULTS_LINES 16, 4, BYTES_PER_LINE
    ret



run_test:
    call lcd_off
    ld hl, OAM_VALUES
    ld de, _OAMRAM
    xor a, a
    ld [de], a

    FOR SCX, 8
        TEST SCX, timed_ly_reads, 0
        TEST SCX, timed_ly_reads, 1
        TEST SCX, timed_ly_reads, 2
        TEST SCX, timed_ly_reads, 3
    ENDR

    CP_IS_CGB
    jp z, .run_test_cgb
    call compact_test_results
    ld hl, EXPECTED_TEST_RESULTS_DMG
    ret
.run_test_cgb:
    SWITCH_SPEED

    FOR SCX, 8
        TEST SCX, timed_ly_reads_ds, 0
        TEST SCX, timed_ly_reads_ds, 1
        TEST SCX, timed_ly_reads_ds, 2
        TEST SCX, timed_ly_reads_ds, 3
    ENDR

    SWITCH_SPEED
    call compact_test_results
    ;MEMCPY TEST_RESULTS, OAM_VALUES + 0 * 4 * BYTES_PER_LINE, 16 * 8
    ld hl, EXPECTED_TEST_RESULTS_CGB
    ret
