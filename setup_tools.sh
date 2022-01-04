#!/bin/bash

TOOLS_DIR=~/hacking/tools/
GO_BIN=~/go/bin/

install_go()
{
	if [[ "$OSTYPE" == "darwin"* ]]
	then
		brew install go > /dev/null 2>&1
	else
		sudo apt install go
	fi
}            

install_go_tools()
{
	declare -a go_repositories=("github.com/ffuf/ffuf@latest"
					 "github.com/tomnomnom/waybackurls@latest"
					 "github.com/tomnomnom/httprobe@latest@latest"
					 "github.com/tomnomnom/assetfinder"
					 "github.com/hahwul/dalfox/v2@latest"
					 "github.com/michenriksen/aquatone@latest"
					 "github.com/OWASP/Amass/v3/...@latest"
					 "github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest@latest")

	for i in "${go_repositories[@]}"
	do
		go install "$i"
	done

	sudo mv $GO_BIN/* /usr/local/bin
	
}

install_metasploit()
{
  curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  chmod 755 msfinstall && \
  ./msfinstall
}

clone_repositories()
{
	declare -a repositories=("https://github.com/sqlmapproject/sqlmap.git"
						 "https://github.com/danielmiessler/SecLists")
	
	for i in "${repositories[@]}"
	do
		git  -C "$TOOLS_DIR" clone "$i" > /dev/null 2>&1
	done

}




mkdir -p $TOOLS_DIR

install_go

install_go_tools

clone_repositories

install_metasploit
