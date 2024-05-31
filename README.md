# Competitive Smash Decker
The goal of this project is to be the ultimate Swiss army knife for all things *Smash* on Steam Deck/Linux. Easily download, update, and install Smash 64 Remix, Slippi, Project+, Lylat, Project M EX Remix, and HewDraw Remix. You can also overclock your GameCube controller adapter, provided that you have a sudo password.

That being said, there will still need to be a little bit of legwork needed on your part -- at least during the initial couple of steps -- which is detailed below.

![Steam Deck](https://i.imgur.com/xELGiPb.jpg)

## What Currently Works
- [Smash 64 Remix](https://github.com/JSsixtyfour/smashremix)
  - download the latest patch and apply it to the ROM
  - download the netplay build of Project64 (users will need to run the emulator via Wine or Steam with Proton)
- [Slippi](https://github.com/project-slippi/slippi-launcher)
  - download/update/play Slippi Launcher
  - configure Dolphin settings without launcher
  - download and patch latest Akaneia build
    - online multiplayer support for Akaneia via [Lylat](https://lylat.gg)
  - download and patch Animelee, Animelee DBZ edition, and Diet Melee
- [Project+](https://projectplusgame.com/)
  - download and extract the latest patch
  - configure or play Project+
  - online multiplayer support via Lylat
- [Project M EX Remix](https://linuxgamingcentral.com/posts/how-to-setup-project-m-ex-on-deck/)
  - manual download of PMEX Remix
  - configure and play Project+/PMEX Remix
- [Smash Ultimate HDR](https://github.com/HDR-Development/HDR-Releases)
  - download the latest (stable) HDR patch and install them for both Ryujinx and Yuzu
  - configure Ryujinx and Yuzu settings
  - download and install 100% save file, legacy discovery (to allow ARCropolis to properly load HDR), and Wi-Fi fix (for Yuzu)
  - launch HDR directly with either Ryujinx or Yuzu
- overclocking the GCC adapter
  - if the overclock module already exists you have the option to uninstall
  
![Script main menu](https://i.imgur.com/pQ8YHov.png)

## Distro Support
**SteamOS** (Steam Deck) is officially supported. There is preliminary support for **ChimeraOS**. The script is *mostly* distro-agnostic, depending on the functions you use, but you may encounter issues with other distros.

If you're looking to play Akaneia on other distros make sure you have the `p7zip-full` package installed, as the script will need to extract a .7z file to apply the patch. If you want to OC the GCC adapter on other distros you'll want to have the base development tools installed (`build-essential` on Ubuntu-based distros and `base-devel` on Arch-based distros) as well as the Linux kernel headers.

## How to Use
This repository does NOT contain any copyrighted assets. You must provide your own legally-dumped copies of your ROMs/ISOs.

### 1. Install Emulators
Please run [EmuDeck](https://www.emudeck.com/) first to get the necessary emulators installed. Emulators you'll want to install, if they're not installed already, include:
- Mupen64 (N64)
- Ryujinx (Switch)
- Yuzu (Switch)

Slippi, Lylat, and Project+/PMEX Remix already come with their own AppImage.

After that run the Mupen64, Ryujinx, and Yuzu emulators at least once to generate the configuration files.

### 2. Copy ROMs
Place your legally-dumped ROMs/ISOs in:
- Smash 64: `~/Emulation/roms/n64/smash64.z64`
- Slippi: `~/Emulation/roms/gamecube/ssbm.iso`
- Project+/PMEX Remix: `~/Emulation/roms/wii/ssbb.iso`
- HDR: `~/Emulation/roms/switch/ssbu.nsp`

If any of these ROMs aren't detected, some of the script's functions won't work.

### 3. Run the Script
Now you're ready to run the script. If you're on Steam Deck, download the [desktop file](https://raw.githubusercontent.com/linuxgamingcentral/competitive-smash-decker/main/competitive-smash-decker.desktop) (right-click, save link as) and save it to your desktop. Double-click or tap the file to download and run the script.

Other distros can run the script with:

`curl -L https://raw.githubusercontent.com/linuxgamingcentral/competitive-smash-decker/main/competitive-smash-decker.sh | sh`

## Notes

### Mod Uploads
I have uploaded some mods (particularly those that are hosted on Mediafire and Google Drive) to my server. In particular:
- Animelee and Diet Melee patches
- HDR 100% save data, legacy discovery, and the Wi-Fi fix

This makes it easier to download these mods through the script. The downloads can now be handled automatically versus having to manually download them yourself. If any developer has a problem with this, they're more than welcome to shoot me an [email](mailto:contact@linuxgamingcentral.com) or file an issue and I will gladly take the mod down.

### Adding to Steam
**Mods are downloaded to `~/Applications/`.** Smash 64 Remix and HDR can be added as non-Steam shortcuts with Steam ROM Manager -- included with EmuDeck. Slippi, Lylat, and Project+/PMEX Remix will need to be manually added to Steam at the moment.

### Smash 64 Remix
After adding Mupen GUI and Smash 64 as non-Steam shortcuts, you may want to configure some of the controls and video options with Mupen GUI. Launch Mupen GUI through Steam and configure from there.

Project64 is Windows-only and as such will require you to add the emulator as a non-Steam shortcut, then force Steam to use Proton. Again, you may want to reconfigure your controls and the video options.

### Slippi
**The use of HD textures is discouraged.** The reason being is, Slippi does *not* support the pre-fetching of custom textures on Linux (the emulator will just crash as soon as the game is launched). Loading custom textures without pre-fetching them can make the game stutter-y.

In regards to Diet Melee, **only the classic edition patch for Diet Melee currently works.** Trying to patch Crystal Melee or Diet 64 will just throw a xdelta3 error regarding a missing compressor.

### Project+/PMEX Remix
**You'll need to manually configure your default ISO, SD card path, and launcher directory with Project+ and PMEX Remix.** Additionally, if you switch between playing Project+ and PMEX Remix, you'll need to keep changing the SD card path to switch between mods.

You *may* need to set the graphics backend to Vulkan if all you get is a white screen when launching either mod.

As with Slippi, **don't use HD textures**; it will cause the emulator to crash if pre-fetching is enabled.

If you're planning on playing PMEX Remix, you'll need to download it manually for now until I can figure out a way to download the latest release through the script.

### Lylat
Lylat adds online multiplayer to Akaneia (Melee) and Project+. There are separate builds for each that are downloaded into `~/Applications/Lylat/` as an AppImage. You will need to create a [Lylat account](https://lylat.gg/). Once you've started Lylat with Akaneia, you will be asked to login. Save the `lylat.json` file to `~/.config/SlippiOnline/`.

If you're using the Lylat build for Project+, you will need to set your default ISO, SD card path, and launcher path. You will also need to attach your `lylat.json` file.

### HDR Guide
If you're planning on playing HDR, you'll need to:

- copy `prod.keys` to `~/.config/Ryujinx/system/` if you're using Ryujinx, and/or `~/.local/share/yuzu/keys/` if you're using Yuzu
- dump your SSBU DLC and updates (13.0.1) and install these with the emulator you're using
- if you're using Ryujinx: dump your Switch FW and install it

**I currently recommend using Yuzu for HDR**, because:
- it boots and runs faster
- it has GCC adapter support
- it has online multiplayer
- the emulator doesn't hang when you stop emulating the game
- you don't need to dump/install your Switch FW

After you've downloaded the latest HDR patch with the script, you'll need to run Smash Ultimate at least once to generate the `arcropolis` folder inside of `sdmc` and `sdcard`, depending on the emulator you want to use. You'll then need to apply the fixes (save file, legacy discovery, and Wi-Fi fix) via the script in order to get HDR to work properly.

If you want to play online multiplayer with Yuzu, you'll need to go to Emulation -> Configure -> General -> Web and select the "Sign Up" link to register a Citra Community profile. After you've logged in you'll be presented with a token. Paste this token into the "Token:" field in Yuzu and click "Verify". From there you can join a lobby from the Multiplayer tab in the menu. 

## To-Do
- allow users to add Slippi, Lylat, Project+, and PMEX Remix as non-Steam shortcuts
- moar mods
