#!/bin/bash


for pFast5Path in single_fast5/*
do
   if [ -d "$pFast5Path" ]
   then
    echo "Combining single Fast5"
        python3 ../tools/Fast5-to-Fastq/fast5_to_fastq.py $pFast5Path > fastq/$(basename "$pFast5Path").fastq 
   fi
done
