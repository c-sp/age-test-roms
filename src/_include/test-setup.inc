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
;   CGB compatibility byte
;
; ----------------------------------------------------------------------------

SECTION "entry", ROM0[$100]
    di
    jp setup

SECTION "setup", ROM0[$150]
setup:
    xor a, a
    ld [TEST_RESULT_BYTES], a
    jp main ; must be defined by the code that is including this file



; ----------------------------------------------------------------------------
;
;   test result array
;
; ----------------------------------------------------------------------------

PUSHS
SECTION "test-result", WRAM0, ALIGN[6] ; align to 64 bytes for easier array handling
TEST_RESULT_BYTES: DB    ; the actual TEST_RESULT size
TEST_RESULT:       DS 32 ; allow up to 32 bytes to be stored as test result
POPS

; Load the address of the next test result byte into hl.
;
; @destroys af, hl
;
BEGIN_WRITE_RESULTS: MACRO
    ld hl, TEST_RESULT_BYTES
    ld a, [hl+]
    add a, l
    ld l, a
ENDM

; Update the index to the next test result byte from hl.
;
; @destroys af
;
END_WRITE_RESULTS: MACRO
    ld a, l
    dec a
    ld l, 0
    ld [hl], a
ENDM



; ----------------------------------------------------------------------------
;
;   test finished
;
; ----------------------------------------------------------------------------

FINISH_TEST: MACRO
    ld hl, \1
    jp finish_test
ENDM

finish_test:
    push hl
    LCD_OFF
    pop hl

    push hl
    call .compare_test_result
    pop hl
    push af

    call .print_test_result
    call .setup_font

    ld a, LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON
    ld [rLCDC], a

    pop af ; pop test failure indicator
    or a, a
    jp z, .test_passed
    jp .test_failed

.test_passed:
    ld b, 3
    ld c, 5
    ld d, 8
    ld e, 13
    ld h, 21
    ld l, 34
    ; indicate finished test
    ld b, b
    FREEZE

.test_failed:
    xor a, a
    ld b, a
    ld c, a
    ld d, a
    ld e, a
    ld h, a
    ld l, a
    ; indicate finished test
    ld b, b
    FREEZE



; Compare expected and actual test results.
;
; @param hl the expected test results
; @destroys af, bc, de, hl
; @returns a == 0 for a valid test result, a != 0 otherwise
;
.compare_test_result:
    ld a, [hl]
    cp a, 33
    ret nc ; invalid result: at most 32 bytes allowed
    inc a
    ld c, a ; c = number of bytes to compare
    ld de, TEST_RESULT_BYTES
.compare_byte:
    ld a, [hl+]
    ld b, a
    ld a, [de]
    inc de
    cp a, b
    jr nz, .invalid_result
    dec c
    jr nz, .compare_byte
    xor a, a ; result valid
    ret
.invalid_result:
    or a, 1 ; result invalid
    ret



; Print the expected and the actual test results.
;
; @param a test failure indicator
; @param hl address of the expected test results
; @destroys af, bc, de, hl
;
.print_test_result:
    push hl
    push af

    ; clear tile map at $9800
    CLEAR_MEMORY _SCRN0, 18 * 32

    ; print passed/failed heading
    pop af
    ld de, .TEST_PASSED
    or a, a
    jr z, .print_heading
    ld de, .TEST_FAILED
.print_heading:
    ld hl, _SCRN0 + 32
    call .print_ascii

    ; print actual results
    ld de, .RESULTS
    call .print_ascii
    ld de, TEST_RESULT_BYTES
    call .print_hex_array

    ; print expected results
    ld de, .EXPECTED
    call .print_ascii
    pop de
    call .print_hex_array
    ret

.TEST_PASSED:
    DB "    Test passed!\n\n", 0
.TEST_FAILED:
    DB "    Test failed!\n\n", 0
.RESULTS:
    DB "Results:\n\n", 0
.EXPECTED:
    DB "Expected:\n\n", 0

; Move hl to the next screen line.
;
; @destroys af
;
HL_NEWLINE: MACRO
    ld a, l
    and a, %11100000
    add a, 32 ; no "inc" as we need the carry flag
    ld l, a
    ld a, h
    adc a, 0
    ld h, a
ENDM

; Print a null-terminated ASCII string.
;
; @param de address of the ascii string to print
; @param hl destination address
; @destroys af, de, hl
;
.print_ascii:
    ld a, [de]
    or a, a
    ret z ; found null-terminator
    inc de
    cp a, "\n"
    jr nz, .print_char
    HL_NEWLINE
    jr .print_ascii
.print_char:
    ld [hl+], a
    jr .print_ascii

; Print a byte array as hex values.
; The array's first byte must contain the number of bytes remaining.
; At most 33 bytes are printed.
;
; @param de address of the byte array to print
; @param hl destination address
; @destroys af, de, hl
;
.print_hex_array:
    ld a, [de]
    cp a, 33
    jr c, .array_checked
    ld a, 32
.array_checked:
    inc a
    ld c, a
    ld b, 7
.print_byte:
    ld a, [de]
    push af
    srl a
    srl a
    srl a
    srl a
    call .hex_char
    ld [hl+], a
    pop af
    call .hex_char
    ld [hl+], a
    ld a, " "
    ld [hl+], a
    dec b
    jr nz, .print_loop
    HL_NEWLINE
    ld b, 7
.print_loop:
    inc de
    dec c
    jr nz, .print_byte
    HL_NEWLINE
    ld a, b
    cp a, 7
    ret z
    HL_NEWLINE
    ret

.hex_char:
    and a, $0F
    cp a, 10
    jr nc, .hex_letter
    add a, "0"
    ret
.hex_letter:
    add a, "A" - 10
    ret



; font based on the "small blocky font":
; https://opengameart.org/content/small-blocky-font
;
; original "small blocky font" created by Jerom:
; https://opengameart.org/users/jerom
;
.FONT_DATA_BEGIN:
    INCBIN "font_small.2bpp"
.FONT_DATA_END:

.setup_font:
    ; clear tile data for ASCII characters 0 - 31
    CLEAR_MEMORY _VRAM8000, 32 * 16
    ; copy tile data for ASCII characters 32 - 127
    COPY_MEMORY .FONT_DATA_BEGIN, _VRAM8000 + 32 * 16, .FONT_DATA_END - .FONT_DATA_BEGIN
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
