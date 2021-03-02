#!/bin/bash

#I'm trying to start breaking up the processes in the script, so this just the metadata tools that are run on the files
#It requires inputs gathered from the make_dirs_config.sh though, so it's not really a stand a lone script. make_dirs has to be run first.

#User prompts will call the functions from the config file
source HMSG_auto.config

#if statement that checks for the variables assigned in the make_dirs script, and if they're not there, redirect to that script?
if [ -z "${ArtFile+x}" ]; 
	then echo "The path to the Artwork File is not set! Run make_dirs.sh to assign an Artwork File?"
	select No_ArtFile_option in "yes" "no" 
	do
		case $No_ArtFile_option in
			yes) echo "Running make_dirs..." && source make_dirs.sh
			break;;
			no) echo "Quitting now..." && exit 1 ;; 
			esac
done; 
else echo "ArtFile is set to '$ArtFile'"; fi

if [ -z "${SDir+x}" ]; 
	then echo "The path to the Staging Directory is not set! Run make_dirs.sh to assign SDir?"
	select No_ArtFile_option in "yes" "no" 
	do
		case $No_ArtFile_option in
			yes) echo "Running make_dirs..." && source make_dirs.sh
			break;;
			no) echo "Quitting now..." && exit 1 ;; 
			esac
done;
else echo "Staging Directory is set to '$SDir'"; fi

#Prompts user input for path to hard drive (or other carrier), defines that path as "$Device"
diskutil list
echo -e "\n*************************************************\n
Input the path to the device - Should be '/dev/disk#' "
read -e Device
while [[ -z "$Device" ]] ; do
	echo -e "\n*************************************************\n
Input the path to the device - Should be '/dev/disk#' " && read -e Device
done
echo "The device path is $Device"

#Prompts user that disktype is being run? Not sure about this...
echo -e "\n*************************************************\n
The following prompts will ask about running command line applications. The responses to the prompts will be saved, and applications will be run once all prompts have been answered.
\n*************************************************\n
Run disktype on $Device (Choose a number 1-2)"
select Disktype_option in "yes" "no"
do
	case $Disktype_option in
		yes) Run_disktype=1
			#disktype
			#Should run disktype on device path and then pipe output to tee, copy output to Staging Directory, Tech Specs dir in ArtFile and appendix in ArtFile
			break;;
		no) Run_disktype=0
break;;
	esac
done  

#Prompts user to tranfer files to Staging Driectory
echo -e "\n*************************************************\n
Copy all files from the volume to the staging directory?"
select Run_Copyit in "yes" "no"
do
	case $Run_Copyit in
		yes) Run_Copyit=1
			break;;
		no) Run_Copyit=0
break;;
	esac
done  

#Prompts user to run metadata tools
echo -e "\n*************************************************\n
This is the final prompt, applications will run after this response!
\n*************************************************\n
Run metadata tools (tree, siegfried, MediaInfo, Exiftool, framemd5, and qctools) on files copied to $SDir (Choose a number 1-2)"
select Meta_option in "yes" "no"
do
	case $Meta_option in
		yes) Run_meta=1
			break;;
		no) Run_meta=0
break;;
	esac
done  

#The following if statements will check the variable assignements from above to run the desired functions.
#Next step is to change these functions in to bash scripts I think

if [ $Run_disktype = 1 ] 
then disktype
fi

if [ $Run_Copyit = 1 ] 
then CopyitVolumeStaging
fi

if [ $Run_meta = 1 ] 
then RunTree; RunSF; RunMI; RunExif; Make_Framemd5; Make_QCT 
fi
 
figlet Fin. 
