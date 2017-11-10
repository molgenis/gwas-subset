#MOLGENIS walltime=01:59:00 mem=1gb ppn=1
#Parameter mapping
#list chr
#string inputDirectory
#string outputDirectory
#string rawdataDirectory
#string resultsDirectory
#string jobsDirectory
#string concordanceDirectory
#string listOfSamplesToRemove

# Let's do something                 
echo "${inputDirectory}"
echo "${outputDirectory}"
echo "${resultsDirectory}"
echo "${jobsDirectory}"
echo "${listOfSamplesToRemove}"
echo "${chr}"



rm -f "${resultsDirectory}"/QcReport.txt

echo "# NUMBER OF SAMPLES BEFORE AND AFTER SAMPLE REMOVAL." >> ${resultsDirectory}/QcReport.txt

for i in {0..20}
do
	echo "chr$((${i}+1)):" >> ${resultsDirectory}/QcReport.txt
	grep 'Number of' ${jobsDirectory}/s2_removeSamples_${i}.out >> ${resultsDirectory}/QcReport.txt
done

echo "" >> ${resultsDirectory}/QcReport.txt
echo "# COLLUMN NUMBER BEFORE AND AFTER SAMPLE REMOVAL." >> ${resultsDirectory}/QcReport.txt
echo "# Number of removes collumns should (number of removed samples *3)" >> ${resultsDirectory}/QcReport.txt

for i in "${chr[@]}"
do
	echo "chr${i}" >> ${resultsDirectory}/QcReport.txt
	cat ${concordanceDirectory}/chr${i}.gen.count.before >> ${resultsDirectory}/QcReport.txt
	cat ${concordanceDirectory}/chr${i}.gen.count.after >> ${resultsDirectory}/QcReport.txt
done
