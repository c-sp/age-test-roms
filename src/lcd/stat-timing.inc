IF !DEF(INC_STAT_TIMING)
INC_STAT_TIMING = 1



_READ_LINES_STAT: MACRO
    STATIC_ASSERT (\2 == 4) || (\2 == 2)
    ld c, \1           ; 2 m-cycles
.loop\@:
    ldh a, [rSTAT]     ; 3 m-cycles
    ld [hl+], a        ; 2 m-cycles
    NOPS 456 / \2 - 10
    dec c              ; 1 m-cycle
    jp nz, .loop\@     ; 4 m-cycles for jump, 3 m-cycles else
    nop                ; 1 m-cycle to make jp always use 4 m-cycles
ENDM

_READ_LINES_STAT_SPARSE: MACRO
    _READ_LINES_STAT 4, \1 ; read first 4 scanlines

    NOPS (138 * 456) / \1 - 2 ; skip 138 scanlines
    _READ_LINES_STAT 4, \1    ; read 4 scanlines (142 - 145)

    NOPS (6 * 456) / \1 - 2 ; skip 6 scanlines
    _READ_LINES_STAT  4, \1 ; read 4 scanlines (152 - 155, includes 2 scanlines of the next frame)
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
; @param \2 initial nops
;
READ_LINES_STAT: MACRO
    _INIT_READ_LINE_STAT \1
    NOPS \2
    call read_lines_stat
ENDM

; @param \1 scx
; @param \2 initial nops
;
READ_LINES_STAT_DS: MACRO
    _INIT_READ_LINE_STAT \1
    NOPS \2
    call read_lines_stat_ds
ENDM



PUSHS
SECTION "scanline-stats", WRAM0
SCANLINE_STATS: DS 16 * 8 * BYTES_PER_SCANLINE
POPS

; @param \1 expected scanline bytes
; @param \2 number of scx tests
; @param \3 scanlines per scx test
; @destroys af, bc, de, hl
;
COMPARE_SCANLINE_RESULTS: MACRO
    STATIC_ASSERT (\2 > 0) && (\2 <= 16)
    STATIC_ASSERT (\3 > 0) && (\3 <= 8)

    ld hl, TEST_RESULTS
    ld bc, SCANLINE_STATS
    ld de, \1

    FOR S, \2
        FOR I, \3
            call compare_scanline
            ld [hl+], a
        ENDR
        REPT 8 - \3
            inc hl
        ENDR
    ENDR
ENDM

; @param bc scanline bytes
; @param de expected scanline bytes
; @return a index of first mismatch, $FF if all bytes are equal
; @destroys af, bc, de
;
compare_scanline:
    push hl
    ld l, BYTES_PER_SCANLINE
.compare_byte:
    ld a, [de]
    inc de
    ld h, a
    ld a, [bc]
    inc bc
    cp a, h
    jr z, .next_byte
    ld a, BYTES_PER_SCANLINE
    sub l
    pop hl
    ret
.next_byte:
    dec l
    jr nz, .compare_byte
    ld a, $FF
    pop hl
    ret



ENDC
