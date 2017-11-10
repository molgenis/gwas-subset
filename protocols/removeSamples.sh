#MOLGENIS walltime=59:59:00 mem=4gb ppn=1

#Parameter mapping
#string chr,chrName
#string gtoolVersion
#string inputDirectory
#string outputDirectory
#string resultsDirectory
#string listOfSamplesToRemove
#string rawdataDirectory

# Let's do something
echo "${inputDirectory}"
echo "${outputDirectory}"
echo "${listOfSamplesToRemove}"
echo "${chr}"
echo "${chrName}"
echo "${rawdataDirectory}"

#load modules and list currently loaded modules
module load "${gtoolVersion}"
module list

set -e
set -u


#Running gtool to remove samples

${EBROOTGTOOL}/gtool -S --g ${rawdataDirectory}/${chrName}.gen \
--s ${rawdataDirectory}/${chrName}.sample \
--og ${resultsDirectory}/chr${chr}.gen \
--sample_excl ${listOfSamplesToRemove} \
--os ${resultsDirectory}/chr${chr}.sample

#md5sum new files

cd "${resultsDirectory}"

md5sum chr${chr}.gen > chr${chr}.gen.md5sum
md5sum chr${chr}.sample > chr${chr}.sample.md5sum

cd -


