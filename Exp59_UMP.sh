#!/bin/bash

module load samtools

# "*************************************************"
# "********* Specificity Experiment on old guppy ***"
# "********* By Karthik Ravi ***********************"
# "*************************************************"
# "********* Fast5 to VAF conversion Program *******"
# "*************************************************"
# "********* Please enter input parameters below *******"
# "*************************************************"
pHomeFolder="/Users/macserver/Desktop/nanopore"

# pTempFolder="KarthikSpecificity"
#  pFast5FilePath="$pHomeFolder/specificity/ExpX/fast5"

pTempFolder="Exp59_UMP"
pFast5FilePath="$pHomeFolder/specificity/Exp59_UMPED57_CSF_Specificity_071619_fast5"

# pFast5ControlFilePath="$pHomeFolder/specificity/Exp59_NTC03_Specificity_071619_fast5"
# "*************************************************"
# "*************************************************"
# "********* Setting environment variables *******"
# "*************************************************"
pOnt_fast5_apiFilePath="$pHomeFolder/tools/ont_fast5_api/ont_fast5_api/conversion_tools"
pFast5_to_FastqFilePath="$pHomeFolder/tools/Fast5_to_Fastq"
pHg19mmiFilePath="$pHomeFolder/tools/align"
pMinimap2FilePath="$pHomeFolder/tools/align/minimap2"
pSamtoolsFilePath="$pHomeFolder/tools/samtools/bin"
pAlignPath="$pHomeFolder/tools/align"
pToolGuppy="$pHomeFolder/tools/ont-guppy-cpu/bin/guppy_basecaller"
# "*************************************************"
# "********* Setting log files               *******"
# "*************************************************"
pResultFile="$pTempFolder/$pTempFolder.RESULTS"
# pCSV="$pTempFolder/$pTempFolder_NEW.csv"
 pCSV="karthik_UMP.csv"
pFastqlogFile="$pTempFolder/fast5_basecalled/$pTempFolder.fastq.log"
pPileuplogFile="$pTempFolder/vaf/$pTempFolder.Pileup.log"
clear
stdate=`date +%s`
date
echo "*************************************************"
echo "*************************************************"
echo "********* Experiment Folder: " $pTempFolder
echo "********* Fast5 FilePath: " $pFast5FilePath
echo "*************************************************"
if [  -f "$pFast5FilePath" ]; then
   echo "Error: Fast5FilePath - $pFast5FilePath does not exists"
   exit
fi
echo "*************************************************"
echo "********* Basecalling ***************************"
echo "*************************************************"
if [ !  -f "$pTempFolder" ]; then
#    rm -r $pTempFolder
 echo "Removing TempFolder"
fi

# mkdir $pTempFolder
# mkdir $pTempFolder/fast5_basecalled
mkdir $pTempFolder/fast5_single

printf "********* Experiment Folder: %s\n" $pTempFolder >> $pResultFile
printf "********* Fast5 FilePath: %s\n" $pFast5FilePath >> $pResultFile
printf "%s: RESULTS" $pTempFolder >> $pResultFile
printf "\nStart\n" >> $pResultFile

printf "Bin,# Variants,# Total Reads Mapped,Cumulative # Variants,Cumulative # Total Reads Mapped,Cumulative Tumor VAF,%% VAF\n" >> $pCSV

#  $pToolGuppy --input_path $pFast5FilePath --save_path $pTempFolder/fast5_basecalled --flowcell FLO-MIN106 --kit SQK-LSK109 --recursive -q 250 --fast5_out --num_callers 1 >> $pFastqlogFile 
# $pToolGuppy --input_path $pFast5FilePath --save_path $pTempFolder/fast5_basecalled --flowcell FLO-MIN106 --kit SQK-LSK109 --recursive -q 250 --fast5_out --num_callers 1 --x "cuda:0" 

date
echo "*************************************************"
echo "********* Step 2/5: Multi Fast5 to Single Fast5 conversion *******"
echo "*************************************************"

# python $pOnt_fast5_apiFilePath/multi_to_single_fast5.py -t 44 --i $pTempFolder/fast5_basecalled/workspace --s $pTempFolder/fast5_single 

date
echo "*************************************************"
echo "********* Step 3/5: Combine single Fast5 files into Fastq file  *******"
echo "*************************************************"

# mkdir $pTempFolder/fastq

# for pFast5Path in $pTempFolder/fast5_single/*
# do
#    if [ -d "$pFast5Path" ]
#    then
#     echo "Combining single Fast5"
#         python3 $pFast5_to_FastqFilePath/fast5_to_fastq.py $pFast5Path > $pTempFolder/fastq/$(basename "$pFast5Path").fastq 
#    fi
# done


