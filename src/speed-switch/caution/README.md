# WARNING

The roms in this folder prematurely terminate the HALT mode period that
follows STOP when switching the CPU speed.
The purpose of that HALT mode period is to allow for
[oscillation stabilization](https://archive.org/details/GameBoyProgManVer1.1/page/n256)
before returning control to the CPU.

**Nintendo's Game Boy Programming Manual
[explicitly warns about this](https://archive.org/details/GameBoyProgManVer1.1/page/n34).**

I have experienced my Game Boy Color E (CPU CGB E - CPU-CGB-06) to become
instable for some while even after reset when running these roms several times
in a row.

My Game Boy Color B (CPU CGB B - CPU-CGB-02) on the other hand did not show any
instability issues though.
