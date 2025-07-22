# Brave Android OLED Patches

Make Brave browser for Android more OLED-friendly.

## Why patches?

Brave browser is maybe the best and fast browser for Android,
but the developers don't care any UI improvements in my opinion.
(No oled black, no good bottom address bar, unmodifiable speed dial, etc.)
Thus, I made some patches to make it more OLED-friendly.

Currently this changes only some colors to black,
but in the future I will add more patches.

### Why Brave Beta?

Keep your stable version as a backup.

## Patches

- (0000) Make some colors to #000000
  - Status bar, navigation bar, default background, search to #000000
  - Menu bar to #101010

## How to Patch?

- See `build.sh` and `.github/workflows/build.yml` for details.

## Inspired By

- [Ironfox-OLEDDark](https://github.com/ArtikusHG/Ironfox-OLEDDark)
- [Iceraven-OLED](https://github.com/GoodyOG/Iceraven-OLED)
