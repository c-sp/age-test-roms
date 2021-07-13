IF !DEF(INC_READ_TIMING)
INC_READ_TIMING = 1

IF DEF(DOUBLE_SPEED)
    DEF ROM_IS_CGB_ONLY EQU 1
ELSE
    DEF ROM_IS_CGB_COMPATIBLE EQU 1
ENDC

INCLUDE "test-setup.inc"



OAM_DATA:
    ;   Y    X   Tile Flags
    DB $14, $08, $10, $00
    DB $14, $10, $10, $00
    DB $14, $18, $10, $00
    DB $14, $20, $10, $00
    DB $14, $28, $10, $00
    DB $14, $30, $10, $00
    DB $14, $38, $10, $00
    DB $14, $40, $10, $00
    DB $14, $48, $10, $00
    DB $14, $50, $10, $00
    ;   Y    X  Tile  Flags
    DB $1C, $58, $10, $00
    DB $1C, $60, $10, $00
    DB $1C, $68, $10, $00
    DB $1C, $70, $10, $00
    DB $1C, $78, $10, $00
    DB $1C, $80, $10, $00
    DB $1C, $88, $10, $00
    DB $1C, $90, $10, $00
    DB $1C, $98, $10, $00
    DB $1C, $A0, $10, $00
    ;   Y    X  Tile  Flags
    DB $2C, $08, $10, $00
    DB $2C, $10, $10, $00
    DB $2C, $18, $10, $00
    DB $2C, $20, $10, $00
    DB $2C, $28, $10, $00
    DB $2C, $30, $10, $00
    DB $2C, $38, $10, $00
    DB $2C, $40, $10, $00
    DB $2C, $48, $10, $00
    DB $2C, $50, $10, $00
    ;   Y    X  Tile  Flags
    DB $34, $58, $10, $00
    DB $34, $60, $10, $00
    DB $34, $68, $10, $00
    DB $34, $70, $10, $00
    DB $34, $78, $10, $00
    DB $34, $80, $10, $00
    DB $34, $88, $10, $00
    DB $34, $90, $10, $00
    DB $34, $98, $10, $00
    DB $34, $A0, $10, $00



PUSHS

SECTION "wram", WRAM0
FRAME_COUNTER: DS 1

SECTION "v-blank-interrupt-handler", ROM0[$40]
    jp vblank_handler

SECTION "lcd-interrupt-handler", ROM0[$48]
    jp hl ; 1 m-cycle

POPS

activate_interrupts:
    xor a, a
    ldh [rIF], a
    ld a, IEF_STAT | IEF_VBLANK
    ldh [rIE], a
    ld hl, obj_toggle_wait
    ld a, STATF_MODE10
    ldh [rSTAT], a
    ret

vblank_handler:
    call activate_interrupts
    ld a, [FRAME_COUNTER]
    or a, a
    jr z, .continue
    dec a
    ld [FRAME_COUNTER], a
    jr nz, .continue
    INDICATE_FINISHED_TEST
.continue:
    reti



obj_toggle_wait:
    ld a, [rLY]
    cp a, 3
    jp nz, continue_after_int
    ld hl, obj_toggle_1
    jp continue_after_int

MACRO WRITE_LCDC
    REPT \3
        ld a, \1   ; 1 m-cycle
        ldh [c], a ; 2 m-cycles
        ld a, \2   ; 1 m-cycle
        ldh [c], a ; 2 m-cycles
    ENDR
ENDM

obj_toggle_1:
    ; mode 2 takes 80 4MHz cycles:
    ;   - 20 m-cycles at single speed
    ;   - 40 m-cycles at double speed
    ;
    ; 5 m-cycles + 1 m-cycle until we're here
    ; m-cycle 6
    IF DEF(DOUBLE_SPEED)
        WRITE_LCDC d, e, 5
    ELSE
        WRITE_LCDC d, e, 2
    ENDC
    ; m-cycle 18 (single speed) / 36 (double speed)
    ld a, [rLY]
    cp a, 27
    jp c, continue_after_int
    ld hl, obj_toggle_2
    jp continue_after_int

obj_toggle_2:
    IF DEF(DOUBLE_SPEED)
        WRITE_LCDC e, d, 5
    ELSE
        WRITE_LCDC e, d, 2
    ENDC
    ld a, [rLY]
    cp a, 43
    jp c, continue_after_int
    ; disable mode 2 interupt and wait for v-blank interrupt
    xor a, a
    ld [rSTAT], a
    ei
.wait
    jr .wait

continue_after_int:
    pop af ; discard nop_field address
ei_nop_field:
    ei
nop_field:
    REPT 512
        nop
    ENDR
    ; TODO fail test immediately: no mode 2 interrupt triggered



MACRO RUN_TEST
    IF DEF(DOUBLE_SPEED)
        SWITCH_SPEED
    ENDC

    ; initialize OAM RAM
    call lcd_off
    MEMCPY _OAMRAM, OAM_DATA, OAM_COUNT * sizeof_OAM_ATTRS

    ; initialize frame counter
    ld a, 3
    ld [FRAME_COUNTER], a

    ; initialize CPU registers for rLCDC writing
    ld c, rLCDC & $FF
    ld d, LCDCF_ON | \1
    ld e, LCDCF_ON | \2

    ; activate v-blank & mode 2 interrupts
    call activate_interrupts

    ; switch on LCD and wait for interrupts
    ld a, LCDCF_ON
    ldh [rLCDC], a
    jp ei_nop_field
ENDM



ENDC
