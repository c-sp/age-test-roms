# AGE test roms

These Game Boy test roms were written to complement
[other test suites](https://github.com/c-sp/gameboy-test-roms).

## Test Naming

All test names include the devices the respective test has been verified to be
compatible to.

E.g. a test named `foo-cgbBE.gb` is compatible only to `CPU-CGB-B` and
`CPU-CGB-E`.
A test named `foo-dmgC-cgbB.gb` is compatible only to `CPU-DMG-C` and
`CPU-CGB-B`.

## Font

AGE test roms use the
[Cellphone Font](https://opengameart.org/content/ascii-bitmap-font-cellphone)
created by
[domsson](https://opengameart.org/users/domsson).

## Build

You need [RGBDS](https://rgbds.gbdev.io) to `make` these roms.

## Development Tools

In my experience [Visual Studio Code](https://code.visualstudio.com)
with the [RGBDS GBZ80 plugin](https://github.com/DonaldHays/rgbds-vscode)
installed is your best choice.
