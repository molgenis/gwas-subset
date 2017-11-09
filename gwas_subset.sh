#!/bin/bash
set -eu

#/groups/umcg-lld/tmp02/umcg-gvdvries

function showHelp(){

cat <<EOH

===========================================================================================================================================================================================

Script requires multiple initial arguments:

Usage:
	$(basename $0) OPTIONS

Options:
	-i|--inputFolder	   Full path where the input files can be found from permanent storage		 	 [example: /myprmfolder/ containing *.sample *.gen files]
	-o|--outputFolder	   Full path where the output will be stored on tmp storage				 [example: /mytmpfolder/ containing updated *.sample *.gen files]
	-l|--listOfSamplesToRemove Full path and name of the list of samples which have to be removed from the GWAS data [example: /mytmpfolder/removesamples.txt]
	-h|--help		   showHelp
===========================================================================================================================================================================================

EOH
trap - EXIT
exit 0
}

module load ngs-utils
module load Molgenis-Compute/v16.11.1-Java-1.8.0_74
module list

if [ -z ${1:-} ]
then
	showHelp
fi

while getopts "i:o:l:h" opt; 
do
	case $opt in h)showHelp;; i)inputDirectory="${OPTARG}";; o)outputDirectory="${OPTARG}";; l)listOfSamplesToRemove="${OPTARG}";; 
	esac 
done

echo "${inputDirectory}"
echo "${outputDirectory}"
echo "${listOfSamplesToRemove}"

jobsDirectory="${outputDirectory}/jobs"
resultsDirectory="${outputDirectory}/results"
rawdataDirectory="${outputDirectory}/rawdata"

mkdir -p "${jobsDirectory}"
mkdir -p "${resultsDirectory}"
mkdir -p "${rawdataDirectory}"

EBROOTGWASMINSUBSET="/groups/umcg-lld/tmp02/umcg-mbenjamins/LL_Test/gwas-subset/"

sh "${EBROOTMOLGENISMINCOMPUTE}/molgenis_compute.sh" \
-p "${EBROOTGWASMINSUBSET}/parameters.csv" \
-p "${EBROOTGWASMINSUBSET}/chromosomelist.csv" \
-w "${EBROOTGWASMINSUBSET}/workflow.csv" \
-rundir "${jobsDirectory}" \
-o inputDirectory="${inputDirectory};\
resultsDirectory=${resultsDirectory};\
listOfSamplesToRemove=${listOfSamplesToRemove};\
rawdataDirectory=${rawdataDirectory};\
outputDirectory=${outputDirectory}" \
-b slurm \
-weave \
--generate

# add qos line to header for datastaging queue.
cd "${jobsDirectory}"
match='--export=NONE'
insert='#SBATCH --qos=ds'
sed -i "s/$match/$match\n$insert/" s1_copyPrmDataToTmp_{0..21}.sh
cd -

