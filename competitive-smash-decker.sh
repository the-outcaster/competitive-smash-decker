#!/bin/bash

clear

echo -e "Competitive Smash Decker - script by Linux Gaming Central\n"

title="Competitive Smash Decker"

# Removes unhelpful GTK warnings
zen_nospam() {
  zenity 2> >(grep -v 'Gtk' >&2) "$@"
}

# zenity functions
error() {
	e=$1
	zen_nospam --error --title="$title" --width=500 --height=100 --text "$1"
}

info() {
	i=$1
	zen_nospam --info --title "$title" --width 400 --height 75 --text "$1"
}

progress_bar() {
	t=$1
	zen_nospam --title "$title" --text "$1" --progress --auto-close --auto-kill --width=300 --height=100

	if [ "$?" != 0 ]; then
		echo -e "\nUser canceled.\n"
	fi
}

question() {
	q=$1
	zen_nospam --question --title="$title" --width=300 height=200 --text="$1"
}

text_info() {
	title=$1
	filename=$2
	zen_nospam --text-info --width=500 --height=500 --title="$1" --filename="$2"
}

# menus
main_menu() {
	zen_nospam --width 700 --height 350 --list --radiolist --multiple --title "$title"\
	--column ""\
	--column "Option"\
	--column="Description"\
	FALSE Remix "Smash 64 Remix with additional characters"\
	FALSE Slippi "Super Smash Bros. Melee with online multiplayer"\
	FALSE Project+ "A continuation of Project M that turns SSBB into a more competitive game"\
	FALSE PMEX "Project+ with a plethora of additional characters"\
	FALSE HDR "Smash Ultimate with competitive mechanics"\
	FALSE Overclock "Overclock your GCC adapter (root password required)"\
	TRUE Exit "Exit this script"
}

smash64_remix_menu() {
	zen_nospam --width 700 --height 350 --list --radiolist --multiple --title "$title"\
	--column ""\
	--column "Option"\
	--column="Description"\
	FALSE Download "Download Smash 64 Remix patch and patch the ROM"\
	FALSE Netplay "Get Project64 for netplay"\
	TRUE Exit "Exit this submenu"
}

slippi_menu() {
	zen_nospam --width 700 --height 350 --list --radiolist --multiple --title "$title"\
	--column ""\
	--column "Option"\
	--column="Description"\
	FALSE Launcher "Download or update the Slippi Launcher"\
	FALSE Lylat "Download or update Lylat (netplay with Akaneia)"\
	FALSE Launch_Launcher "Launch Slippi Launcher"\
	FALSE Slippi "Configure or play Slippi (without launcher)"\
	FALSE Configure_Lylat "Configure or play Lylat"\
	FALSE Mods "Get mods"\
	TRUE Exit "Exit this submenu"
}

mods_menu() {
	zen_nospam --width 700 --height 350 --list --radiolist --multiple --title "$title"\
	--column ""\
	--column "Option"\
	--column="Description"\
	FALSE Animelee "Get Animelee"\
	FALSE Animelee_DBZ "Get Animelee (DBZ edition)"\
	FALSE Diet "Get Diet Melee (Classic edition)"\
	FALSE DietCrystal "Get Diet Melee (Crystal edition) CURRENTLY NOT WORKING"\
	FALSE Diet64 "Get Diet Melee (N64 edition) CURRENTLY NOT WORKING"\
	FALSE Akaneia "Get Akaneia"\
	FALSE Other "Get other mods (your web browser will open)"\
	TRUE Exit "Exit this submenu"
}

projectplus_menu() {
	zen_nospam --width 700 --height 350 --list --radiolist --multiple --title "$title"\
	--column ""\
	--column "Option"\
	--column="Description"\
	FALSE Download "Download or update Project+"\
	FALSE Lylat "Download or update Lylat (P+ with netplay)"\
	FALSE Configure "Configure or play Project+"\
	FALSE Configure_Lylat "Configure or play Lylat"\
	False Changelog "View changelog (will open your web browser)"\
	TRUE Exit "Exit this submenu"
}

pmex_menu() {
	zen_nospam --width 700 --height 350 --list --radiolist --multiple --title "$title"\
	--column ""\
	--column "Option"\
	--column="Description"\
	FALSE Download "Download or update PMEX Remix (your web browser will open)"\
	FALSE Configure "Configure P+"\
	FALSE Play "Launch PMEX Remix"\
	TRUE Exit "Exit this submenu"
}

