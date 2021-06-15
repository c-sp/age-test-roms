INCLUDE "src/tima/switch-speed-tima-0x.inc"

main:
    RUN_TEST_DS $6E + $7F, $F5, TACF_4KHZ
    RUN_TEST_DS $6E + $7F, $F6, TACF_4KHZ
    RUN_TEST_DS $6E + $80, $F5, TACF_4KHZ
    RUN_TEST_DS $6E + $80, $F6, TACF_4KHZ
    RUN_TEST_DS $6E + $81, $F5, TACF_4KHZ
    RUN_TEST_DS $6E + $81, $F6, TACF_4KHZ

    RUN_TEST_SS $6E + $7F, $F5, TACF_4KHZ
    RUN_TEST_SS $6E + $7F, $F6, TACF_4KHZ
    RUN_TEST_SS $6E + $80, $F5, TACF_4KHZ
    RUN_TEST_SS $6E + $80, $F6, TACF_4KHZ
    RUN_TEST_SS $6E + $81, $F5, TACF_4KHZ
    RUN_TEST_SS $6E + $81, $F6, TACF_4KHZ

    FINISH_TEST .EXPECTED_RESULT_CGB_AB

; 2021-06-15 - verified on my Game Boy Color
; (CPU CGB A/B according to which.gb 0.3)
.EXPECTED_RESULT_CGB_AB:
    DB 12 + 12 + 12
    ;
    ;  switch to double speed
    ;  TIMA  NOPS1 NOPS2
    DB $81,  $ED,  $F5
    DB $82,  $ED,  $F6
    DB $81,  $EE,  $F5
    DB $82,  $EE,  $F6
    DB $81,  $EF,  $F5
    DB $82,  $EF,  $F6
    ;
    ;  switch to single speed
    ;  TIMA  NOPS1 NOPS2
    DB $81,  $ED,  $F5
    DB $82,  $ED,  $F6
    DB $81,  $EE,  $F5
    DB $82,  $EE,  $F6
    DB $81,  $EF,  $F5
    DB $82,  $EF,  $F6
