IF !DEF(INC_STAT_TIMING)
INC_STAT_TIMING = 1



; TODO rewrite this with less LCD on/off switching



_READ_LINES_STAT: MACRO
    STATIC_ASSERT (\2 == 4) || (\2 == 2)
    ld c, \1            ; 2 m-cycles
.loop\@:
    ldh a, [rSTAT]      ; 3 m-cycles
    ld [hl+], a         ; 2 m-cycles
    DELAY 456 / \2 - 10
    dec c               ; 1 m-cycle
    jp nz, .loop\@      ; 4 m-cycles for jump, 3 m-cycles else
    nop                 ; 1 m-cycle to make jp always use 4 m-cycles
ENDM

_READ_LINES_STAT_SPARSE: MACRO
    _READ_LINES_STAT 4, \1 ; read first 4 scanlines

    DELAY (138 * 456) / \1 - 2 ; skip 138 scanlines
    _READ_LINES_STAT 4, \1     ; read 4 scanlines (142 - 145)

    DELAY (6 * 456) / \1 - 2 ; skip 6 scanlines
    _READ_LINES_STAT  4, \1  ; read 4 scanlines (152 - 155, includes 2 scanlines of the next frame)
ENDM

DEF BYTES_PER_SCANLINE EQU 12

read_lines_stat:
    _READ_LINES_STAT_SPARSE 4
    ret

read_lines_stat_ds:
    _READ_LINES_STAT_SPARSE 2
    ret

PURGE _READ_LINES_STAT, _READ_LINES_STAT_SPARSE



_INIT_READ_LINE_STAT: MACRO
    LCD_OFF
    xor a, a
    ldh [rSTAT], a
    cpl
    ldh [rLYC], a
    ld a, \1
    ldh [rSCX], a
    ld a, LCDCF_ON | LCDCF_BGON
    ldh [rLCDC], a
ENDM

; @param \1 scx
; @param \2 initial delay (m-cycles)
;
READ_LINES_STAT: MACRO
    _INIT_READ_LINE_STAT \1
    DELAY \2
    call read_lines_stat
ENDM

; @param \1 scx
; @param \2 initial delay (m-cycles)
;
READ_LINES_STAT_DS: MACRO
    _INIT_READ_LINE_STAT \1
    DELAY \2
    call read_lines_stat_ds
ENDM



PUSHS
SECTION "scanline-stats", WRAM0
SCANLINE_STATS: DS 16 * 8 * BYTES_PER_SCANLINE
POPS

PREPRAE_RESULT_COMPARISON: MACRO
    ld hl, TEST_RESULTS
    ld bc, SCANLINE_STATS
    ld de, EXPECTED_SCANLINE_STATS
ENDM

; @param \1 number of scanline-stat-lines to put into one result line
; @param bc
; @param de
; @param hl
; @destroys af
;
COMPARE_RESULTS: MACRO
    STATIC_ASSERT (\1 > 0) && (\1 <= 8)

    FOR I, \1
        call compare_scanline
        ld [hl+], a
    ENDR
    REPT 8 - \1
        inc hl
    ENDR
ENDM

; @param bc address of the next scanline byte
; @param de address of the next expected scanline byte
;
; @return a index of first mismatch, $FF if all bytes are equal
; @return bc address of the next scanline byte
; @return de address of the next expected scanline byte
;
; @destroys f
;
compare_scanline:
    push hl
    ld l, BYTES_PER_SCANLINE
.compare_byte:
    ld a, [de]
    ld h, a
    ld a, [bc]
    cp a, h
    jr z, .next_byte
    ld a, BYTES_PER_SCANLINE
    sub l
.fast_forward:
    inc de
    inc bc
    dec l
    jr nz, .fast_forward
    jr .return
.next_byte:
    inc de
    inc bc
    dec l
    jr nz, .compare_byte
    ld a, $FF
.return:
    pop hl
    ret



ENDC
