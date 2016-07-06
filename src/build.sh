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

echo "Working with source dir = $sourceDir and output dir = $outputDir"

echo "Entering the source dir."
cd sourceDir;

files=`ls|grep $inputFileType`

echo "Clearing the output directory $outputDir"
rm -r $outputDir/*$outputFileType

for file in $files
do
    fileName=`echo $file|awk -F "." '{print $1}'`
    outputFile="$fileName.$outputFileType"
    nasm -o $outputDir/$outputFile -f bin ./$file
done