hdr_menu() {
	zen_nospam --width 700 --height 350 --list --radiolist --multiple --title "$title"\
	--column ""\
	--column "Option"\
	--column="Description"\
	FALSE Download "Download or update HDR"\
	FALSE Fixes "Add 100% save data and legacy discovery for Ryujinx"\
	False Fixes_Yuzu "Add 100% save data, legacy discovery, and Wi-Fi fix for Yuzu"\
	FALSE Configure "Configure Ryujinx"\
	FALSE Configure_Yuzu "Configure Yuzu"\
	FALSE Play "Launch HDR with Ryujinx"\
	FALSE Play_Yuzu "Launch HDR with Yuzu"\
	TRUE Exit "Exit this submenu"
}

# functions
get_sudo_password() {
	sudo_password=$(zen_nospam --password --title="$title")
	if [[ ${?} != 0 || -z ${sudo_password} ]]; then
		echo -e "User canceled.\n"
	elif ! sudo -kSp '' [ 1 ] <<<${sudo_password} 2>/dev/null; then
		echo -e "User entered wrong password.\n"
		error "Wrong password."
	else
		echo -e "Password entered, let's proceed...\n"
	fi
}

check_if_xdelta_exists() {
	# check if user has xdelta3, if not download it
	if ! [ -f $HOME/Applications/xdelta3/xdelta3 ]; then
		echo -e "Downloading xdelta3...\n"
		mkdir -p $HOME/Applications/xdelta3
		curl -L https://linuxgamingcentral.com/files/xdelta3 -o $HOME/Applications/xdelta3/xdelta3
		chmod +x $HOME/Applications/xdelta3/xdelta3
	fi
}

apply_animelee_patch() {
	zip_name=$1
	patch_name=$2
	output_iso=$3
	
	if ! [ -f $melee_ROM ]; then
		error "SSBM not found. Please put it in $melee_ROM."
	else
		check_if_xdelta_exists
		
		mkdir -p $HOME/Applications/Slippi-Launcher/animelee

		echo -e "Downloading...\n"
		curl -L https://linuxgamingcentral.com/files/animelee/$1 -o $HOME/Applications/Slippi-Launcher/animelee/$1
		
		echo -e "Extracting...\n"
		unzip -o $HOME/Applications/Slippi-Launcher/animelee/$1 -d $HOME/Applications/Slippi-Launcher/animelee/
		
		echo -e "Patching, this will take a minute or two...\n"
		$HOME/Applications/xdelta3/./xdelta3 -dfs $melee_ROM $HOME/Applications/Slippi-Launcher/animelee/$2 $HOME/Emulation/roms/gamecube/$3
		
		echo -e "Cleaning up...\n"
		rm $HOME/Applications/Slippi-Launcher/animelee/$1
		
		info "$3 added to $HOME/Emulation/roms/gamecube/!"
	fi
}

apply_diet_patch() {
	patch_name=$1
	output_iso=$2
	
	if ! [ -f $melee_ROM ]; then
		error "SSBM not found. Please put it in $melee_ROM."
	else
		check_if_xdelta_exists
							
		mkdir -p $HOME/Applications/Slippi-Launcher/diet_melee
							
		# check to see if patch exists, if not download it
		if ! [ -f $HOME/Applications/Slippi-Launcher/diet_melee/$1 ]; then
			echo -e "$1 not found, downloading...\n"
			curl -L https://linuxgamingcentral.com/files/diet_melee/diet_melee.zip -o $HOME/Applications/Slippi-Launcher/diet_melee/diet_melee.zip
								
			echo -e "Extracting...\n"
			unzip -o $HOME/Applications/Slippi-Launcher/diet_melee/diet_melee.zip -d $HOME/Applications/Slippi-Launcher/diet_melee/
								
			echo -e "Cleaning up...\n"
			rm $HOME/Applications/Slippi-Launcher/diet_melee/diet_melee.zip
		fi
							
		echo -e "Patching, this will take a minute or two...\n"
		$HOME/Applications/xdelta3/./xdelta3 -dfs $melee_ROM $HOME/Applications/Slippi-Launcher/diet_melee/$1 $HOME/Emulation/roms/gamecube/$2
							
		info "$2 added to $HOME/Emulation/roms/gamecube/!"
	fi
}

