#MOLGENIS walltime=59:59:00 mem=4gb ppn=1

#Parameter mapping
#string chr
#string chrName
#string gtoolVersion
#string rawdataImputed
#string resultsImputed
#string resultsDirectory
#string listOfSamplesToRemove


#load modules and list currently loaded modules
module load "${gtoolVersion}"
module list

set -e
set -u


#Running gtool to remove samples

${EBROOTGTOOL}/gtool -S --g ${rawdataImputed}/${chrName}.gen \
--s ${rawdataImputed}/${chrName}.sample \
--og ${resultsImputed}/chr${chr}.gen \
--sample_excl ${listOfSamplesToRemove} \
--os ${resultsImputed}/chr${chr}.sample

#md5sum new files

cd "${resultsImputed}"

md5sum chr${chr}.gen > chr${chr}.gen.md5sum
md5sum chr${chr}.sample > chr${chr}.sample.md5sum

cd -


