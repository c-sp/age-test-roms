# AGE test roms

These Game Boy test roms were written to complement
[other test suites](https://github.com/c-sp/gameboy-test-roms).

## Test Naming

All tests are named to include the devices they have been verified
to be compatible to.

| Test name | compatible devices |
|-----------|--------------------|
| `foo-cgbBE.gb` | `CPU-CGB-B` & `CPU-CGB-E`
| `foo-dmgC-cgbB.gb` | `CPU-DMG-C` & `CPU-CGB-B`
| `foo-dmgC-ncmB.gb` | `CPU-DMG-C` & `CPU-CGB-B` in non-CGB mode

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
