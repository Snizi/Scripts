#! /bin/bash


CURRENT_DT=$(date +"%Y-%m-%d-%T")
ROOTS_FILE=$1
COMPANY_FOLDER=~/recon/"$2"


run_amass(){
    amass enum -silent -brute -w ~/tools/Wordlists/riot_subs.txt -max-dns-queries 3000 -active  -d "$domain" -o "$current_folder"/amass.txt
}

run_sublister(){
    python3 ~/tools/Sublist3r/sublist3r.py -d "$domain" -t 50 -v -o "$current_folder"/sublister.txt > /dev/null
}

run_assetfinder(){
    assetfinder --subs-only "$domain" > "$current_folder"/assetfinder.txt
}

merge_domains(){
    cat "$current_folder"/assetfinder.txt "$current_folder"/amass.txt "$current_folder"/sublister.txt | anew "$current_folder"/merged-domains.txt
}

run_massdns(){
    cat "$current_folder"/merged-domains.txt | massdns -r ~/tools/dnsvalidator/resolvers.txt -t A -o L -w "$current_folder"/massdns_output.txt
}

run_dnsgen(){
    cat "$current_folder"/massdns_out.txt | dnsgen - | massdns -r ~/tools/dnsvalidator/resolvers.txt -t A -o L -w "$current_folder"/permutated-domains.txt
}

run_httprobe(){
    cat "$current_folder"/permutated-domains | httprobe -c 50 -t 3000 >> "$current_folder"/live-hosts.txt
}

run_aquatone(){
    cat "$current_folder"/live-hosts.txt | aquatone -out "$current_folder" -ports xlarge -silent
}

run_dirsearch(){
    python3 ~/tools/dirsearch/dirsearch.py -l "$current_folder"/live-hosts.txt -e .* -w ~/tools/Wordlists/fastdir.txt --format=simple -o "$current_folder"/dirsearch -t 50 
}

while read domain; do
    current_folder="$COMPANY_FOLDER"/"$CURRENT_DT"/"$domain"
    mkdir -p "$current_folder"
    run_amass
    run_sublister
    run_assetfinder
    merge_domains
    run_massdns
    run_dnsgen
    run_httprobe
    run_dirsearch
    run_aquatone
done < "$ROOTS_FILE"



