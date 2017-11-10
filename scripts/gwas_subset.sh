#!/bin/bash
set -eu

function showHelp(){

cat <<EOH

===========================================================================================================================================================================================

Script requires multiple initial arguments:

Usage:
	$(basename $0) OPTIONS

Options:
	-i|--inputDirectory	   Full path where the input files can be found from permanent storage		 	 	[example: /my/prm/folder/ containing *.sample *.gen files]
	-w|--workDirectory	   Directory  on TMP storage where the output will be stored. 
				   Default: current directory. 									[example: /my/tmp/folder/ containing updated *.sample *.gen files]
	-l|--listOfSamplesToRemove Filename(.txt) of the list of samples which have to be removed from the GWAS data. 
				   NOTE: File location needs to be in the workDirectory.					[example: /my/tmp/folder/ samples.txt]
				   Currently: $( pwd ).
	-h|--help		   showHelp
===========================================================================================================================================================================================

EOH
trap - EXIT
exit 0
}

if [ -z ${1:-} ]
then
	showHelp
fi

while getopts "i:w:l:h" opt; 
do
	case $opt in h)showHelp;; i)inputDirectory="${OPTARG}";; w)workDirectory="${OPTARG}";; l)listOfSamplesToRemove="${OPTARG}";; 
	esac 
done

if [[ -z "${inputDirectory:-}" ]]; then echo "ERROR: Option -i inputDirectory is empty." ; showHelp ; fi ;
if [[ -z "${workDirectory:-}" ]]; then workDirectory="$( pwd )" ;elif [[ "${workDirectory}" =~ "prm0" ]];then echo ${workDirectory} not allowed on PRM.;showHelp;  fi ; echo "workDirectory=${workDirectory}"
if [[ -z "${listOfSamplesToRemove:-}" ]]; then echo "ERROR: Option -l  listOfSamplesToRemove is empty." ; showHelp ; fi ;

echo "${inputDirectory}"
echo "${workDirectory}"
echo "${workDirectory}/${listOfSamplesToRemove}"

jobsDirectory="${workDirectory}/jobs"
resultsDirectory="${workDirectory}/results"
rawdataDirectory="${workDirectory}/rawdata"
sampleList="${workDirectory}/${listOfSamplesToRemove}"

if [ -e ${sampleList} ]
then
	echo "samples to remove:"
	cat ${sampleList}
else
	echo "File does not exist: ${sampleList}"
fi

mkdir -p "${jobsDirectory}"
mkdir -p "${resultsDirectory}"
mkdir -p "${rawdataDirectory}"

sh "${EBROOTMOLGENISMINCOMPUTE}/molgenis_compute.sh" \
-p "${EBROOTGWASMINSUBSET}/parameters.csv" \
-p "${EBROOTGWASMINSUBSET}/chromosomelist.csv" \
-w "${EBROOTGWASMINSUBSET}/workflow.csv" \
-rundir "${jobsDirectory}" \
-o inputDirectory="${inputDirectory};\
resultsDirectory=${resultsDirectory};\
listOfSamplesToRemove=${sampleList};\
rawdataDirectory=${rawdataDirectory};\
outputDirectory=${workDirectory}" \
-b slurm \
-weave \
--generate

# add qos line to header for datastaging queue.
cd "${jobsDirectory}"
match='--export=NONE'
insert='#SBATCH --qos=ds'
sed -i "s/$match/$match\n$insert/" s1_copyPrmDataToTmp_{0..21}.sh
cd -
