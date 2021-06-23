INCLUDE "src/tima/old-switch-speed-tima-0x.inc"

; Check the machine cycle after switching speeds
; on which the 16KHz TIMA is incremented.

main:
    RUN_TEST_DS $0D, $35, TACF_16KHZ
    RUN_TEST_DS $0D, $36, TACF_16KHZ

    RUN_TEST_DS $0E, $35, TACF_16KHZ
    RUN_TEST_DS $0E, $36, TACF_16KHZ

    RUN_TEST_SS $0D, $35, TACF_16KHZ
    RUN_TEST_SS $0D, $36, TACF_16KHZ

    RUN_TEST_SS $0E, $35, TACF_16KHZ
    RUN_TEST_SS $0E, $36, TACF_16KHZ

    FINISH_TEST .EXPECTED_RESULT_CGB_AB

; 2021-06-15 - verified on my Game Boy Color
; (CPU CGB A/B according to which.gb 0.3)
.EXPECTED_RESULT_CGB_AB:
    DB 8 + 8 + 8
    ;
    ;  switch to double speed
    ;  TIMA  NOPS1 NOPS2
    DB $00,  $0D,  $35
    DB $01,  $0D,  $36
    DB $01,  $0E,  $35
    DB $02,  $0E,  $36
    ;
    ;  switch to single speed
    ;  TIMA  NOPS1 NOPS2
    DB $00,  $0D,  $35
    DB $01,  $0D,  $36
    DB $01,  $0E,  $35
    DB $02,  $0E,  $36
