#MOLGENIS walltime=05:59:00 mem=10gb ppn=1

#Parameter mapping
#string chr
#string inputDirectory
#string outputDirectory
#string rawdataDirectory
#string resultsDirectory
#string jobsDirectory
#string concordanceDirectory
#string CompareGenotypeCallsVersion
#string listOfSamplesToRemove

# Let's do something
echo "${inputDirectory}"
echo "${outputDirectory}"
echo "${resultsDirectory}"
echo "${listOfSamplesToRemove}"
echo "${chr}"

module load ${CompareGenotypeCallsVersion}

mkdir -p "${concordanceDirectory}"

echo -e "data1Id\tdata2Id" > ${concordanceDirectory}/samples.chr${chr}.txt
awk 'FNR > 2{print $2"\t"$2}' ${rawdataDirectory}/chr${chr}.sample >> ${concordanceDirectory}/samples.chr${chr}.txt

awk -F ' ' 'BEGIN {start=0;end=0};{if(NR==1){start=NF}};END {var=FILENAME; n=split(var,a,/\//); print a[n],"firstRowCount="start,"lastRowCount="NF}' ${rawdataDirectory}/chr${chr}.gen > ${concordanceDirectory}/chr${chr}.gen.count.before

#
java -XX:ParallelGCThreads=1 -Djava.io.tmpdir=${concordanceDirectory} -Xmx9g -jar ${EBROOTCOMPAREGENOTYPECALLS}/CompareGenotypeCalls.jar \
-d1 "${rawdataDirectory}/chr${chr}" \
-D1 GEN \
-d2 "${resultsDirectory}/chr${chr}" \
-D2 GEN \
-c1 "${chr}" \
-s ${concordanceDirectory}/samples.chr${chr}.txt \
--output "${concordanceDirectory}/concordance_chr${chr}"

awk -F ' ' 'BEGIN {start=0;end=0};{if(NR==1){start=NF}};END {var=FILENAME; n=split(var,a,/\//); print a[n],"firstRowCount="start,"lastRowCount="NF}' ${resultsDirectory}/chr${chr}.gen > ${concordanceDirectory}/chr${chr}.gen.count.after
