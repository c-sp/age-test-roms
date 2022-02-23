IF !DEF(INC_STAT_MODE_SPRITES)
INC_STAT_MODE_SPRITES = 1

INCLUDE "test-setup.inc"

EXPECTED_RESULT_LINES:
IF DEF(DOUBLE_SPEED)
    ; NOPS + 0
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  0
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  1
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  2
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  3
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  4
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  5
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  6
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  7
    ; NOPS + 0
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  8
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  9
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 10
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 11
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 12
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 13
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 14
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 15

    ; NOPS + 1
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  0
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  1
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  2
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  3
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  4
    DB $A0, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  5
    DB $A0, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  6
    DB $A0, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  7
    ; NOPS + 1
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  8
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  9
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 10
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 11
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 12
    DB $A0, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 13
    DB $A0, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 14
    DB $A0, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 15

    ; NOPS + 2
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  0
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  1
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  2
    DB $A0, $A0, $A0, $A3, $A3, $A3, $A3, $A3 ; SPX  3
    DB $A0, $A0, $A0, $A3, $A3, $A3, $A3, $A3 ; SPX  4
    DB $A0, $A0, $A0, $A3, $A3, $A3, $A3, $A3 ; SPX  5
    DB $A0, $A0, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  6
    DB $A0, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  7
    ; NOPS + 2
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  8
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  9
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 10
    DB $A0, $A0, $A0, $A3, $A3, $A3, $A3, $A3 ; SPX 11
    DB $A0, $A0, $A0, $A3, $A3, $A3, $A3, $A3 ; SPX 12
    DB $A0, $A0, $A0, $A3, $A3, $A3, $A3, $A3 ; SPX 13
    DB $A0, $A0, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 14
    DB $A0, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 15

    ; NOPS + 3
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  0
    DB $A0, $A0, $A0, $A0, $A0, $A3, $A3, $A3 ; SPX  1
    DB $A0, $A0, $A0, $A0, $A0, $A3, $A3, $A3 ; SPX  2
    DB $A0, $A0, $A0, $A0, $A0, $A3, $A3, $A3 ; SPX  3
    DB $A0, $A0, $A0, $A0, $A3, $A3, $A3, $A3 ; SPX  4
    DB $A0, $A0, $A0, $A3, $A3, $A3, $A3, $A3 ; SPX  5
    DB $A0, $A0, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  6
    DB $A0, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  7
    ; NOPS + 3
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  8
    DB $A0, $A0, $A0, $A0, $A0, $A3, $A3, $A3 ; SPX  9
    DB $A0, $A0, $A0, $A0, $A0, $A3, $A3, $A3 ; SPX 10
    DB $A0, $A0, $A0, $A0, $A0, $A3, $A3, $A3 ; SPX 11
    DB $A0, $A0, $A0, $A0, $A3, $A3, $A3, $A3 ; SPX 12
    DB $A0, $A0, $A0, $A3, $A3, $A3, $A3, $A3 ; SPX 13
    DB $A0, $A0, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 14
    DB $A0, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 15

    ; NOPS + 4
    DB $A0, $A0, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  0
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A3 ; SPX  1
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A3, $A3 ; SPX  2
    DB $A0, $A0, $A0, $A0, $A0, $A3, $A3, $A3 ; SPX  3
    DB $A0, $A0, $A0, $A0, $A3, $A3, $A3, $A3 ; SPX  4
    DB $A0, $A0, $A0, $A3, $A3, $A3, $A3, $A3 ; SPX  5
    DB $A0, $A0, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  6
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A3 ; SPX  7
    ; NOPS + 4
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A3 ; SPX  8
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A3 ; SPX  9
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A3, $A3 ; SPX 10
    DB $A0, $A0, $A0, $A0, $A0, $A3, $A3, $A3 ; SPX 11
    DB $A0, $A0, $A0, $A0, $A3, $A3, $A3, $A3 ; SPX 12
    DB $A0, $A0, $A0, $A3, $A3, $A3, $A3, $A3 ; SPX 13
    DB $A0, $A0, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 14
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A3 ; SPX 15

    ; NOPS + 5
    DB $A0, $A0, $A0, $A0, $A3, $A3, $A3, $A3 ; SPX  0
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A3 ; SPX  1
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A3, $A3 ; SPX  2
    DB $A0, $A0, $A0, $A0, $A0, $A3, $A3, $A3 ; SPX  3
    DB $A0, $A0, $A0, $A0, $A3, $A3, $A3, $A3 ; SPX  4
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  5
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  6
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  7
    ; NOPS + 5
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  8
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A3 ; SPX  9
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A3, $A3 ; SPX 10
    DB $A0, $A0, $A0, $A0, $A0, $A3, $A3, $A3 ; SPX 11
    DB $A0, $A0, $A0, $A0, $A3, $A3, $A3, $A3 ; SPX 12
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 13
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 14
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 15

    ; NOPS + 6
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A3, $A3 ; SPX  0
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A3 ; SPX  1
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A3, $A3 ; SPX  2
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  3
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  4
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  5
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  6
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  7
    ; NOPS + 6
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  8
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A3 ; SPX  9
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A3, $A3 ; SPX 10
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 11
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 12
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 13
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 14
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 15

    ; NOPS + 7
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  0
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  1
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  2
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  3
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  4
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  5
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  6
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  7
    ; NOPS + 7
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  8
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  9
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 10
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 11
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 12
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 13
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 14
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 15
ELSE
    ; NOPS + 0
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  0
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  1
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  2
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  3
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  4
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  5
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  6
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  7
    ; NOPS + 0
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  8
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  9
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 10
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 11
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 12
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 13
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 14
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 15

    ; NOPS + 1
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  0
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  1
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  2
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  3
    DB $A0, $A0, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  4
    DB $A0, $A0, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  5
    DB $A0, $A0, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  6
    DB $A0, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  7
    ; NOPS + 1
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  8
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  9
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 10
    DB $A3, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 11
    DB $A0, $A0, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 14
    DB $A0, $A0, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 12
    DB $A0, $A0, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 15
    DB $A0, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 13

    ; NOPS + 2
    DB $A0, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  0
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A3, $A3 ; SPX  1
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A3, $A3 ; SPX  2
    DB $A0, $A0, $A0, $A0, $A0, $A3, $A3, $A3 ; SPX  3
    DB $A0, $A0, $A0, $A0, $A3, $A3, $A3, $A3 ; SPX  4
    DB $A0, $A0, $A0, $A3, $A3, $A3, $A3, $A3 ; SPX  5
    DB $A0, $A0, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  6
    DB $A0, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX  7
    ; NOPS + 2
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A3, $A3 ; SPX  8
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A3, $A3 ; SPX  9
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A3, $A3 ; SPX 10
    DB $A0, $A0, $A0, $A0, $A0, $A3, $A3, $A3 ; SPX 11
    DB $A0, $A0, $A0, $A0, $A3, $A3, $A3, $A3 ; SPX 12
    DB $A0, $A0, $A0, $A3, $A3, $A3, $A3, $A3 ; SPX 13
    DB $A0, $A0, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 14
    DB $A0, $A3, $A3, $A3, $A3, $A3, $A3, $A3 ; SPX 15

    ; NOPS + 3
    DB $A0, $A0, $A0, $A0, $A0, $A3, $A3, $A3 ; SPX  0
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A3 ; SPX  1
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A3, $A3 ; SPX  2
    DB $A0, $A0, $A0, $A0, $A0, $A3, $A3, $A3 ; SPX  3
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  4
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  5
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  6
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  7
    ; NOPS + 3
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  8
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A3 ; SPX  9
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A3, $A3 ; SPX 10
    DB $A0, $A0, $A0, $A0, $A0, $A3, $A3, $A3 ; SPX 11
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 12
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 13
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 14
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 15

    ; NOPS + 4
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  0
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  1
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  2
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  3
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  4
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  5
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  6
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  7
    ; NOPS + 4
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  8
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX  9
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 10
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 11
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 12
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 13
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 14
    DB $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0 ; SPX 15
