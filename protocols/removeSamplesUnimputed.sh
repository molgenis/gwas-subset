#MOLGENIS walltime=59:59:00 mem=4gb ppn=1

#Parameter mapping
#string chr
#string chrName
#string plinkVersion
#string rawdataUnimputed
#string resultsUnimputed
#string resultsDirectory
#string listOfSamplesToRemove


#load modules and list currently loaded modules
module load "${plinkVersion}"
module list

set -e
set -u


#Running gtool to remove samples

awk '{print "1\t"$1}' ${listOfSamplesToRemove} > ${resultsUnimputed}/samples.${chrName}.txt

${EBROOTPLINK}/plink --make-bed --file ${rawdataUnimputed}/${chrName} \
 --remove ${resultsUnimputed}/samples.${chrName}.txt \
--out ${resultsUnimputed}/${chrName}


#md5sum new files

cd "${resultsUnimputed}"

md5sum chr${chr}.bed > chr${chr}.bed.md5sum
md5sum chr${chr}.bim > chr${chr}.bim.md5sum
md5sum chr${chr}.fam > chr${chr}.fam.md5sum

cd -