date
echo "*************************************************"
echo "********* Step 3/5: Align: Fastq to BAM   *******"
echo "*************************************************"

# mkdir $pTempFolder/bam
# for pFastqFile in $pTempFolder/fastq/*.fastq
# do
#        echo "running $pFastqFile through minimap2"
#        filename=$(basename "$pFastqFile")
#        fname="${filename%.*}"

#              $pMinimap2FilePath/minimap2 -ax map-ont $pHg19mmiFilePath/hg19.mmi $pFastqFile > $pTempFolder/bam/$fname"_19.sam"

#           echo "*******   converting to bam   *******"
#            $pSamtoolsFilePath/samtools view -b $pTempFolder/bam/$fname"_19.sam"  -o $pTempFolder/bam/$fname"_19.unsorted.bam"


#           echo "*******   sorting bam   *******"
#            $pSamtoolsFilePath/samtools sort $pTempFolder/bam/$fname"_19.unsorted.bam" -o $pTempFolder/bam/$fname"_19.sorted.bam" 

#           echo "*******   indexing bam   *******"
#            $pSamtoolsFilePath/samtools index $pTempFolder/bam/$fname"_19.sorted.bam"

# done


date
echo "*************************************************"
echo "********* Step 4/5: BAM to TXT            *******"
echo "*************************************************"

# mkdir $pTempFolder/vaf
# for pBamFile in $pTempFolder/bam/*.sorted.bam
# do
#           echo "*******   bam to  txt   *******"
#   $pSamtoolsFilePath/samtools mpileup -Q 0 -f $pAlignPath/hg19.fa $pBamFile > $pTempFolder/vaf/$(basename "$pBamFile").txt  
# done

date
echo "*************************************************"
echo "********* Step 5/5: TXT to VAF            *******"
echo "*************************************************"
pVafPath="$pTempFolder/vaf"

declare -i culVar
declare -i culReads
declare -i culVaf

echo "*************************************************"
echo "******** printing CSV file **********************"
echo "*************************************************"

        for pTxtFile in $pVafPath/*.txt
        do
            declare -i totREADS
            declare -i Ts
            declare -i ts
            declare -i totTs
            totREADS=`grep -e "226252135" $pTxtFile  | cut -b 14-17`
            grep -e "226252135" $pTxtFile > $pTempFolder/temp.txt
            Ts=`grep 'T' -o $pTempFolder/temp.txt | wc -l`
            ts=`grep 't' -o $pTempFolder/temp.txt | wc -l`
            totTs=Ts+ts
            RESULT=$(echo "$totTs/$totREADS*100" | bc -l)

            printf "FINAL RESULT: \n" 
            printf "DEPTH: %s\n" $totREADS
            printf "VAF: %0.2f%%\n" $RESULT
            printf "%s DEPTH:%s\n" $pVafPath $totREADS >> $pTempFolder/$pTempFolder.RESULTS
            printf "%s VAF:%0.2f%%\n" $pVafPath $RESULT >> $pTempFolder/$pTempFolder.RESULTS

echo "Bin,# Variants,# Total Reads Mapped,Cumulative # Variants,Cumulative # Total Reads Mapped,Cumulative Tumor VAF,% VAF"

filename=$(basename "$pTxtFile")
x=$( echo "$filename" |cut -d\_ -f1 )
printf "%s," $x >> $pCSV 
printf "%s," $x 
printf "%s," $totTs >> $pCSV
printf "%s," $totTs
printf "%s," $totREADS >> $pCSV
printf "%s," $totREADS
culVar=$culVar+$totTs
printf "%s," $culVar >> $pCSV
printf "%s," $culVar
culReads=$culReads+$totREADS
printf "%s," $culReads >> $pCSV
printf "%s," $culReads
printf "%0.5f," $RESULT >> $pCSV
printf "%0.5f," $RESULT
printf "%0.5f\n" $RESULT >> $pCSV
printf "%0.5f\n" $RESULT
        done
echo "*************************************************"
printf "\nDone\n" >> $pTempFolder/$pTempFolder.RESULTS
date
enddate=`date +%s`
runtime=$((enddate-stdate))
runMinutes=$(echo "$runtime/60" | bc -l)

echo "*************************************************"
echo "Runtime in seconds: "$runtime
printf "Runtime in minutes: %0.2f\n" $runMinutes
echo "*************************************************"
echo "*************************************************"
echo "*************************************************"
echo "*************************************************"
echo "*********        Program End              *******"
echo "*************************************************"

