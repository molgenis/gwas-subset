#MOLGENIS walltime=01:59:00 mem=1gb ppn=1
#Parameter mapping
#string workDirectory
#string rawdataImputed
#string rawdataUnimputed
#string resultsImputed
#string resultsUnimputed
#string jobsDirectory
#string concordanceDirectory
#string compareGenotypeCallsVersion
#string listOfSamplesToRemove
#list chr



rm -f "${resultsImputed}"/QcReport.txt

echo "# Number of samples before and after sample removal." >> "${resultsImputed}"/QcReport.txt

for i in {0..21}
do
	echo "# chr$((${i}+1)):" >> "${resultsImputed}"/QcReport.txt
	echo "Imputed dataset:"
	grep 'Number of' ${jobsDirectory}/s2_removeSamples_${i}.out >> ${resultsImputed}/QcReport.txt
	echo "" >> ${resultsImputed}/QcReport.txt
	echo "Unimputed dataset:" >> ${resultsImputed}/QcReport.txt
	grep -P "cluded" s3_removeSamplesUnimputed_${i}.out >> ${resultsImputed}/QcReport.txt
	echo "" >> ${resultsImputed}/QcReport.txt
done

echo "" >> ${resultsImputed}/QcReport.txt
echo "# Number of collumns before and after samples removal." >> ${resultsImputed}/QcReport.txt

for i in "${chr[@]}"
do
	echo "chr${i}" >> ${resultsImputed}/QcReport.txt
	echo "Inputed dataset:" >> ${resultsImputed}/QcReport.txt
	cat "${concordanceDirectory}/chr${i}.gen.count.imputed.before" >> "${resultsImputed}"/QcReport.txt
	cat "${concordanceDirectory}/chr${i}.gen.count.imputed.after" >> "${resultsImputed}"/QcReport.txt
	echo "Uninputed dataset:" >> ${resultsImputed}/QcReport.txt
	cat "${concordanceDirectory}/chr${i}.haps.count.unimputed.before" >> "${resultsImputed}"/QcReport.txt
        cat "${concordanceDirectory}/chr${i}.haps.count.unimputed.after" >> "${resultsImputed}"/QcReport.txt
	echo "lowest sample concordance unimputed dataset:" >> "${resultsImputed}"/QcReport.txt
	awk '{print $5}' "${concordanceDirectory}/concordance_unimputed_chr${i}.sample" | sort | head -2 >> "${resultsImputed}"/QcReport.txt
	echo "lowest sample concordance imputed dataset:" >> "${resultsImputed}"/QcReport.txt
        awk '{print $5}' "${concordanceDirectory}/concordance_imputed_chr${i}.sample" | sort | head -2 >> "${resultsImputed}"/QcReport.txt
	echo "" >> "${resultsImputed}"/QcReport.txt
done

cd "${resultsImputed}"
cp ${resultsImputed}/QcReport.txt ../
cd -
