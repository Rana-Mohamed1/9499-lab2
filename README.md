Simple Antivirus Daemon
Overview
This project implements a simple antivirus daemon using Bash shell scripts on Ubuntu.
The antivirus daemon monitors a source directory for changes. When a change is detected, it scans the files in the directory and checks whether a file is malicious based on its file extension or its content.
If a malicious file is detected, it is copied to the `malicious` directory and then deleted from the source directory.
The project also includes a restore tool that allows the user to review quarantined files and either restore them, permanently delete them, or leave them as they are.
Folder Hierarchy
Lab2/
├── Makefile
├── README.md
├── antivirusd.sh
├── restore.sh
├── directory-info.last
├── directory-info.new
├── malicious
└── source_directory

Files and Directories:

1. antivirusd.sh: Monitors and scans the source directory for malicious files.
2. restore.sh: Allows the user to review and restore or delete quarantined files.
3. Makefile: Provides targets for running the antivirus and restore tools and creating the malicious directory.
4. directory-info.last: Stores information about the directory from the previous scan.
5. directory-info.new: Stores information about the directory from the latest check.
6. malicious: Stores files that are detected as malicious.
7. source_directory: The directory monitored by the antivirus daemon.
8. README.md: Contains information and instructions for the project.

Prerequisites
The project requires Ubuntu and Bash.
The following tools are required:
1. Bash
2. GNU Make

Installation on Ubuntu
Update the package list:
sudo apt update

Install GNU Make:
sudo apt install make

Check that Make is installed:
make --version


Running the Project
Step 1: Open the Project Directory
Open a terminal and navigate to the project directory:
cd ~/Downloads/Lab2

Step 2: Give Execute Permission
Make the shell scripts executable:
chmod +x antivirusd.sh
chmod +x restore.sh

Step 3: Prepare the Malicious Directory
Run the Makefile pre-build target:
make target3
This creates the `malicious` directory if it does not already exist.

Step 4: Run the Antivirus
Run:
make target1
This starts the antivirus daemon with:

Source directory: `source_directory`
 Malicious directory: `malicious`
 Scan interval: 5 seconds

The daemon continues monitoring the directory until it is stopped. To stop the daemon, press: Ctrl + C

Step 5: Run the Restore Tool
Run:
make target2
The restore tool displays the quarantined malicious files and allows the user to:
1. Restore a file to the source directory.
2. Permanently delete a file.
3. Leave the file as-is.

Running the Scripts Directly
The antivirus can also be run directly:
./antivirusd.sh source_directory malicious 5

The restore tool can be run directly:
./restore.sh source_directory malicious

Flagged Extensions and Keywords
The flagged file extensions and malicious keywords are defined in `antivirusd.sh` inside the `scan_directory()` function.

Flagged Extensions
The script checks the file extension using the following list:
.exe, .bat, .vbs, .scr, .ps1.

The extension check is implemented using the following condition in `antivirusd.sh`:
if [ "$extension" = "exe" ] || [ "$extension" = "bat" ] || [ "$extension" = "vbs" ] || [ "$extension" = "scr" ] || [ "$extension" = "ps1" ]

Flagged Keywords
The script also checks the file contents for the following keywords: virus,trojan,malware,worm,ransomware.

The keyword check is implemented using:
grep -qiE "virus|trojan|malware|worm|ransomware" "$file"

The options used with grep are:
-q (quiet): Does not display the matching lines. It only checks whether a match exists.
-i (ignore case): Makes the search case-insensitive, so virus, Virus, and VIRUS are treated as the same.
-E (extended regular expression): Allows the use of | to mean OR between the keywords.
