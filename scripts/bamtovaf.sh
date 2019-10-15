#!/bin/bash

for pBamFile in bam/*.sorted.bam
do
	echo "******* bam to txt ********"
	../tools/samtools-1.9/samtools mpileup -f ../tools/hg19.fa $pBamFile > vaf.$(basename "$pBamFile").txt
done
