; Verified:
;   2022-02-11 pass: CPU CGB E - CPU-CGB-06
;   2022-02-11 pass: CPU CGB B - CPU-CGB-02
;
INCLUDE "hardware.inc"
DEF CART_COMPATIBILITY EQU CART_COMPATIBLE_GBC
INCLUDE "test-setup.inc"

EXPECTED_TEST_RESULTS:
    ; number of test result rows
    DB 1
    ; result
    DB $00, $80
    ; result padding
    DB $00, $00, $00, $00, $00, $00

run_test:
    ; clear all interrupt flags
    xor a
    ldh [rIF], a
    ldh [rIE], a
    ; prepare speed switch
	ld a, $30
    ldh [rP1], a
    ld a, 1
    ldh [rKEY1], a
    ld a, $c9
    ldh [rTMA], a
    ld b, $33
    ; start 4 KHz timer
    TIMER_RESTART_CLEAN TACF_4KHZ
    ; wait for div == $10
     DELAY 64 * $10
    ; set tima = 0
    xor a
    ldh [rTIMA], a
    ; switch CPU speed:
    ;    [div] $10        stop
    ;   [tima] $00 / $80  nop / add b
    ;    [tma] $c9        ret
    call rDIV
    ; save test result
    ld hl, TEST_RESULTS
    ld [hl+], a
    ldh a, [rTIMA]
    ld [hl+], a
    ; back to normal speed
    SWITCH_SPEED

    ld hl, EXPECTED_TEST_RESULTS
    ret
