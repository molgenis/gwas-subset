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



rm -f "${resultsImputed}"/QC_Report.txt

echo "## Number of samples before and after sample removal. ##" >> "${resultsImputed}"/QC_Report.txt

for i in {0..21}
do
	echo "" >> ${resultsImputed}/QC_Report.txt
	echo "chr$((${i}+1)):" >> "${resultsImputed}"/QC_Report.txt
	echo "Imputed dataset:" >> "${resultsImputed}"/QC_Report.txt
	grep 'Number of' ${jobsDirectory}/s2_removeSamples_${i}.out >> ${resultsImputed}/QC_Report.txt
	echo "" >> ${resultsImputed}/QC_Report.txt
	echo "Unimputed dataset:" >> ${resultsImputed}/QC_Report.txt
	grep -P "cluded" s3_removeSamplesUnimputed_${i}.out >> ${resultsImputed}/QC_Report.txt
done

echo "" >> ${resultsImputed}/QC_Report.txt
echo "## Number of collumns before and after samples removal. ##" >> ${resultsImputed}/QC_Report.txt
echo "" >> ${resultsImputed}/QC_Report.txt

for i in "${chr[@]}"
do
	echo "Inputed dataset:" >> ${resultsImputed}/QC_Report.txt
	cat "${concordanceDirectory}/chr${i}.gen.count.imputed.before" >> "${resultsImputed}"/QC_Report.txt
	cat "${concordanceDirectory}/chr${i}.gen.count.imputed.after" >> "${resultsImputed}"/QC_Report.txt
	echo "Uninputed dataset:" >> ${resultsImputed}/QC_Report.txt
	cat "${concordanceDirectory}/chr${i}.haps.count.unimputed.before" >> "${resultsImputed}"/QC_Report.txt
        cat "${concordanceDirectory}/chr${i}.haps.count.unimputed.after" >> "${resultsImputed}"/QC_Report.txt
	echo "" >> ${resultsImputed}/QC_Report.txt
	echo "lowest sample concordance unimputed dataset:" >> "${resultsImputed}"/QC_Report.txt
	awk '{print $5}' "${concordanceDirectory}/concordance_unimputed_chr${i}.sample" | sort | head -2 >> "${resultsImputed}"/QC_Report.txt
	echo "lowest sample concordance imputed dataset:" >> "${resultsImputed}"/QC_Report.txt
        awk '{print $5}' "${concordanceDirectory}/concordance_imputed_chr${i}.sample" | sort | head -2 >> "${resultsImputed}"/QC_Report.txt
	echo "" >> "${resultsImputed}"/QC_Report.txt
done

cd "${resultsImputed}"
cp ${resultsImputed}/QC_Report.txt ../
cd -
