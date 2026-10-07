#!/bin/bash
dir="$1"
malicious_dir="$2"
scan_directory() {
    for file in "$dir"/*
    do
        if [ -f "$file" ]
        then
            filename=$(basename "$file")
            extension="${filename##*.}"
            if [ "$extension" == "exe" ] || [ "$extension" == "bat" ] || [ "$extension" == "vbs" ] || [ "$extension" == "scr" ] || [ "$extension" == "ps1" ]
            then 
                echo "$filename is malicious and it is DELETED"
                cp "$file" "$malicious_dir/"
                rm "$file"
            else 
                if grep -qiE "virus|trojan|malware|worm|ransomware" "$file"
                then
                    echo "$filename is malicious and it is DELETED"
                    cp "$file" "$malicious_dir/"
                    rm "$file"
                fi
            fi
        fi
    done
}
mkdir -p "$malicious_dir"
scan_directory