IF !DEF(INC_STAT_INT_TIMING)
INC_STAT_INT_TIMING = 1



PUSHS
SECTION "lcd-interrupt-handler", ROM0[$48]
lcd_stat_interupt_handler:
    ; just continue at hl,
    ; ignore interrupted nops & wait_for_stat_int caller
    add sp, 4
    jp hl
POPS

wait_for_stat_int:
    ldh [rSTAT], a
    xor a
    ld b, a
    ld c, a
.loop: ; should be interrupted
    dec c
    jr nz, .loop
    dec b
    jr nz, .loop
    ret

; @param \1 scx
; @param \2 nops before setting the rSTAT interrupt bit
; @param \3 the stat interrupt bit to set
; @param \4 nops before reading rSTAT after interrupt
;
TEST_STAT_INT: MACRO
    push hl
    ld hl, read_stat\@

    ld a, \1
    call reset_lcd
    NOPS \2
    ld a, \3
    call wait_for_stat_int

    ld a, $FF
    jp save_result\@
read_stat\@:
    NOPS \4
    ldh a, [rSTAT]
save_result\@:
    pop hl
    ld [hl+], a
ENDM



reset_lcd:
    LCD_OFF
    ldh [rSCX], a
    xor a, a
    ldh [rIF], a
    ldh [rSTAT], a
    cpl
    ldh [rLYC], a
    ld a, IEF_STAT
    ldh [rIE], a
    ld a, LCDCF_ON | LCDCF_BGON
    ldh [rLCDC], a
    ei
    ret



PAD_RESULTS: MACRO
    xor a
    REPT \1
        ld [hl+], a
    ENDR
ENDM



ENDC
