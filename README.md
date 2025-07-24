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

- `[0000]` Make some colors to `#000000`
  - Status bar, navigation bar, default background, search to `#000000`
  - Menu bar to `#101010`
  - The color of status bar & nav bar will be applied to PWA too.
  - Not for webpages (even force-dark). For this purpose, make your adblock `:style` filters.

- `[0001]` Open tab list by swipe up bottom toolbar
  - Original brave browser open tab list by swipe *down* bottom toolbar.
  - This patch fixes it to swipe *up* bottom toolbar.

### Color Comparison

| Original | Patched |
|:-:|:-:|
|<img width="540" height="1200" alt="Screenshot_1753330145" src="https://github.com/user-attachments/assets/d922eb8a-ddf0-4723-bd0d-dec80443c33b" />|<img width="540" height="1200" alt="Screenshot_1753330355" src="https://github.com/user-attachments/assets/c34face7-e074-4d3e-9562-d67b1b76d870" />|
|<img width="1080" height="2400" alt="Screenshot_1753330148" src="https://github.com/user-attachments/assets/f66f64e0-9b43-4fa2-9340-6febf5f5cbc3" />|<img width="1080" height="2400" alt="Screenshot_1753330358" src="https://github.com/user-attachments/assets/3925abcc-65e3-45c6-a2bc-f6f61300f400" />|
|<img width="1080" height="2400" alt="Screenshot_1753330166" src="https://github.com/user-attachments/assets/9b8cf059-ca63-4e68-8f46-4615d6ddc54c" />|<img width="1080" height="2400" alt="Screenshot_1753330372" src="https://github.com/user-attachments/assets/f994df23-692a-41e1-bce3-6a594911d11f" />|
|<img width="1080" height="2400" alt="Screenshot_1753330170" src="https://github.com/user-attachments/assets/b9672cda-aeba-43bd-bae6-ad8e9f1ecc36" />|<img width="1080" height="2400" alt="Screenshot_1753330375" src="https://github.com/user-attachments/assets/8f02d00c-b60e-446f-a4da-bb12124fc841" />|

## How to Patch?

- See `build.sh` and `.github/workflows/build.yml` for details.

## Inspired By

- [Ironfox-OLEDDark](https://github.com/ArtikusHG/Ironfox-OLEDDark)
- [Iceraven-OLED](https://github.com/GoodyOG/Iceraven-OLED)
