; CGB_ONLY = 1
INCLUDE "test-setup.inc"

SECTION "main", ROMX
main:
    NOPS 10
    RESET_DIV

    ld de, .HELLO
    call print_ascii

    jp test_success

.HELLO:
    DB "    Hello World!", 0
