; TODO examine OP code prefetch timing (for the instruction after STOP on speed switch)
;
INCLUDE "hardware.inc"
DEF CART_COMPATIBILITY EQU CART_COMPATIBLE_GBC
INCLUDE "test-setup.inc"

run_test:
    ret