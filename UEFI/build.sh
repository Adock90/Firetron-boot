#!/bin/bash


Help(){
	printf "FiretronBuild Support\n\nbuild.sh [architecture]\n\tx86: builds everything for x86 format cpus such as PC chips from Intel and AMD\n\tarm: builds for arm chips such as Apple M-Series chips and Qualcomm Snapdragon Chips\n"
}

if [ "$1" == "" ] || [ "$1" == "-h" ];
then
	echo "no args provided"
	Help
elif [ "$1" == "x86" ] || [ "$1" == "x86_64" ];
then
	cd build/x86_64/
	./build.sh
elif [ "$1" == "arm" ] || [ "$1" == "arm64" ];
then
	echo "not done"
else
	Help
fi

