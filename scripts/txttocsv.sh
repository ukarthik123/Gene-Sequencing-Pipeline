#!/bin/bash

pCSV="Exp59_NTC03.csv"


printf "Bin,# Variants,# Total Reads Mapped,%% VAF\n" >> $pCSV
	for pTxtFile in vaf/*.txt
	do
		declare -i totREADS
		declare -i Ts
		declare -i ts
		declare -i totTs
		totREADS=`grep -e "226252135" $pTxtFile | cut -b 14-18`
		grep -e "226252135" $pTxtFile > temp.txt
		Ts=`grep 'T' -o temp.txt | wc -l`
		ts=`grep 't' -o temp.txt | wc -l`
		totTs=Ts+ts
		RESULT=$(echo "$totTs/$totREADS*100" | bc -l)
echo "********************************************************"

echo "*********** printing CSV File **************************"

filename=$(basename "$pTxtFile")
fname=$filename | cut -d '_' -f 1 
printf "%s," $fname >> $pCSV
printf "%s," $totTs >> $pCSV
printf "%s," $totREADS >> $pCSV
printf "%0.5f\n" $RESULT >> $pCSV
	done

echo "*********** program done *******************************"
