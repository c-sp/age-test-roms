IF !DEF(INC_SPSW_INTERRUPTS)
INC_SPSW_INTERRUPTS = 1

IF DEF(CGB_E)
    DEF OFS_B EQU 0
ELSE
    DEF OFS_B EQU 1
ENDC

INCLUDE "test-setup.inc"



EXPECTED_TEST_RESULTS:
    ; number of test result rows
    DB 10
    ; interrupt occurrence
    DB $3F, $00, $00, $00, $00, $00
    ; manual interrupts
    DB $00, $01, $00, $01, $00, $01, $00, $01, $00, $01
    ; results
    DB $00, $00, $00, $00, $00, $00, $00, $00
    DB $00, $00, $00, $00, $00, $00, $00, $00
    DB $00, $00, $00, $00, $00, $00, $00, $00
    DB $00, $00, $00, $00, $00, $00, $00, $00
    DB $00, $00, $00, $00, $00, $00, $00, $00
    DB $00, $00, $00, $00, $00, $00, $00, $00
    DB $00, $00, $00, $00, $00, $00, $00, $00
    DB $00, $00, $00, $00, $00, $00, $00, $00
    DB $00, $00, $00, $00, $00, $00, $00, $00

run_test:
    call lcd_off
    ld hl, TEST_RESULTS

    call test_interrupt_occurrence
    inc hl ; pad results
    inc hl
    inc hl
    inc hl
    inc hl
    call test_manual_interrupts

    TIMER_OFF
    ld hl, EXPECTED_TEST_RESULTS
    ret



PUSHS
SECTION "vblank-interrupt-handler", ROM0[$40]
    push de
    ret
SECTION "stat-interrupt-handler", ROM0[$48]
    push de
    ret
SECTION "timer-interrupt-handler", ROM0[$50]
    push de
    ret
SECTION "serial-interrupt-handler", ROM0[$58]
    push de
    ret
SECTION "joypad-interrupt-handler", ROM0[$60]
    push de
    ret
POPS

speed_switch_with_timer_interrupt:
    ; start 65 KHz timer
    ; (will overflow during during speed switch)
    TIMER_RESTART_CLEAN TACF_65KHZ
    ; enable timer interrupt
    xor a
    ldh [rIF], a
    ld a, IEF_TIMER
    ldh [rIE], a
    ei
    ; switch to double speed
    SWITCH_SPEED
    ; disable interrupts before returning
    ; (just to be sure)
    di
    ret



test_interrupt_occurrence:
    ld de, .timer_int
    jp speed_switch_with_timer_interrupt
.timer_int:
    ldh a, [rDIV]
    ld [hl+], a
    ret ; leave interrupts disabled



MACRO SPEED_SWITCH_MANUAL_INT
    ; prepare speed switch
    ld a, $30
    ldh [rP1], a
    ld a, 1
    ldh [rKEY1], a
    ; prepare interrupt
    ; (interrupts are disabled at the moment)
    ld a, \1
    ld [rIF], a
    ld [rIE], a
    ld de, .interrupt\@
    ; enable interrupts after speed switch
    ei
    stop
    ; disable interrupts (just to be sure)
    di
    jp .done\@
.interrupt\@:
    DELAY \2
    ldh a, [rDIV]
    ld [hl+], a
    ret ; leave interrupts disabled
.done\@:
ENDM

test_manual_interrupts:
    SPEED_SWITCH_MANUAL_INT %00000001, $30 + OFS_B
    SPEED_SWITCH_MANUAL_INT %00000001, $31 + OFS_B
    SPEED_SWITCH_MANUAL_INT %00000010, $30 + OFS_B
    SPEED_SWITCH_MANUAL_INT %00000010, $31 + OFS_B
    SPEED_SWITCH_MANUAL_INT %00000100, $30 + OFS_B
    SPEED_SWITCH_MANUAL_INT %00000100, $31 + OFS_B
    SPEED_SWITCH_MANUAL_INT %00001000, $30 + OFS_B
    SPEED_SWITCH_MANUAL_INT %00001000, $31 + OFS_B
    SPEED_SWITCH_MANUAL_INT %00010000, $30 + OFS_B
    SPEED_SWITCH_MANUAL_INT %00010000, $31 + OFS_B
    ret



ENDC ; INC_SPSW_INTERRUPTS
