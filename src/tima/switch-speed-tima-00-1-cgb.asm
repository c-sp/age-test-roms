INCLUDE "src/tima/switch-speed-tima-0x.inc"

; Check the machine cycle after switching speeds
; on which the 4KHz TIMA is incremented.

main:
    RUN_TEST_DS $6E, $F5, TACF_4KHZ
    RUN_TEST_DS $6E, $F6, TACF_4KHZ

    RUN_TEST_DS $6F, $F5, TACF_4KHZ
    RUN_TEST_DS $6F, $F6, TACF_4KHZ

    RUN_TEST_SS $6E, $F5, TACF_4KHZ
    RUN_TEST_SS $6E, $F6, TACF_4KHZ

    RUN_TEST_SS $6F, $F5, TACF_4KHZ
    RUN_TEST_SS $6F, $F6, TACF_4KHZ

    FINISH_TEST .EXPECTED_RESULT_CGB_AB

; 2021-06-15 - verified on my Game Boy Color
; (CPU CGB A/B according to which.gb 0.3)
.EXPECTED_RESULT_CGB_AB:
    DB 8 + 8 + 8
    ;
    ;  switch to double speed
    ;  TIMA  NOPS1 NOPS2
    DB $80,  $6E,  $F5
    DB $81,  $6E,  $F6
    DB $81,  $6F,  $F5
    DB $82,  $6F,  $F6
    ;
    ;  switch to single speed
    ;  TIMA  NOPS1 NOPS2
    DB $80,  $6E,  $F5
    DB $81,  $6E,  $F6
    DB $81,  $6F,  $F5
    DB $82,  $6F,  $F6
