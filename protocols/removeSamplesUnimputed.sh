#MOLGENIS walltime=59:59:00 mem=4gb ppn=1

#Parameter mapping
#string chr
#string chrName
#string shapeitVersion
#string rawdataUnimputed
#string resultsUnimputed
#string resultsDirectory
#string listOfSamplesToRemove


#load modules and list currently loaded modules
module load "${shapeitVersion}"
module list

set -e
set -u


#Running gtool to remove samples

awk '{print $1}' ${listOfSamplesToRemove} > ${resultsUnimputed}/samples.${chrName}.txt

#${EBROOTPLINK}/plink --make-bed --file ${rawdataUnimputed}/${chrName} \
# --remove ${resultsUnimputed}/samples.${chrName}.txt \
#--out ${resultsUnimputed}/${chrName}

$EBROOTSHAPEIT/shapeit -convert \
--input-haps ${rawdataUnimputed}/${chrName} \
--exclude-ind ${resultsUnimputed}/samples.${chrName}.txt \
--output-haps ${resultsUnimputed}/${chrName}


#md5sum new files

cd "${resultsUnimputed}"

md5sum chr${chr}.haps > chr${chr}.haps.md5
md5sum chr${chr}.sample > chr${chr}.sample.md5

cd -
