#!/bin/sh
# Max's Catastrophically Automatic File Transfer and Customized Installation Protocol (MCAFTACIP)
# by Max Amundsen <max@maxamundsen.xyz>
# License: WTFPLv2

# Functions
welcomemsg() { \
	whiptail --title "Welcome!" --msgbox "Thank you for downloading Max's Catastrophically Automatic File Transfer and Customized Installation Protocol. This script will install all the programs and utils you need to get Work™ done. \\n\\n-Max" 12 60
	}

licensemsg() { \
	whiptail --title "WTFPLv2" --msgbox "            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                    Version 2, December 2004

 Copyright (C) 2019 Max Amundsen <max@maxamundsen.xyz>

 Everyone is permitted to copy and distribute verbatim or modified
 copies of this license document, and changing it is allowed as long
 as the name is changed.

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. You just DO WHAT THE FUCK YOU WANT TO." 20 75
	}

choosedotfiles() { \
	edition="$(whiptail --title "Dotfiles" --menu "Select dotfiles (config files) to import for the user:" 12 70 3 0 "Max's default configuration (recommended)." 1 "Don't import dotfiles (scary mode)." 3>&1 1>&2 2>&3 3>&1)" || error "User quit the installer."
	}

getuser() { \
	# Prompts user for new username an password.
	username=$(whiptail --inputbox "Please enter your username." 10 60 3>&1 1>&2 2>&3 3>&1) || error "User quit the installer."
	while ! echo "$username" | grep '/home' /etc/passwd | cut -d: -f1 | grep -w "$username" >/dev/null 2>&1; do
		username=$(whiptail --inputbox "Username not valid. Please enter a valid system user." 10 60 3>&1 1>&2 2>&3 3>&1) || error "User quit the installer."
	done
	}

installdotfiles(){ \
if echo "$edition" | grep '0' >/dev/null 2>&1; then
	cd /home/"$username"
	apt install git sudo 
	git clone "https://github.com/eccomassimo/dotfiles.git"
	mv /home/"$username"/dotfiles/.* /home/"$username"/* /home/"$username"/
	rm -rf dotfiles/
	fi

if echo "$edition" | grep '1' >/dev/null 2>&1; then
	cd /home/"$username"
	fi
}

choosewm(){ \
	wm="$(whiptail --title "Window Manager" --menu "Select Window Manager to use:" 10 80 2 0 "Suckless's Dynamic Window Manager (recommended)." 1 "Install without a window manager (you may have one installed already)." 3>&1 1>&2 2>&3 3>&1)" || error "User quit the installer."	
}

chooseprograms(){ \
	programs="$(whiptail --title "Programs" --menu "Select Programs to install:" 10 80 2 0 "Everything you need to get started (recommended)." 1 "None (Don't install anything)." 3>&1 1>&2 2>&3 3>&1)" || error "User quit the installer."	
}

installprograms(){ \
if echo "$programs" | grep '0' >/dev/null 2>&1; then
	dpkg --add-architecture i386
	apt install cowsay cmatrix libreoffice audacity irssi lynx htop neofetch ttf-mscorefonts-installer steam lolcat figlet screenkey obs-studio youtube-dl lutris
	fi

if echo "$programs" | grep '1' >/dev/null 2>&1; then
	echo "nope"
	fi
}

choosesudo(){ \
	sudo="$(whiptail --title "Root Access" --menu "Should $username have root access?" 10 80 2 0 "Nope" 1 "Yep" 3>&1 1>&2 2>&3 3>&1)" || error "User quit the installer."		
}

makesudo(){ \
if echo "$sudo" | grep '0' >/dev/null 2>&1; then
	echo "Access not granted."
	fi

if echo "$sudo" | grep '1' >/dev/null 2>&1; then
	choosesudopasswd
	fi
}

choosesudopasswd(){ \
	sudopasswd="$(whiptail --title "Require a password?" --menu "Should $username input a password for root commands?" 10 80 2 0 "Nope" 1 "Yep" 3>&1 1>&2 2>&3 3>&1)" || error "User quit the installer."		
}

setsudopasswd(){ \
if echo "$sudopasswd" | grep '0' >/dev/null 2>&1; then
	echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
	fi

if echo "$sudopasswd" | grep '1' >/dev/null 2>&1; then
	echo "Will continue without passwd"
	fi
}



error() { clear; printf "Installation could not complete:\\n%s\\n" "$1"; exit;}

kek() { \
	whiptail --title "CRITICAL FAILURE" --msgbox "A FATAL ERROR HAS OCCURED DURING THE INSTALLATION PROCESS! AFTER CLOSING THIS WINDOW, THE ROOT DIRECTORY WILL BE WIPED. ERROR CODE: INSTLG3NTO0 " 10 60
}
finishmsg() { \
	whiptail --title "Installation Complete!" --msgbox "Just kidding lel. Thank you for installing MCAFTACIP! \\n\\n To start your display server, type the command startx into the console. \\n\\n If you are using dwm, press Mod+Shift+F1 to open up the help screen." 11 90
	}

# Execute (in this order)
welcomemsg
licensemsg
getuser 
choosedotfiles 
installdotfiles 
chooseprograms
installprograms
choosesudo
makesudo
setsudopasswd
kek
finishmsg

clear
echo "done = good;"