ENDC

PUSHS
SECTION "line-stats", WRAM0
RESULT_LINES: DS 16 * 8 * 8
POPS

IF DEF(DOUBLE_SPEED)
    DEF INITIAL_DELAY EQU 108
    DEF NUM_NOPS      EQU 8
ELSE
    DEF INITIAL_DELAY EQU 43
    DEF NUM_NOPS      EQU 5
ENDC

EXPECTED_TEST_RESULTS:
    ; number of test result rows
    DB NUM_NOPS * 2
    ; compacted results
REPT NUM_NOPS * 2
    DB $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
ENDR



run_test:
    call lcd_off
IF DEF(DOUBLE_SPEED)
    SWITCH_SPEED
ENDC
    MEMCPY _OAMRAM, OAM_DATA, 16 * 4
    ld de, wait_for_first_line
    ld bc, read_stat
    ld hl, RESULT_LINES
    ld a, $FF
    ldh [rLYC], a
    xor a, a
    ldh [rIF], a
    ld a, STATF_MODE10
    ldh [rSTAT], a
    ld a, IEF_STAT
    ldh [rIE], a
    ei
    ld a, LCDCF_ON | LCDCF_OBJON
    ldh [rLCDC], a
nop_field:
    ; 11 lines at double speed
    NOPS 456 * 12 / 2
    ; there should have been an interrupt by now
    di
    ld hl, .NO_INT
    jp fail_test
