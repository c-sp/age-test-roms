IF !DEF(INC_M3_BG_SCX)
INC_M3_BG_SCX = 1

DEF CART_IS_VISUAL_TEST EQU 1
INCLUDE "test-setup.inc"
INCLUDE "vblank-frame-counter.inc"

run_test:
    call lcd_off
    call setup_palettes
    ; clear vram
    MEMSET _VRAM8000, 0, $2000
    ; fill tile 1 (LCDC.4=1) with the darkest shade
    MEMSET _VRAM8000 + $10, $FF, $10
    ; draw two vertical lines:
    ; one is visible right away,
    ; the other one may become visible by modifying SCX
    ld b, 18
    call .draw_vline
    ld b, 21
    call .draw_vline
    ; enable frame counter & mode 2 interrupt
    call activate_vblank_frame_counter
    ld a, STATF_MODE10
    ldh [rSTAT], a
    SET_IE_BIT IEF_STAT
    ; init mode 2 interrupt handler
    ld hl, no_op
    ld c, rLCDC - $FF00
    ; LCD on
IF DEF(DOUBLE_SPEED)
    SWITCH_SPEED
ENDC
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BG9800 | LCDCF_BG8000
    ldh [rLCDC], a
    jp nop_field

.draw_vline:
    ld h, _SCRN0 / $100
    ld l, b
    ld c, 18
.set_vline:
    ld a, 1
    ld [hl], a
    ld a, l
    add a, SCRN_VX_B
    ld l, a
    ld a, h
    adc a, 0
    ld h, a
    dec c
    jr nz, .set_vline
    ret



nop_field:
    ; 10 v-blank lines at double speed
    NOPS 456 * 10 / 2
    ; there should have been an interrupt until now
    di
    ld hl, .NO_INT
    jp fail_test
.NO_INT:
    DB "  V-BLANK OR MODE2\n"
    DB "     INTERRUPT\n"
    DB "   NOT TRIGGERED", 0



IF DEF(DOUBLE_SPEED)
    DEF NOP_COUNT EQU 90 ; TODO adjust delay
ELSE
    DEF NOP_COUNT EQU 28 ; TODO adjust delay
ENDC

PUSHS
SECTION "stat-interrupt-handler", ROM0[$48]
    jp hl ; 1 m-cycle
POPS

no_op:
    ldh a, [rLY]
    cp a, 31
    jp nz, continue
    ld hl, modify_scx
    jp continue

modify_scx:
    ldh a, [rLY]  ; 3 m-cycles
    ld b, a       ; 1 m-cycle
    sub a, 32     ; 2 m-cycles
    and a, 7      ; 2 m-cycles
    ldh [rSCX], a ; 3 m-cycles
    NOPS NOP_COUNT
    ld a, b
    sub a, 32     ; 2 m-cycles
    srl a         ; 2 m-cycles
    srl a         ; 2 m-cycles
    srl a         ; 2 m-cycles
    and a, 7      ; 2 m-cycles
    add a, 8      ; 2 m-cycles
    ldh [rSCX], a ; 3 m-cycles
    ld a, b
    cp a, 95
    jr nz, continue
    ld hl, no_op
    xor a, a
    ldh [rSCX], a
    jp continue

continue:
    pop af
    ei
    jp nop_field



ENDC ; !DEF(INC_M3_BG_SCX)
