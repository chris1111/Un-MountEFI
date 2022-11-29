# By chris1111
# A simple Applescript to (Un)Mount EFI on macOS Ventura 13
# Version "1.0" (Un)Mount EFI Ventura Copyright (c) 2022, chris1111 All right reserved
# MountEFI is based on CloverPackage MountESP script (Credit: Rehabman).
set theAction to button returned of (display dialog "
Welcome (Un)Mount EFI Ventura
Make a choice
" with icon note buttons {"Quit", "Unmount EFI", "Mount EFI"} cancel button "Quit" default button {"Mount EFI"})

if theAction = "Mount EFI" then
	set Volumepath to paragraphs of (do shell script "ls /Volumes")
	set Diskpath to choose from list Volumepath with prompt "
Choose the Disk to Mount the EFI partition
Then press the OK button" OK button name "OK"
	if Diskpath is false then
		display dialog "Quit Mount EFI" with icon note buttons {"EXIT"} default button {"EXIT"}
		
		return
		
		return (POSIX path of Diskpath)
	end if
	try
		delay 1
		
		set file_list to ""
		set the_command to quoted form of POSIX path of (path to resource "MountEFI" in directory "MountEFI")
		repeat with file_path in Diskpath
			set file_list to file_list & " " & quoted form of POSIX path of file_path
		end repeat
		set the_command to the_command & " " & file_list
		try
			
			do shell script the_command with administrator privileges
			do shell script "afplay '/System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds/System/Volume Mount.aif' &> /dev/null &"
			display alert "Mount EFI Partition on Volume" message (Diskpath as text) buttons "Done" default button "Done" giving up after 3
		end try
	end try
end if
if theAction = "Unmount EFI" then
	set Volumepath to paragraphs of (do shell script "ls /Volumes")
	set Diskpath to choose from list Volumepath with prompt "
Choose the EFI partition to Unmount
Then press the OK button" OK button name "OK"
	if Diskpath is false then
		display dialog "Quit Eject EFI" with icon note buttons {"EXIT"} default button {"EXIT"}
		
		return
		
		return POSIX path of Diskpath
	end if
	try
		do shell script ¬
			"diskutil unmount /Volumes/\"" & Diskpath & "\""
		do shell script "afplay '/System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds/System/Volume Unmount.aif' &> /dev/null &"
		display alert "Umount Partition" message (Diskpath as text) buttons "Done" default button "Done" giving up after 3
	end try
end if
