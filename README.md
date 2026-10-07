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
Bonus 1: Cron Job
Overview
the antivirus scanning process can also be run automatically using a cron job instead of using a script that runs continuously with a while loop.

The cron job runs the antivirus-cron.sh script every minute. The script performs one scan and then exits. Cron is responsible for running the script again at the next scheduled time.The cron job also uses sleep 23 so that the scan starts approximately at second 23 of every minute.

Prerequisites
Before configuring the cron job, make sure that:
1. The cron service is installed and running.
2. antivirus-cron.sh exists in the project directory.
3. The script has execute permission.
4. The source_directory and malicious directories exist.
5. The antivirus script has been tested manually before configuring cron.

Check that the cron service is running:
sudo systemctl status cron
If cron is not installed, install it using:
sudo apt update
sudo apt install cron

Start the cron service if necessary:
sudo systemctl start cron

Enable cron to start automatically when Ubuntu starts:
sudo systemctl enable cron

Antivirus Cron Script
The file antivirus-cron.sh performs one scan of the source directory.

Unlike antivirusd.sh, it does not contain an infinite loop or sleep command. Cron is responsible for scheduling the script repeatedly.

The script uses the same malicious file extensions and keywords as the main antivirus daemon.

Flagged extensions:.exe, .bat, .vbs, .scr, .ps1

Flagged keywords: virus, trojan, malware, worm, ransomware

The keyword search is case-insensitive.

If a malicious file is detected, it is copied to the malicious directory and then deleted from the source_directory.

Step-by-Step Cron Configuration:
Step 1: Give the Script Execute Permission

From the project directory, run:
chmod +x antivirus-cron.sh

Check the permission using:
ls -l antivirus-cron.sh

The file should have execute permission, for example:
-rwxrwxr-x

Step 2: Find the Correct Project Path
The cron job should use the absolute path to the project files.
For this project, the project directory is:
/home/rana-mohamed/Downloads/lab2

Step 3: Open the Crontab
Run: crontab -e

Add the following line:
* * * * * sleep 23; /home/rana-mohamed/Downloads/lab2/antivirus-cron.sh /home/rana-mohamed/Downloads/lab2/source_directory /home/rana-mohamed/Downloads/lab2/malicious

This means that cron starts the command every minute. The sleep 23 delays the execution for 23 seconds, so the antivirus scan starts approximately at second 23 of each minute.

Step 4: Save the Crontab
After adding the cron job, save and exit the editor.

To verify that the cron job was added successfully, run:
crontab -l
The antivirus cron line should be displayed.

Step 5: Test the Cron Job
Create a test file containing a malicious keyword:
echo "troJan" > source_directory/crontest.txt
Check that the file exists:
ls source_directory
Wait for the cron job to run.
After approximately one minute, check ls source_directory and ls malicious

The malicious file should be removed from source_directory and copied to malicious.
For example, crontest.txt should move from source_directory to malicious

This confirms that the cron job is running the antivirus scan automatically.

Cron Expression for the Third Friday of Every Month
The required time is 12:31 AM on every third Friday of the month.
A standard cron expression uses five fields:
minute hour day-of-month month day-of-week

For Friday at 12:31 AM, the basic expression is:
31 0 * * 5

However, this runs every Friday, not only the third Friday.

A third Friday always occurs between the 15th and 21st day of the month. Therefore, the cron job can run every Friday at 12:31 AM and use a condition to check whether the day of the month is between 15 and 21:

31 0 * * 5 [ "$(date +\%d)" -ge 15 ] && [ "$(date +\%d)" -le 21 ] && /home/rana-mohamed/Downloads/lab2/antivirus-cron.sh /home/rana-mohamed/Downloads/lab2/source_directory /home/rana-mohamed/Downloads/lab2/malicious

The \% is required because % has a special meaning inside a crontab command.

This condition ensures that the antivirus scan runs only when the Friday is between the 15th and 21st day of the month, which corresponds to the third Friday.

Important Note

Standard cron does not have a seconds field. Therefore, the requirement to run the antivirus scan every minute at approximately second 23 is implemented using:

* * * * * sleep 23; command

Cron starts the command every minute, and sleep 23 delays the antivirus scan by 23 seconds.
