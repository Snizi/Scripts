#!/bin/bash

# Add Kali Linux repository to sources list
add_kali_repo() {
  echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" | tee /etc/apt/sources.list.d/kali.list
}

# Add Kali Linux GPG key
add_kali_gpg_key() {
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ED444FF07D8D0BF6
}

# Update package manager cache
update_package_manager() {
  apt-get update
}

# Install bug bounty tools
install_bug_bounty_tools() {
  apt-get install -y amass dirb gobuster whatweb ffuf hydra john nmap burpsuite crunch mimikatz metasploit-framework crackmapexec dnsenum hakrawler arjun rdesktop tightvncserver xtightvncviewer wordlists wpscan sqlmap proxytunnel enum4linux evil-winrm hashcat
}

# Install Google Chrome
install_chrome() {
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  dpkg -i google-chrome-stable_current_amd64.deb
  apt-get install -f
  rm google-chrome-stable_current_amd64.deb
}

# Install Discord
install_discord() {
  wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
  dpkg -i discord.deb
  apt-get install -f
  rm discord.deb
}

# Install Visual Studio Code
install_vscode() {
  wget -O vscode.deb "https://go.microsoft.com/fwlink/?LinkID=760868"
  dpkg -i vscode.deb
  apt-get install -f
  rm vscode.deb
}

# Make the ubuntu dock cleaner and at the bottom
format_dock() {
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false 
    gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false 
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
}

# Main function
main() {
  add_kali_repo
  add_kali_gpg_key
  update_package_manager
  install_bug_bounty_tools
  install_chrome
  install_discord
  install_vscode
  format_dock
}

main
