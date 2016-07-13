#!/bin/bash

#  build.sh
#  os
#
#  Created by Vivek Tripathi on 29/06/16.
#

echo "shell script path = $0"

baseDir=$(pwd)
echo "base dir = $baseDir"
projectHome=$(dirname "$baseDir")
echo "project home dir = $projectHome"
inputFileType=".asm"
outputFileType=".bin"
sourceDir="$projectHome/src"
outputDir="$projectHome/bin"
ignoreFileNameList="$sourceDir/ignore.list"
shouldPullFromRepo="no-pull"
shouldBuild="no-build"
shouldDebug="no-debug"


if [ $# -gt 0 ]; then
    shouldPullFromRepo=$1
    echo "value of shouldPullFromRepo = $shouldPullFromRepo"
    if [ $# -gt 1 ]; then
        shouldBuild=$2
    fi
    if [ $# -gt 2 ]; then
        shouldDebug=$3
    fi
else
    echo "------------------------------------------------------------------------------"
    echo "No command line parameter provided, source files will not be refreshed."
    echo "Provide pull as the first command line parameter to pull the changes from the remote repo."
    echo "Be mindfull that all the changes will be overwritten with remote repo while pulling."
    echo "NO CHANGES WILL BE PULLED"
    echo "------------------------------------------------------------------------------"
fi

echo "Parameters provided are : shouldPullFromRepo=$shouldPullFromRepo, shouldBuild=$shouldBuild, shouldDebug=$shouldDebug"

if [ "$shouldPullFromRepo" = "pull" ]; then
    echo "-------------------------Pulling in remote changes----------------------------"
    echo "Local changes will be overwritten with repository changes."
    cd $projectHome
    git fetch --all
    git reset --hard origin/master
    echo "-------------------------Done pulling the chagens------------------------------"
else
    echo "The firt parameter should be \"pull\" if you want the script to overwrite the local sources with remote repo data."
fi

echo "Working with source dir = $sourceDir and output dir = $outputDir"

if [ "$shouldBuild" = "build" ]; then
    echo "Entering the source dir : $sourceDir"
    cd $sourceDir

    files=`ls|grep $inputFileType`

    echo "Clearing the output directory $outputDir"
    rm -r $outputDir/*$outputFileType

    echo "-------------------------Assembling the source files----------------------------"

    for file in $files
    do
        fileToBeIgnored=`cat $ignoreFileNameList|grep "$file"|wc -l`
        if [ $fileToBeIgnored -eq "0" ]; then
            echo "Assembling file $file"
            fileName=`echo $file|awk -F "." '{print $1}'`
            outputFile="$fileName$outputFileType"
            nasm -o $outputDir/$outputFile -f bin ./$file
        else
            echo "FileName $file present in ignore file, hence ignoring it."
        fi
    done
    echo "-------------------------Done assembling the source files----------------------------"
else
    echo "The source files were not assembled again, using the existing binaries. Provide second parameter as 'build' if you wish to rebuild the changes."
fi

echo "==========================Starting the QEMU Simulator================"
if [ "$shouldDebug" = "debug" ]; then
    echo "QEMU Simulator started in debug mode."
    qemu-system-i386 -s -S $outputDir/bootLoaderPm.bin > qemuLog.log 2>&1 &
    echo "Simulator started in debug mode, now satrting gdb."
    gdb --command=gdb.cmd
else
    echo "Starting QEMU Simulator in non-debug mode."
    qemu-system-i386 $outputDir/bootLoaderPm.bin
fi