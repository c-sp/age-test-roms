IF !DEF(INC_TEST_SETUP)
INC_TEST_SETUP = 1

INCLUDE "macros.inc"



; ----------------------------------------------------------------------------
;
;   CGB compatibility byte
;
; ----------------------------------------------------------------------------

IF DEF(ROM_IS_CGB_ONLY)
    SECTION "cgb-mode", ROM0[$143]
        DB $C0

ELIF DEF(ROM_IS_CGB_COMPATIBLE)
    SECTION "cgb-mode", ROM0[$143]
        DB $80

ELIF DEF(ROM_IS_DMG_ONLY)
    SECTION "cgb-mode", ROM0[$143]
        DB $00

ELSE
    FAIL "rom mode not specified: set one of ROM_IS_CGB_ONLY, ROM_IS_CGB_COMPATIBLE or ROM_IS_DMG_ONLY before including test-setup.inc"
ENDC



; ----------------------------------------------------------------------------
;
;   entry
;
; ----------------------------------------------------------------------------

SECTION "test-result", WRAM0
TEST_SUCCESS: DS 1
TEST_RESULTS: DS 256

SECTION "entry", ROM0[$100]
    di
    jp main

SECTION "main", ROM0[$150]
main:
    CLEAR_MEMORY TEST_RESULTS, 256
    call run_test ; must be defined by the code that is including this file



; ----------------------------------------------------------------------------
;
;   test finished
;
; ----------------------------------------------------------------------------

    LCD_OFF
    CLEAR_MEMORY _SCRN0, 18 * 32 ; clear tile map at $9800
    ld hl, TEST_SUCCESS
    ld [hl], 1
    call .print_results
    call .prepare_lcd
    ld a, [TEST_SUCCESS]
    or a, a
    jr z, .test_failed

.test_passed:
    ld b, 3
    ld c, 5
    ld d, 8
    ld e, 13
    ld h, 21
    ld l, 34
    ld b, b ; indicate finished test
    jr .freeze

.test_failed:
    ld b, 0
    ld b, b ; indicate finished test

.freeze:
    jr .freeze



; Print & compare test results
;
; @param hl address of the expected test results
; @destroys af, bc, de, hl
; @returns a=0 for a failed test, a=1 for a successful test
;
.print_results:
    ld bc, TEST_RESULTS
    ld de, EXPECTED_TEST_RESULTS
    ld hl, _SCRN0 + 2 * 32

    ld a, [de] ; number of rows (8 bytes per row)
    inc de
    dec a
    cp a, 16 ; we expect 1-16 rows
    jr c, .valid_number_of_rows
    ld hl, TEST_SUCCESS
    ld [hl], 0
    ret
.valid_number_of_rows:
    inc a
    push af
.next_row:
    call .print_row
    pop af
    dec a
    ret z ; all rows printed
    push af
    ld a, l
    and a, %11100000
    add a, 32
    ld l, a
    ld a, h
    adc a, 0
    ld h, a
    jr .next_row

.print_row:
    ld a, "0" - 32
    ld [hl+], a
    push bc
    ld a, c
    sub a, TEST_RESULTS & $FF
    ld b, 0 ; no font offset
    ld c, b ; no font offset
    call .print_byte
    pop bc
    xor a, a
    ld [hl+], a
.print_row_byte:
    ld a, [bc] ; next result byte
    inc bc
    push bc
    ld b, a
    ld a, [de] ; next expected result byte
    inc de
    cp a, b
    ld a, b ; a = current result byte
    jr z, .print_valid_byte

    push hl
    ld hl, TEST_SUCCESS
    ld [hl], 0
    pop hl

    ld b, 64  ; font-inverse
    ld c, 192 ; font-left-inverse
    call .print_byte
    jr .next_result_byte
.print_valid_byte:
    ld b, 0   ; font
    ld c, 128 ; font-left
    call .print_byte

.next_result_byte:
    pop bc
    ld a, l
    and a, %00011111
    cp a, 20
    jr c, .print_row_byte
    ret

.print_byte:
    push af
    push af
    swap a
    and a, $0F
    call .make_hex_char
    add a, b
    ld [hl+], a
    pop af
    and a, $0F
    call .make_hex_char
    add a, c
    ld [hl+], a
    pop af
    ret
.make_hex_char:
    cp a, 10
    jr nc, .hex_letter
    add a, "0" - 32
    ret
.hex_letter
    add a, "A" - 10 - 32
    ret



.prepare_lcd:
    ld de, .TEST_PASSED
    ld a, [TEST_SUCCESS]
    or a, a
    jr nz, .print_header
    ld de, .TEST_FAILED
.print_header:
    ld hl, _SCRN0 + 4
    call .print_ascii
    call .setup_font
    xor a, a
    ld [rSCX], a
    ld a, LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON
    ld [rLCDC], a
    ret

.TEST_PASSED:
    DB "TEST PASSED!", 0
.TEST_FAILED:
    DB "TEST FAILED!", 0

.print_ascii:
    ld a, [de]
    or a, a
    ret z ; null-terminator found
    inc de
    cp a, "\n"
    jr nz, .print_char1
    ; print newline
    ld a, l
    and a, %11100000
    add a, 32
    ld l, a
    ld a, h
    adc a, 0
    ld h, a
    jr .print_ascii
.print_char1:
    sub a, 32
    cp a, 64
    jr c, .print_char2
    ld a, 1 ; replace invalid character by white space
.print_char2:
    ld [hl+], a
    jr .print_ascii

; We use the "Cellphone Font":
; https://opengameart.org/content/ascii-bitmap-font-cellphone
; that was created by domsson:
; https://opengameart.org/users/domsson
;
.FONT_DATA_BEGIN:
    INCBIN "font.2bpp"
    INCBIN "font-inverse.2bpp"
    INCBIN "font-left.2bpp"
    INCBIN "font-left-inverse.2bpp"
.FONT_DATA_END:

.setup_font:
    ; copy tile data for ASCII characters 32 - 95 in different styles
    COPY_MEMORY .FONT_DATA_BEGIN, _VRAM8000, .FONT_DATA_END - .FONT_DATA_BEGIN
    ; setup BGP
    ld a, %11100100
    ld [rBGP], a
    ; setup CGB background palette
    ld a, %10000000
    ld [rBCPS], a
    ld a, %11111111 ; r = g = b = %11111
    ld [rBCPD], a
    ld a, %01111111
    ld [rBCPD], a
    ld a, %10110101 ; r = g = b = %10101
    ld [rBCPD], a
    ld a, %01010110
    ld [rBCPD], a
    ld a, %01001010 ; r = g = b = %01010
    ld [rBCPD], a
    ld a, %00101001
    ld [rBCPD], a
    xor a, a        ; r = g = b = %00000
    ld [rBCPD], a
    ld [rBCPD], a
    ret



ENDC
