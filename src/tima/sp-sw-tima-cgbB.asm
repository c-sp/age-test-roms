INCLUDE "tima/sp-sw-tima-cgb.inc"

; Verified:
;    fails on CPU CGB E - CPU-CGB-06 (2021-06-24)
;   passes on CPU CGB B - CPU-CGB-02 (2021-06-24)
device_specific_tests:
    ; Immediate TIMA increments by DIV reset work as expected
    ; on CPU CGB B for the 65 KHz and the 16 KHz timer when
    ; switching speeds.

    TEST_INC_EDGE 5, 12, TACF_65KHZ ; 1 m-cycle before immediate increment by DIV reset
    TEST_INC_EDGE 5, 13, TACF_65KHZ ; 1 m-cycle before immediate increment by DIV reset
    TEST_INC_EDGE 6, 12, TACF_65KHZ ; trigger immediate increment by DIV reset
    TEST_INC_EDGE 6, 13, TACF_65KHZ ; trigger immediate increment by DIV reset

    TEST_INC_EDGE 13, 60, TACF_16KHZ ; 1 m-cycle before immediate increment by DIV reset
    TEST_INC_EDGE 13, 61, TACF_16KHZ ; 1 m-cycle before immediate increment by DIV reset
    TEST_INC_EDGE 14, 60, TACF_16KHZ ; trigger immediate increment by DIV reset
    TEST_INC_EDGE 14, 61, TACF_16KHZ ; trigger immediate increment by DIV reset

    ld hl, EXPECTED_TEST_RESULTS
    ret
