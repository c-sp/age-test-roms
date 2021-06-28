INCLUDE "tima/sp-sw-tima-cgb.inc"

; Verified:
;   passes on CPU CGB E - CPU-CGB-06 (2021-06-24)
;    fails on CPU CGB B - CPU-CGB-02 (2021-06-24)
device_specific_tests:
    ; The immediate TIMA increment by DIV reset seems to be delayed
    ; by 1 m-cycle on CPU CGB E for the 65 KHz and the 16 KHz timer
    ; (similar to the 4 KHz timer) when switching speeds.

    TEST_INC_EDGE 6, 12, TACF_65KHZ ; 1 m-cycle before immediate increment by DIV reset
    TEST_INC_EDGE 6, 13, TACF_65KHZ ; 1 m-cycle before immediate increment by DIV reset
    TEST_INC_EDGE 7, 12, TACF_65KHZ ; trigger immediate increment by DIV reset
    TEST_INC_EDGE 7, 13, TACF_65KHZ ; trigger immediate increment by DIV reset

    TEST_INC_EDGE 14, 60, TACF_16KHZ ; 1 m-cycle before immediate increment by DIV reset
    TEST_INC_EDGE 14, 61, TACF_16KHZ ; 1 m-cycle before immediate increment by DIV reset
    TEST_INC_EDGE 15, 60, TACF_16KHZ ; trigger immediate increment by DIV reset
    TEST_INC_EDGE 15, 61, TACF_16KHZ ; trigger immediate increment by DIV reset

    ld hl, EXPECTED_TEST_RESULTS
    ret
