#MOLGENIS walltime=05:59:00 mem=10gb ppn=1

#Parameter mapping
#string chr
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
echo "${listOfSamplesToRemove}"
echo "${chr}"


mkdir -p "${concordanceDirectory}"

echo -e "data1Id\tdata2Id" > ${concordanceDirectory}/samples.chr${chr}.txt
awk 'FNR > 2{print $2"\t"$2}' ${rawdataDirectory}/chr${chr}.sample >> ${concordanceDirectory}/samples.chr${chr}.txt

awk -F ' ' 'BEGIN {start=0;end=0};{if(NR==1){start=NF}};END {print FILENAME,basename(FILENAME),"firstRowCount="start,"lastRowCount="NF}' ${rawdataDirectory}/chr${chr}.gen > ${concordanceDirectory}/chr${chr}.gen.count.before

#
EBROOTCOMPAREGENOTYPE='/groups/umcg-lifelines/tmp04/umcg-gvdvries/releaseTest/rawdata/CompareGenotypeCalls-1.7-SNAPSHOT'

java -jar ${EBROOTCOMPAREGENOTYPE}/CompareGenotypeCalls.jar \
-d1 "${rawdataDirectory}/chr${chr}" \
-D1 GEN \
-d2 "${resultsDirectory}/chr${chr}" \
-D2 GEN \
-c1 "${chr}" \
-s ${concordanceDirectory}/samples.chr${chr}.txt \
--output "${concordanceDirectory}/concordance_chr${chr}"

awk -F ' ' 'BEGIN {start=0;end=0};{if(NR==1){start=NF}};END {print FILENAME,"firstRowCount="start,"lastRowCount="NF}' ${resultsDirectory}/chr${chr}.gen > ${concordanceDirectory}/chr${chr}.gen.count.after
