#!/bin/bash

TOOLS_DIR=~/hacking/tools/
GO_BIN=~/go/bin/
USR_LOCAL_BIN=/usr/local/bin



# Install tools or binaries based on the OS using the package manager
install_based_on_os()
{
	# Verify the running OS
	if [[ "$OSTYPE" == "darwin"* ]]
	then
		brew install go > /dev/null 2>&1
		brew install nmap > dev/null 2>&1
	else
		sudo apt install golang
		sudo apt install nmap
	fi
}            


# Install tools written in go
install_go_tools()
{
	# Create an array with the tools repositories that will be installed
	declare -a go_repositories=("github.com/ffuf/ffuf@latest"
					 "github.com/tomnomnom/waybackurls@latest"
					 "github.com/tomnomnom/httprobe@latest"
					 "github.com/tomnomnom/assetfinder@latest"
					 "github.com/hahwul/dalfox/v2@latest"
					 "github.com/michenriksen/aquatone@latest"
					 "github.com/OWASP/Amass/v3/...@latest"
					 "github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest")

	# Start iterating over the repositories array
	for repo in "${go_repositories[@]}"
	do
		# Get the tool name using cut
		tool_name=$(echo "$repo" | cut -d "/" -f 3 | cut -d "@" -f 1)

		# Verify if the binary already exists on /usr/local/bin
		if [ -f "$USR_LOCAL_BIN/$tool_name" ]
		then
			echo "$tool_name already installed"
		else
			echo "Installing $tool_name"
			go install "$repo"
		fi
	done

	sudo mv $GO_BIN/* $USR_LOCAL_BIN
	
}

# Install metasploit
install_metasploit()
{
  curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  chmod 755 msfinstall && \
  ./msfinstall
  # Remove the file left behind
  rm msfinstall
}

# Clone tools or other type of GitHub repositories to ~/hacking/tools
clone_repositories()
{
	# Create the array containing the repositories links
	declare -a repositories=("https://github.com/sqlmapproject/sqlmap.git"
						 "https://github.com/danielmiessler/SecLists")
	
	# Iterate over the array
	for i in "${repositories[@]}"
	do
		# Clone the repos to the desired location (~/hacking/tools/)
		git  -C "$TOOLS_DIR" clone "$i" > /dev/null 2>&1
	done

}



# Create the ~/hacking/tools
mkdir -p $TOOLS_DIR

#Functions being called

install_based_on_os

install_go_tools

clone_repositories

install_metasploit

