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

echo "Overwriting local changes with repository changes."
cd $projectHome
git fetch --all
git reset --hard origin/master

echo "Working with source dir = $sourceDir and output dir = $outputDir"

echo "Entering the source dir : $sourceDir"
cd $sourceDir

files=`ls|grep $inputFileType`

echo "Clearing the output directory $outputDir"
rm -r $outputDir/*$outputFileType

for file in $files
do
    fileToBeIgnored=`cat ignoreFileNameList|grep "$file"|wc -l`
    if [ $fileToBeIgnored -eq "0" ] then
        echo "FileName $file present in ignore file, hence ignoring it."
    elif
        echo "Assembling file $file."
        fileName=`echo $file|awk -F "." '{print $1}'`
        outputFile="$fileName.$outputFileType"
        nasm -o $outputDir/$outputFile -f bin ./$file
    fi
done