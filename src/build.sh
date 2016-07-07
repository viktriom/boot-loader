#!/bin/bash

#  build.sh
#  os
#
#  Created by Vivek Tripathi on 29/06/16.
#

inputFileType=".asm"
outputFileType=".bin"
sourceDir="/home/pi/dev/wrk/os/src"
outputDir="/home/pi/dev/wrk/os/bin"
projectHome="/home/pi/dev/wrk/os"
ignoreFileNameList="/home/pi/dev/wrk/os/ignore.list"
shouldPullFromRepo=" "


if [ $# -gt 0 ]; then
    shouldPullFromRepo=$1
else
    echo "-----------------------------------------------------"
    echo "No command line parameter provided, source files will not be refreshed."
    echo "Provide pull as the first command line parameter to pull the changes from the remote repo."
    echo "Be mindfull that all the changes will be overwritten with remote repo while pulling."
    echo "NO CHANGES WILL BE PULLED"
    echo "-------------------------------------------------------"
fi

if [ $shouldPullFromRepo -eq "pull" ]; then
    echo "Pulling sources form repo, local changes will be overwritten with repository changes."
    cd $projectHome
    git fetch --all
    git reset --hard origin/master
else
    echo "INCORRECT first parameter provided."
    echo "The firt parameter should be \"pull\" if you want the script to overwrite the local sources with remote repo data."
fi

echo "Working with source dir = $sourceDir and output dir = $outputDir"

echo "Entering the source dir : $sourceDir"
cd $sourceDir

files=`ls|grep $inputFileType`

echo "Clearing the output directory $outputDir"
rm -r $outputDir/*$outputFileType

for file in $files
do
    fileToBeIgnored=`cat $ignoreFileNameList|grep "$file"|wc -l`
    if [ $fileToBeIgnored -eq "0" ]; then
        echo "Assembling file $file."
        fileName=`echo $file|awk -F "." '{print $1}'`
        outputFile="$fileName.$outputFileType"
        nasm -o $outputDir/$outputFile -f bin ./$file
    else
        echo "FileName $file present in ignore file, hence ignoring it."
    fi
done