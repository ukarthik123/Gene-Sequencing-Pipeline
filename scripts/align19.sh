#!/bin/bash

module load samtools

for f in $(ls | grep $1)
do
echo "running $f through minimap2"
~/minimap2 -t 8 -ax map-ont /nfs/turbo/ckoschma1/NanoPoreLeo/analysis/wholegenomehelpers/hg19.mmi $f > ${f%.*}_19.sam
echo "converting to bam"
samtools view -b ${f%.*}_19.sam -o ${f%.*}_19.unsorted.bam
echo "sorting bam"
samtools sort ${f%.*}_19.unsorted.bam -o ${f%.*}_19.sorted.bam
echo "indexing bam"
samtools index ${f%.*}_19.sorted.bam
done

echo "ran all files" 
