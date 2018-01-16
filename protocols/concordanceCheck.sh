#MOLGENIS walltime=23:59:00 mem=10gb ppn=1

#Parameter mapping
#string chr
#string workDirectory
#string rawdataImputed
#string rawdataUnimputed
#string resultsImputed
#string resultsUnimputed
#string jobsDirectory
#string concordanceDirectory
#string compareGenotypeCallsVersion
#string listOfSamplesToRemove


module load ${compareGenotypeCallsVersion}

mkdir -p "${concordanceDirectory}"

echo -e "data1Id\tdata2Id" > ${concordanceDirectory}/samples.chr${chr}.txt
awk 'FNR > 2{print $2"\t"$2}' ${rawdataImputed}/chr${chr}.sample >> ${concordanceDirectory}/samples.chr${chr}.txt

awk -F ' ' 'BEGIN {start=0;end=0};{if(NR==1){start=NF}};END {var=FILENAME; n=split(var,a,/\//); print a[n],"firstRowCount="start,"lastRowCount="NF}' ${rawdataImputed}/chr${chr}.gen > ${concordanceDirectory}/chr${chr}.gen.count.imputed.before
awk -F ' ' 'BEGIN {start=0;end=0};{if(NR==1){start=NF}};END {var=FILENAME; n=split(var,a,/\//); print a[n],"firstRowCount="start,"lastRowCount="NF}' ${rawdataUnimputed}/chr${chr}.haps > ${concordanceDirectory}/chr${chr}.haps.count.unimputed.before

#
java -XX:ParallelGCThreads=1 -Djava.io.tmpdir=${concordanceDirectory} -Xmx9g -jar ${EBROOTCOMPAREGENOTYPECALLS}/CompareGenotypeCalls.jar \
-d1 "${rawdataUnimputed}/chr${chr}" \
-D1 SHAPEIT2 \
-d2 "${resultsUnimputed}/chr${chr}" \
-D2 SHAPEIT2 \
-s ${concordanceDirectory}/samples.chr${chr}.txt \
--output "${concordanceDirectory}/concordance_unimputed_chr${chr}"

java -XX:ParallelGCThreads=1 -Djava.io.tmpdir=${concordanceDirectory} -Xmx9g -jar ${EBROOTCOMPAREGENOTYPECALLS}/CompareGenotypeCalls.jar \
-d1 "${rawdataImputed}/chr${chr}" \
-D1 PED_MAP \
-d2 "${resultsImputed}/chr${chr}" \
-D2 PED_MAP \
-c1 ${chr} \
-s ${concordanceDirectory}/samples.chr${chr}.txt \
--output "${concordanceDirectory}/concordance_imputed_chr${chr}"

awk -F ' ' 'BEGIN {start=0;end=0};{if(NR==1){start=NF}};END {var=FILENAME; n=split(var,a,/\//); print a[n],"firstRowCount="start,"lastRowCount="NF}' ${resultsImputed}/chr${chr}.gen > ${concordanceDirectory}/chr${chr}.gen.count.imputed.after
awk -F ' ' 'BEGIN {start=0;end=0};{if(NR==1){start=NF}};END {var=FILENAME; n=split(var,a,/\//); print a[n],"firstRowCount="start,"lastRowCount="NF}' ${resultsUnimputed}/chr${chr}.haps > ${concordanceDirectory}/chr${chr}.haps.count.unimputed.after
