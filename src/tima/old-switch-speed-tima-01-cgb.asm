INCLUDE "src/tima/old-switch-speed-tima-0x.inc"

; Check the machine cycle after switching speeds
; on which the 262KHz TIMA is incremented.

main:
    RUN_TEST_DS $03, $01, TACF_262KHZ
    RUN_TEST_DS $03, $02, TACF_262KHZ

    RUN_TEST_DS $04, $01, TACF_262KHZ
    RUN_TEST_DS $04, $02, TACF_262KHZ

    RUN_TEST_SS $03, $01, TACF_262KHZ
    RUN_TEST_SS $03, $02, TACF_262KHZ

    RUN_TEST_SS $04, $01, TACF_262KHZ
    RUN_TEST_SS $04, $02, TACF_262KHZ

    FINISH_TEST .EXPECTED_RESULT_CGB_AB

; 2021-06-15 - verified on my Game Boy Color
; (CPU CGB A/B according to which.gb 0.3)
.EXPECTED_RESULT_CGB_AB:
    DB 8 + 8 + 8
    ;
    ;  switch to double speed
    ;  TIMA  NOPS1 NOPS2
    DB $06,  $03,  $01
    DB $07,  $03,  $02
    DB $07,  $04,  $01
    DB $08,  $04,  $02
    ;
    ;  switch to single speed
    ;  TIMA  NOPS1 NOPS2
    DB $06,  $03,  $01
    DB $07,  $03,  $02
    DB $07,  $04,  $01
    DB $08,  $04,  $02