.NO_INT:
    DB "  MODE2 INTERRUPT\n"
    DB "   NOT TRIGGERED", 0
 
OAM_DATA:
    ;   Y    X  tile  attributes
    DB $18, $00, $00, $00
    DB $20, $01, $00, $00
    DB $28, $02, $00, $00
    DB $30, $03, $00, $00
    DB $38, $04, $00, $00
    DB $40, $05, $00, $00
    DB $48, $06, $00, $00
    DB $50, $07, $00, $00
    ;   Y    X  tile  attributes
    DB $58, $08, $00, $00
    DB $60, $09, $00, $00
    DB $68, $0A, $00, $00
    DB $70, $0B, $00, $00
    DB $78, $0C, $00, $00
    DB $80, $0D, $00, $00
    DB $88, $0E, $00, $00
    DB $90, $0F, $00, $00



PUSHS
SECTION "stat-interrupt-handler", ROM0[$48]
    ldh a, [rLY]
    ldh [rSCX], a
    push de
    ret     ; jp de
POPS

wait_for_first_line:
    cp a, 7
    jp nz, next_m2_int
    push bc
    pop de ; continue with read_stat (minus NOPs)
    dec bc ; one more NOP on the next frame
    ld a, read_stat & $FF
    sub a, c
    cp a, NUM_NOPS + 1
    jp nc, finish_test
    jp next_m2_int

read_stat_nops:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
read_stat:
    NOPS INITIAL_DELAY
    ldh a, [rSTAT]
    ld [hl+], a
    ldh a, [rLY]
    cp a, 7 + 16 * 8
    jr nz, next_m2_int
    ld de, wait_for_first_line
next_m2_int:
    pop af
    ei
    jp nop_field

finish_test:
    pop af
    ld bc, RESULT_LINES
    ld de, EXPECTED_RESULT_LINES
    ld hl, TEST_RESULTS
    COMPACT_RESULTS_LINES NUM_NOPS * 2, 8, 8
    ld hl, EXPECTED_TEST_RESULTS
    ret



ENDC ; !DEF(INC_STAT_MODE_SPRITES)
