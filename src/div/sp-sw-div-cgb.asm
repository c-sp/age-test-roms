DEF ROM_IS_CGB_ONLY EQU 1
INCLUDE "test-setup.inc"



; Verified:
;   passes on CPU CGB E - CPU-CGB-06 (2021-06-23)
;   passes on CPU CGB B - CPU-CGB-02 (2021-06-23)
EXPECTED_TEST_RESULTS:
    ; number of test result rows
    DB 5
    ; double speed
    DB $00, $01,  $00, $01,  $00, $01,  $00, $01
    ; double speed -> single speed
    DB $00, $01,  $00, $01,  $00, $01,  $00, $01
    DB $00, $01,  $00, $01,  $00, $01,  $00, $01
    ; double speed -> single speed -> double speed
    DB $00, $01,  $00, $01,  $00, $01,  $00, $01
    DB $00, $01,  $00, $01,  $00, $01,  $00, $01



SAVE_DIV: MACRO
    ldh a, [rDIV]
    ld [hl+], a
ENDM

TEST_DS: MACRO
    ldh [rDIV], a ; reset div
    NOPS \1      ; wait before switching to double speed
    SWITCH_SPEED ; switch to double speed
    NOPS \2      ; wait before reading rDIV
    SAVE_DIV     ; read rDIV
    SWITCH_SPEED ; switch to single speed
ENDM

TEST_DS_SS: MACRO
    ldh [rDIV], a ; reset div
    SWITCH_SPEED ; switch to double speed
    NOPS \1      ; wait before switching to single speed
    SWITCH_SPEED ; switch to single speed
    NOPS \2      ; wait before reading rDIV
    SAVE_DIV     ; read rDIV
ENDM

TEST_DS_SS_DS: MACRO
    ldh [rDIV], a ; reset div
    SWITCH_SPEED ; switch to double speed
    NOPS \1      ; wait before switching to single speed
    SWITCH_SPEED ; switch to single speed
    NOPS \2      ; wait before switching to double speed
    SWITCH_SPEED ; switch to double speed
    NOPS \3      ; wait before reading rDIV
    SAVE_DIV     ; read rDIV
    SWITCH_SPEED ; switch to single speed
ENDM



run_test:
    LCD_OFF
    ld hl, TEST_RESULTS

    ; double speed

    TEST_DS $00, $3C
    TEST_DS $00, $3D
    TEST_DS $01, $3C
    TEST_DS $01, $3D
    TEST_DS $40, $3C
    TEST_DS $40, $3D
    TEST_DS $41, $3C
    TEST_DS $41, $3D

    ; double speed -> single speed

    TEST_DS_SS $00, $3C
    TEST_DS_SS $00, $3D
    TEST_DS_SS $01, $3C
    TEST_DS_SS $01, $3D
    TEST_DS_SS $02, $3C
    TEST_DS_SS $02, $3D
    TEST_DS_SS $03, $3C
    TEST_DS_SS $03, $3D

    TEST_DS_SS $40, $3C
    TEST_DS_SS $40, $3D
    TEST_DS_SS $41, $3C
    TEST_DS_SS $41, $3D
    TEST_DS_SS $42, $3C
    TEST_DS_SS $42, $3D
    TEST_DS_SS $43, $3C
    TEST_DS_SS $43, $3D

    ; double speed -> single speed -> double speed

    TEST_DS_SS_DS $00, $00, $3C
    TEST_DS_SS_DS $00, $00, $3D
    TEST_DS_SS_DS $01, $00, $3C
    TEST_DS_SS_DS $01, $00, $3D
    TEST_DS_SS_DS $02, $00, $3C
    TEST_DS_SS_DS $02, $00, $3D
    TEST_DS_SS_DS $03, $00, $3C
    TEST_DS_SS_DS $03, $00, $3D

    TEST_DS_SS_DS $00, $01, $3C
    TEST_DS_SS_DS $00, $01, $3D
    TEST_DS_SS_DS $01, $01, $3C
    TEST_DS_SS_DS $01, $01, $3D
    TEST_DS_SS_DS $02, $01, $3C
    TEST_DS_SS_DS $02, $01, $3D
    TEST_DS_SS_DS $03, $01, $3C
    TEST_DS_SS_DS $03, $01, $3D

    ret
