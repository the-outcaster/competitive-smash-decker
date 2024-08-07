# Competitive Smash Decker
The goal of this project is to be the ultimate Swiss army knife for all things *Smash* on Steam Deck/Linux. Easily download, update, and install Smash 64 Remix, Slippi, Project+, and HewDraw Remix. You can also overclock your GameCube controller adapter, provided that you have a sudo password.

That being said, there will still need to be a little bit of legwork needed on your part -- at least during the initial couple of steps -- which is detailed below.

![Steam Deck](https://i.imgur.com/xELGiPb.jpg)

## What Currently Works
- [Smash 64 Remix](https://github.com/JSsixtyfour/smashremix)
  - download the latest patch and apply it to the ROM
- [Slippi](https://github.com/project-slippi/slippi-launcher)
  - download/update/play Slippi Launcher
  - configure Dolphin settings without launcher
- [Project+](https://projectplusgame.com/)
  - download and extract the latest patch
  - configure or play Project+
- [Smash Ultimate HDR](https://github.com/HDR-Development/HDR-Releases)
  - download or update the HDR Launcher
  - automatic creation of `legacy_discovery`, 100% save data, [Yuzu latency slider](https://github.com/saad-script/local-latency-slider), and configuration of the `qtconfig.ini` file for online multiplayer once the game has been run at least once
- overclock the GCC adapter
  - if the overclock module already exists you have the option to uninstall
  
![Script main menu](https://i.imgur.com/pQ8YHov.png)

## Distro Support
**SteamOS** (Steam Deck) is officially supported. The script is *mostly* distro-agnostic, depending on the functions you use, but you may encounter issues with other distros.

If you want to OC the GCC adapter on other distros you'll want to have the base development tools installed (`build-essential` on Ubuntu-based distros and `base-devel` on Arch-based distros) as well as the Linux kernel headers.

## How to Use
This repository does NOT contain any copyrighted assets. You must provide your own legally-dumped copies of your ROMs/ISOs.

### 1. Install Emulators
Please run [EmuDeck](https://www.emudeck.com/) first to get the necessary emulators installed. Emulators you'll want to install, if they're not installed already, include:
- Mupen64 for Smash Remix
- Yuzu 1734 for HDR

Good luck finding an AppImage for Yuzu 1734.

Slippi and Project+/PMEX Remix already come with their own AppImage.

### 2. Copy ROMs
Place your legally-dumped ROMs/ISOs in:
- Smash 64: `~/Emulation/roms/n64/smash64.z64`
- Slippi: `~/Emulation/roms/gamecube/ssbm.iso`
- Project+/PMEX Remix: `~/Emulation/roms/wii/ssbb.iso`
- HDR: `~/Emulation/roms/switch/ssbu.nsp`

If any of these ROMs aren't detected, some of the script's functions won't work.

### 3. Run the Script
Now you're ready to run the script. If you're on Steam Deck, download the [desktop file](https://raw.githubusercontent.com/the-outcaster/competitive-smash-decker/main/competitive-smash-decker.desktop) (right-click, save link as) and save it to your desktop. Double-click or tap the file to download and run the script.

Other distros can run the script with:

`curl -L https://raw.githubusercontent.com/the-outcaster/competitive-smash-decker/main/competitive-smash-decker.sh | sh`

## Notes

### Adding to Steam
**Mods are downloaded to `~/Applications/`.** Smash 64 Remix and HDR can be added as non-Steam shortcuts with Steam ROM Manager -- included with EmuDeck. Slippi and Project+/PMEX Remix will need to be manually added to Steam at the moment.

### Smash 64 Remix
After adding Mupen GUI and Smash 64 as non-Steam shortcuts, you may want to configure some of the controls and video options with Mupen GUI. Launch Mupen GUI through Steam and configure from there.

### Slippi
**The use of HD textures is discouraged.** The reason being is, Slippi does *not* support the pre-fetching of custom textures on Linux (the emulator will just crash as soon as the game is launched). Loading custom textures without pre-fetching them can make the game stutter-y.

### Project+/PMEX Remix
If you switch between playing Project+ and PMEX Remix, you'll need to keep changing the SD card path to switch between mods.

You *may* need to **set the graphics backend to Vulkan** if all you get is a white screen when launching either mod.

As with Slippi, **don't use HD textures**; it will cause the emulator to crash if pre-fetching is enabled.

If you're planning on playing PMEX Remix, you'll need to [download it manually](https://drive.google.com/drive/folders/1SpYOUHSKDrml6Ol1jwA4-JAX4TI9Ea0H) for now until I can figure out a way to download the latest release through the script.

### HDR Guide
If you're planning on playing HDR, you'll need to have:

- a `prod.keys` file, placed in `~/.local/share/yuzu/keys/`
- a dump of update 13.0.2 and any DLC you might have in addition to the base dump itself

Install these files with Yuzu.

Download HDR Launcher with the script, then open it to install HDR. Run *Smash Ultimate* once to generate the `arcropolis` folder, close Yuzu, then run "Resources" to get HDR properly working.
