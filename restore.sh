#!/bin/bash
dir="$1"
malicious_dir="$2"

echo "Source directory: $dir"
echo "Malicious files directory: $malicious_dir"

if [ -z "$(ls -A "$malicious_dir")" ]
then
    echo "No malicious files to review."
    exit 0
fi

files=("$malicious_dir"/*)
echo "Malicious files found in the directory:"
for i in "${!files[@]}"
do
    echo "$((i+1)). $(basename "${files[$i]}")"
done

echo "Enter file number"
read choice 
if [ "$choice" -lt 1 ] || [ "$choice" -gt "${#files[@]}" ]
then
    echo "Invalid file number. Exiting."
    exit 1
fi
selected_file="${files[$((choice-1))]}"
echo "Selected file: $(basename "$selected_file")"

echo "1.Restore this file back into source directory"
echo "2.Permanently delete this file from malicious files directory"
echo "3.Leave this file as-is"
echo "Enter your choice"
read action_choice
if [ "$action_choice" = "1" ]
then 
    mv "$selected_file" "$dir/"
    echo "$(basename "$selected_file")" >> whitelist.txt
    echo "Restored $(basename "$selected_file") to $dir."
elif [ "$action_choice" = "2" ]
then
    rm "$selected_file"
    echo "$(basename "$selected_file") Permanently deleted ."
elif [ "$action_choice" = "3" ]
then
    echo "Leaving $(basename "$selected_file") as-is."
    echo "No changes made to the file."
else
    echo "Invalid choice. Exiting."
    exit 1
fi