INCLUDE "src/tima/old-switch-speed-tima-0x.inc"

; Check the machine cycle after switching speeds
; on which the 65KHz TIMA is incremented.

main:
    RUN_TEST_DS $05, $05, TACF_65KHZ
    RUN_TEST_DS $05, $06, TACF_65KHZ

    RUN_TEST_DS $06, $05, TACF_65KHZ
    RUN_TEST_DS $06, $06, TACF_65KHZ

    RUN_TEST_SS $05, $05, TACF_65KHZ
    RUN_TEST_SS $05, $06, TACF_65KHZ

    RUN_TEST_SS $06, $05, TACF_65KHZ
    RUN_TEST_SS $06, $06, TACF_65KHZ

    FINISH_TEST .EXPECTED_RESULT_CGB_AB

; 2021-06-15 - verified on my Game Boy Color
; (CPU CGB A/B according to which.gb 0.3)
.EXPECTED_RESULT_CGB_AB:
    DB 8 + 8 + 8
    ;
    ;  switch to double speed
    ;  TIMA  NOPS1 NOPS2
    DB $01,  $05,  $05
    DB $02,  $05,  $06
    DB $02,  $06,  $05
    DB $03,  $06,  $06
    ;
    ;  switch to single speed
    ;  TIMA  NOPS1 NOPS2
    DB $01,  $05,  $05
    DB $02,  $05,  $06
    DB $02,  $06,  $05
    DB $03,  $06,  $06
