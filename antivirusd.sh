#!/bin/bash
dir="$1"
malicious_dir="$2"
interval="$3"

echo "Antivirus daemon started."
echo "Source directory: $dir"
echo "Malicious files directory: $malicious_dir"
echo "interval: $interval seconds"

scan_directory() {
    for file in "$dir"/*
    do
        if [ -f "$file" ]
        then
            filename=$(basename "$file")
            extension="${filename##*.}"
            if [ "$extension" == "exe" ] || [ "$extension" == "bat" ] || [ "$extension" == "vbs" ] || [ "$extension" == "scr" ] || [ "$extension" == "ps1" ]
            then 
                echo "Malicious file detected: $filename"
                cp "$file" "$malicious_dir/"
                rm "$file"
            else 
                if grep -qiE "virus|trojan|malware|worm|ransomware" "$file"
                then
                    echo "Malicious content detected in file: $filename"
                    cp "$file" "$malicious_dir/"
                    rm "$file"
                fi
            fi
        fi
    done
}

if [ ! -f directory-info.last ]
then 
    echo "No previous directory info found.Scanning directory for the first time."
    scan_directory
    ls -l "$dir" > directory-info.last 
fi

while true
 do
    sleep "$interval"
    ls -l "$dir" > directory-info.new
    if diff -q directory-info.last directory-info.new > /dev/null
    then
        echo "No changes detected in the directory."
    else
        echo "Changes detected in the directory."
        scan_directory
        cp directory-info.new directory-info.last
    fi
done