hdr_patches() {
	info "Note: you may need to manually copy the files in $HOME/Applications/HDR/ to the proper place if this doesn't work."
	
	# download save file, legacy discovery (for ARCropolis), and wifi fix
	echo -e "Downloading save file...\n"
	curl -L https://linuxgamingcentral.com/files/hdr/100_save_data.zip -o $HOME/Applications/HDR/save_data.zip
	sleep 1
				
	echo -e "Downloading legacy discovery...\n"
	curl -L https://linuxgamingcentral.com/files/hdr/legacy_discovery.zip -o $HOME/Applications/HDR/legacy_discovery.zip
	sleep 1
				
	echo -e "Downloading Wi-Fi fix...\n"
	curl -L https://linuxgamingcentral.com/files/hdr/wifi_fix.zip -o $HOME/Applications/HDR/wifi_fix.zip
	sleep 1
				
	# extraction
	echo -e "Extracting save data...\n"
	unzip -o HDR/save_data.zip -d HDR
	sleep 1
				
	echo -e "Extracting legacy discovery...\n"
	unzip -o HDR/legacy_discovery.zip -d HDR
	sleep 1
				
	echo -e "Extracting Wi-Fi fix...\n"
	unzip -o HDR/wifi_fix.zip -d HDR
	sleep 1			
}

overclock () {
	rm -rf gcadapter-oc-kmod

	# Clone repo and change into the directory
	git clone https://github.com/hannesmann/gcadapter-oc-kmod.git
	cd gcadapter-oc-kmod

	# Make the module
	make

	# Install it
	sudo insmod gcadapter_oc.ko

	# Persist across reboots
	sudo mkdir -p "/usr/lib/modules/$(uname -r)/extra"
	sudo cp gcadapter_oc.ko "/usr/lib/modules/$(uname -r)/extra"
	sudo depmod
	echo "gcadapter_oc" | sudo tee /etc/modules-load.d/gcadapter_oc.conf
}

undo_overclock() {
	cd gcadapter-oc-kmod/
	sudo rmmod gcadapter_oc.ko
	make clean
	sudo rm /usr/lib/modules/$(uname -r)/extra/gcadapter_oc.ko
	sudo rm /etc/modules-load.d/gcadapter_oc.conf
}

# roms
smash64_ROM=$HOME/Emulation/roms/n64/smash64.z64
melee_ROM=$HOME/Emulation/roms/gamecube/ssbm.iso
brawl_ROM=$HOME/Emulation/roms/wii/ssbb.iso
ultimate_ROM=$HOME/Emulation/roms/switch/ssbu.nsp

# executables
slippi_launcher=$HOME/Applications/Slippi-Launcher/Slippi-Launcher.AppImage
slippi=$HOME/.config/Slippi\ Launcher/netplay/Slippi_Online-x86_64.AppImage
lylat_melee=$HOME/Applications/Lylat/Lylat.AppImage
project_plus=$HOME/Applications/ProjectPlus/Faster_Project_Plus-x86-64.AppImage
lylat_project_plus=$HOME/Applications/Lylat/Lylat_Online-x86_64.AppImage

ryujinx=$HOME/Applications/publish/Ryujinx
yuzu=$HOME/Applications/yuzu.AppImage

# Check if GitHub is reachable
if ! curl -Is https://github.com | head -1 | grep 200 > /dev/null
then
    echo "GitHub appears to be unreachable, you may not be connected to the Internet."
    exit 1
fi

cd $HOME
mkdir -p Emulation
mkdir -p Emulation/roms
mkdir -p Emulation/roms/n64
mkdir -p Emulation/roms/gamecube
mkdir -p Emulation/roms/wii
mkdir -p Emulation/roms/switch

mkdir -p Applications
cd Applications

