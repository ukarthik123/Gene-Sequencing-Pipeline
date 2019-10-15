#1/bin/bash

for pFastqFile in fastq/*.fastq
do 
	echo "running $pFastqFile through mini map2"
	filename=$(basename "$pFastqFile")
	fname="${filename%.*}"

		../tools/Minimap2/minimap2 -ax map-ont ../tools/hg19.mmi $pFastqFile > bam/$fname"_19.sam"

		echo "********** converting to bam **********"
		../tools/samtools-1.9/samtools view -b bam/$fname"_19.sam" -o bam/$fname"_19.unsorted.bam"

		echo "********** sorting bam ****************"
		../tools/samtools-1.9/samtools sort bam/$fname"_19.unsorted.bam" -o bam/$fname"_19.sorted.bam"

		echo "********** indexing bam ***************"
		../tools/samtools-1.9/samtools index bam/$fname"_19.sorted.bam"

done