# Main menu
while true; do
Choice=$(main_menu)
	if [ $? -eq 1 ] || [ "$Choice" == "Exit" ]; then
		
		echo Goodbye!
		exit

	elif [ "$Choice" == "Remix" ]; then
		
		while true; do
		Choice=$(smash64_remix_menu)
			if [ $? -eq 1 ] || [ "$Choice" == "Exit" ]; then
				break
			
			elif [ "$Choice" == "Download" ]; then
				#check to see if ROM exists
				if ! [ -f $smash64_ROM ]; then
					error "ROM not found. Please put it in $HOME/Emulation/roms/n64/ and name it to smash64.z64"
				else
					curl -L $(curl -s https://api.github.com/repos/JSsixtyfour/smashremix/releases/latest | grep "browser_download_url" | cut -d '"' -f 4) -o smashremix.zip
					unzip -o smashremix.zip
					chmod +x smashremix*/.ezpatch/bin/linux/ucon64 smashremix*/.ezpatch/bin/linux/xdelta3 smashremix*/.ezpatch/scripts/unix.sh
					bash smashremix*/.ezpatch/scripts/unix.sh $smash64_ROM
					mv smashremix*/output/smashremix*.z64 $HOME/Emulation/roms/n64/
					info "Smash 64 Remix ROM has been moved over to $HOME/Emulation/roms/n64/."
					rm smashremix.zip
				fi
			
			elif [ "$Choice" == "Netplay" ]; then
				info "This will download and extract the Project64 build designed specifically for netplay. Note that this is a Windows-only build.\nYou will need to run the emulator via Wine or Steam with Proton."
				
				mkdir -p $HOME/Applications/project64k-legacy
				
				echo -e "Downloading Project64...\n"
				sleep 1
				curl -L $(curl -s https://api.github.com/repos/smash64-dev/project64k-legacy/releases/latest | grep "browser_download_url" | grep zip | cut -d '"' -f 4) -o project64k-legacy.zip
				
				echo -e "Extracting...\n"
				sleep 1
				unzip -o project64k-legacy.zip -d $HOME/Applications/project64k-legacy
				
				echo -e "Cleaning up...\n"
				sleep 1
				rm project64k-legacy.zip
				
				info "Project64 downloaded and extracted to $HOME/Applications/project64k-legacy.\nAdd Project64KSE.exe as a non-Steam shortcut, then force it to run Proton."
			fi
		done
	
	elif [ "$Choice" == "Slippi" ]; then
		
		while true; do
		Choice=$(slippi_menu)
		
			if [ $? -eq 1 ] || [ "$Choice" == "Exit" ]; then
				break
			
			elif [ "$Choice" == "Launcher" ]; then
				mkdir -p Slippi-Launcher
				
				DOWNLOAD_URL=$(curl -s https://api.github.com/repos/project-slippi/slippi-launcher/releases/latest \
        				| grep "browser_download_url" \
			        	| grep AppImage \
			        	| cut -d '"' -f 4)
				curl -L "$DOWNLOAD_URL" -o $slippi_launcher
				
				chmod +x $slippi_launcher
				info "Slippi Launcher downloaded/updated!"
			
			elif [ "$Choice" == "Lylat" ]; then
				mkdir -p Lylat
				
				echo -e "Downloading...\n"
				curl -L $(curl -s https://api.github.com/repos/project-lylat/Ishiiruka/releases/latest | grep "browser_download_url" | grep AppImage | cut -d '"' -f 4) -o $lylat_melee
				curl -L $(curl -s https://api.github.com/repos/project-lylat/Ishiiruka/releases/latest | grep "browser_download_url" | grep zsync | cut -d '"' -f 4) -o $lylat_melee.zsync
				
				chmod +x $lylat_melee
				
				info "Lylat downloaded/updated!"
			
			elif [ "$Choice" == "Launch_Launcher" ]; then
				if ! [ -f $slippi_launcher ]; then
					error "Slippi Launcher AppImage not found."
				else
					exec $slippi_launcher
				fi
			
			elif [ "$Choice" == "Slippi" ]; then
				if ! [ -f "$slippi" ]; then
					error "Slippi AppImage not found."
				else
					exec "$slippi"
				fi				
			
			elif [ "$Choice" == "Configure_Lylat" ]; then
				if ! [ -f $lylat_melee ]; then
					error "Lylat AppImage not found."
				else
					exec $lylat_melee
				fi
			
			elif [ "$Choice" == "Mods" ]; then
				while true; do
				Choice=$(mods_menu)
					
					if [ $? -eq 1 ] || [ "$Choice" == "Exit" ]; then
						break
					
					elif [ "$Choice" == "Animelee" ]; then
						apply_animelee_patch "animelee.zip" "animelee.xdelta" "animelee.iso"
					
					elif [ "$Choice" == "Animelee_DBZ" ]; then
						apply_animelee_patch "animelee_dbz.zip" "animelee_dbz.xdelta" "animelee_dbz.iso"
					
					elif [ "$Choice" == "Diet" ]; then
						apply_diet_patch "DietMeleeClassic.xdelta" "diet_melee_classic.iso"
						
					elif [ "$Choice" == "DietCrystal" ]; then
						# xdelta complains: "xdelta3: unavailable secondary compressor: LZMA: XD3_INTERNAL", not sure what to do about this at the moment
						apply_diet_patch "crystaldiff.xdelta" "diet_melee_crystal.iso"
						
					elif [ "$Choice" == "Diet64" ]; then
						apply_diet_patch "64diff.xdelta" "diet_melee_64.iso"
					
					elif [ "$Choice" == "Akaneia" ]; then
						if ! [ -f $melee_ROM ]; then
							error "SSBM not found. Please name it to ssbm.iso and put it in $HOME/Emulation/roms/gamecube/."
						else
							check_if_xdelta_exists
							
							# download the patch and patch the ISO
							# progress bar doesn't seem to work here, just have to use terminal text for now

							echo -e "Downloading...\n"
							curl -L $(curl -s https://api.github.com/repos/akaneia/akaneia-build/releases/latest | grep "browser_download_url" | cut -d '"' -f 4) -o akaneia.7z
							
							echo -e "Extracting...\n"
							7za x akaneia.7z
							
							echo -e "Patching, this will take a minute or two...\n"
							$HOME/Applications/xdelta3/./xdelta3 -dfs $melee_ROM $HOME/Applications/Akaneia\ Builder/patch.xdelta $HOME/Emulation/roms/gamecube/akaneia.iso
							
							echo -e "Cleaning up...\n"
							rm -rf Akaneia\ Builder
							rm akaneia.7z
							
							info "Akaneia added to $HOME/Emulation/roms/gamecube/!"
						fi
						
					elif [ "$Choice" == "Other" ]; then
						xdg-open https://ssbmtextures.com
					
					fi
				done
			fi
		done
	
	elif [ "$Choice" == "Project+" ]; then
		
		while true; do
		Choice=$(projectplus_menu)
		
			if [ $? -eq 1 ] || [ "$Choice" == "Exit" ]; then
				break
					
			elif [ "$Choice" == "Download" ]; then
				mkdir -p ProjectPlus
				cd ProjectPlus
				
				# remove files if they have been previously downloaded
				rm -rf *
				
				(
				echo "33"
				echo "# Downloading files..."
				curl -L https://api.github.com/repos/jlambert360/FPM-AppImage/releases/latest | grep "browser_download_url" | cut -d : -f 2,3 | tr -d \" | wget -qi -
				
				echo "66"
				echo "# Extracting..."
				tar -xf Launcher.tar.gz
				tar -xf sd.tar.gz
				
				chmod +x $project_plus
				
				echo "90"
				echo "# Cleaning up..."
				rm Launcher.tar.gz sd.tar.gz
				) | progress_bar ""
				
				info "Project+ downloaded/updated!"
				
				cd $HOME/Applications
			
			elif [ "$Choice" == "Lylat" ]; then
				mkdir -p Lylat
				
				echo -e "Downloading...\n"
				curl -L $(curl -s https://api.github.com/repos/project-lylat/dolphin/releases/latest | grep "browser_download_url" | grep linux | cut -d '"' -f 4) -o lylat.zip
				
				echo -e "Extracting...\n"
				unzip -o lylat.zip
				rm lylat.zip
				unzip -o *.zip -d $HOME/Applications/Lylat
				
				chmod +x $HOME/Applications/Lylat/*.AppImage
				
				echo -e "Cleaning up...\n"
				rm *.zip

				info "Lylat downloaded/updated!"
			
			elif [ "$Choice" == "Configure" ]; then
				if ! [ -f $project_plus ]; then
					error "Project+ AppImage not found."
				else
					exec $project_plus
				fi
			
			elif [ "$Choice" == "Configure_Lylat" ]; then
				if ! [ -f $lylat_project_plus ]; then
					error "Lylat AppImage not found."
				else
					exec $lylat_project_plus
				fi
			
			elif [ "$Choice" == "Changelog" ]; then
				xdg-open https://projectplusgame.com/changes
					
			fi
		done
	
	elif [ "$Choice" == "PMEX" ]; then
		
		while true; do
		Choice=$(pmex_menu)
		
			if [ $? -eq 1 ] || [ "$Choice" == "Exit" ]; then
				break
					
			elif [ "$Choice" == "Download" ]; then
				mkdir -p PMEX-Remix

				xdg-open https://drive.google.com/drive/folders/1u6aENdnSyDio-CmpNRLg8NXxc8xoYfQh
			
			elif [ "$Choice" == "Configure" ]; then
				if ! [ -f $project_plus ]; then
					error "Project+ AppImage not found."
				else
					exec $project_plus
				fi
			
			elif [ "$Choice" == "Play" ]; then
				if ! [ -f $project_plus ]; then
					error "Project+ AppImage not found."
				else
					exec $project_plus "$HOME/Applications/PMEX-Remix/Launcher/P+EX REMIX OFFLINE/Project_Offline_Launcher.elf"
				fi
					
			fi
		done	
	
	elif [ "$Choice" == "HDR" ]; then
		
		while true; do
		Choice=$(hdr_menu)
			if [ $? -eq 1 ] || [ "$Choice" == "Exit" ]; then
				break
			
			elif [ "$Choice" == "Download" ]; then
				mkdir -p HDR
				
				if ! [ -d $HOME/.config/Ryujinx ]; then
					error "Ryujinx configuration not found, please install Ryujinx via EmuDeck and run it at least once to generate the config files/folders."
					break
				fi
				
				if ! [ -d $HOME/.local/share/yuzu ]; then
					error "Yuzu configuration not found, please install Yuzu via EmuDeck and run it at least once to generate the config files/folders."
					break
				fi
		
				(
				echo "20"
				echo "# Downloading HDR..."
				DOWNLOAD_URL=$(curl -s https://api.github.com/repos/HDR-Development/HDR-Releases/releases/latest \
					| grep "browser_download_url" \
					| grep ryujinx-package.zip \
					| cut -d '"' -f 4)
				curl -L "$DOWNLOAD_URL" -o HDR/hdr.zip
				
				echo "50"
				echo "# Extracting HDR..."
				unzip -o -q HDR/hdr.zip -d HDR
					
				echo "70"
				echo "# Copying HDR to Ryujinx..."
				cp -r HDR/sdcard $HOME/.config/Ryujinx/
					
				echo "85"
				echo "# Copying HDR to Yuzu..."
				
				# need to copy HDR files to a different place on Deck with Yuzu, since the default sdmc location is different...
				if [ $USER == "deck" ] || [ $USER == "gamer" ]; then
					cp -r HDR/sdcard/atmosphere $HOME/Emulation/storage/yuzu/sdmc/
					cp -r HDR/sdcard/ultimate $HOME/Emulation/storage/yuzu/sdmc/
				else
					cp -r HDR/sdcard/atmosphere $HOME/.local/share/yuzu/sdmc/
					cp -r HDR/sdcard/ultimate $HOME/.local/share/yuzu/sdmc/
				fi
					
				echo "95"
				echo "# Cleaning up..."
				rm HDR/hdr.zip
				) | progress_bar ""
					
				info "HDR successfully downloaded and installed!"
				info "Please run Smash Ultimate once with Ryujinx and/or Yuzu to generate the necessary files/folders, then run 'Fixes' to get HDR properly working."
					
			elif [ "$Choice" == "Fixes" ]; then
				if ! [ -d $HOME/.config/Ryujinx/sdcard/ultimate/arcropolis ]; then
					error "ARCropolis folder not found for Ryujinx, you need to run Smash Ultimate at least once in order to apply the fixes."
				else
					hdr_patches #download and extract patches
							
					echo -e "Copying save data for Ryujinx...\n"
					cp -r HDR/save_data $HOME/.config/Ryujinx/bis/user/save/0000000000000001/0/
					sleep 1
					
					echo -e "Copying legacy discovery for Ryujinx...\n"
					cp HDR/legacy_discovery $HOME/.config/Ryujinx/sdcard/ultimate/arcropolis/config/*/*/
					sleep 1
					
					echo -e "Cleaning up...\n"
					rm HDR/save_data.zip HDR/legacy_discovery.zip HDR/wifi_fix.zip
					
					info "HDR fixes applied for Ryujinx! HDR should now work as expected."
				fi
			
			elif [ "$Choice" == "Fixes_Yuzu" ]; then
				if ! [ -d $HOME/Emulation/storage/yuzu/sdmc/ultimate/arcropolis ] && ! [ -d $HOME/.local/share/yuzu/sdmc/ultimate/arcropolis ]; then
					error "ARCropolis folder not found for Yuzu, you need to run Smash Ultimate at least once in order to apply the fixes."
				else
					hdr_patches #download and extract patches
					
					# copy the files to the default sdmc location on Deck/ChimeraOS
					if [ $USER == "deck" ] || [ $USER == "gamer" ]; then
						echo -e "Copying save data for Yuzu...\n"
						cp -r HDR/save_data $HOME/Emulation/storage/yuzu/nand/user/save/0000000000000000/*/01006A800016E000/
						sleep 1
						
						echo -e "Copying legacy discovery for Yuzu...\n"
						cp HDR/legacy_discovery $HOME/Emulation/storage/yuzu/sdmc/ultimate/arcropolis/config/*/*/
						sleep 1
						
						echo -e "Copying Wi-Fi fix for Yuzu...\n"
						cp HDR/subsdk9 $HOME/Emulation/storage/yuzu/sdmc/atmosphere/contents/01006A800016E000/exefs/
						sleep 1
						
						echo -e "Cleaning up...\n"
						rm HDR/save_data.zip HDR/legacy_discovery.zip HDR/wifi_fix.zip
						
						info "HDR fixes applied for Yuzu! HDR should now work as expected."
					else
						echo -e "Copying save data for Yuzu...\n"
						cp -r HDR/save_data $HOME/.local/share/yuzu/nand/user/save/0000000000000000/*/01006A800016E000/
						sleep 1
						
						echo -e "Copying legacy discovery for Yuzu...\n"
						cp HDR/legacy_discovery $HOME/.local/share/yuzu/sdmc/ultimate/arcropolis/config/*/*/
						sleep 1
						
						echo -e "Copying Wi-Fi fix for Yuzu...\n"
						cp HDR/subsdk9 $HOME/.local/share/yuzu/sdmc/atmosphere/contents/01006A800016E000/exefs/
						sleep 1
						
						echo -e "Cleaning up...\n"
						rm HDR/save_data.zip HDR/legacy_discovery.zip HDR/wifi_fix.zip
						
						info "HDR fixes applied for Yuzu! HDR should now work as expected."
					fi	
				fi
			
			elif [ "$Choice" == "Configure" ]; then
				if ! [ -f $ryujinx ]; then
					error "Ryujinx not found, please install it via EmuDeck and run it at least once."
				else			
					exec $ryujinx
				fi
				
			elif [ "$Choice" == "Configure_Yuzu" ]; then
				if ! [ -f $yuzu ]; then
					error "Yuzu not found, please install it via EmuDeck and run it at least once."
				else
					exec $yuzu
				fi
			
			elif [ "$Choice" == "Play" ]; then
				if ! [ -f $ultimate_ROM ]; then
					error "SSBU dump not found. Please place it in $HOME/Emulation/roms/switch/ and name it to ssbu.nsp"
				else
					exec $ryujinx $ultimate_ROM
				fi
			
			elif [ "$Choice" == "Play_Yuzu" ]; then
				if ! [ -f $ultimate_ROM ]; then
					error "SSBU dump not found. Please place it in $HOME/Emulation/roms/switch/ and name it to ssbu.nsp"
				else
					exec $yuzu $ultimate_ROM
				fi
			
			fi
		done
	
	elif [ "$Choice" == "Overclock" ]; then
		
		if [ -f "/usr/lib/modules/$(uname -r)/extra/gcadapter_oc.ko" ]; then
			if ( question "Overclocking module already exists. Would you like to uninstall?" ); then
			yes |
				get_sudo_password
				
				if [ $USER == "deck" ]; then
					sudo -Sp '' steamos-readonly disable <<<${sudo_password}
					undo_overclock
					sudo steamos-readonly enable
				else
					undo_overclock <<<${sudo_password}
				fi

				info "Uninstallation complete!"
			fi
		else
			get_sudo_password
			
			if [ $USER == "deck" ]; then
				# Disable the filesystem until we're done
				sudo -Sp '' steamos-readonly disable <<<${sudo_password}
				
				# Get pacman keys
				sudo pacman-key --init
				sudo pacman-key --populate archlinux holo

				# Install kernel headers and dev tools
				sudo pacman -S --needed --noconfirm base-devel "$(cat /usr/lib/modules/$(uname -r)/pkgbase)-headers"
				
				overclock

				# Lock the filesystem back up
				sudo steamos-readonly enable			
			else
				overclock <<<${sudo_password}
			fi

			info "Installation complete!"
		fi

# end of program
	fi # end of main menu
done
