#!/bin/bash
set -eu

function showHelp(){

cat <<EOH

===========================================================================================================================================================================================

Script requires multiple initial arguments:

Usage:
	$(basename $0) OPTIONS

Options:
	-i|--imputedDirectory	   Full path where the IMPUTED files can be found from permanent storage		 	 [example: /my/prm/folder/ containing *.sample *.gen files]
	-u|--unimputedDirectory    Full path where the UNIMPUTED files can be found from permanent storage                       [example: /my/prm/folder/ containing *.haps *.sample files]
	-w|--workDirectory	   Directory  on TMP storage where the output will be stored.
				   Default: current directory. 									 [example: /my/tmp/folder/ containing updated *.sample *.gen files]
	-l|--listOfSamplesToRemove Filename(.txt) of the list of samples which have to be removed from the GWAS data.
				   NOTE: File location needs to be in the workDirectory. 					 [example: /my/tmp/folder/ samples.txt]
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

while getopts "i:u:w:l:h" opt;
do
	case $opt in h)showHelp;; i)imputedDirectory="${OPTARG}";; u)unimputedDirectory="${OPTARG}";; w)workDirectory="${OPTARG}";; l)listOfSamplesToRemove="${OPTARG}";;
	esac 
done

if [[ -z "${imputedDirectory:-}" ]]; then echo "ERROR: Option -i imputedDirectory is empty." ; showHelp ; fi ;
if [[ -z "${unimputedDirectory:-}" ]]; then echo "ERROR: Option -u unimputDirectory is empty." ; showHelp ; fi ;
if [[ -z "${workDirectory:-}" ]]
	then workDirectory="$( pwd )"
	if [[ "${workDirectory}" =~ "prm0" ]]
	then
		echo ${workDirectory} not allowed on PRM.;
		showHelp
	fi
elif [[ "${workDirectory}" =~ "prm0" ]];then echo ${workDirectory} not allowed on PRM.;showHelp;  fi ; echo "workDirectory=${workDirectory}"
if [[ -z "${listOfSamplesToRemove:-}" ]]; then echo "ERROR: Option -l  listOfSamplesToRemove is empty." ; showHelp ; fi ;

echo "${imputedDirectory}"
echo "${unimputedDirectory}"
echo "${workDirectory}"
echo "${workDirectory}/${listOfSamplesToRemove}"

jobsDirectory="${workDirectory}/jobs"
resultsDirectory="${workDirectory}/results"
resultsImputed="${workDirectory}/results/imputed"
resultsUnimputed="${workDirectory}/results/unimputed"
rawdataImputed="${workDirectory}/rawdata/imputed"
rawdataUnimputed="${workDirectory}/rawdata/unimputed"
sampleList="${workDirectory}/${listOfSamplesToRemove}"

mkdir -p "${jobsDirectory}"
mkdir -p "${resultsImputed}"
mkdir -p "${resultsUnimputed}"
mkdir -p "${rawdataImputed}"
mkdir -p "${rawdataUnimputed}"


if [ -e ${sampleList} ]
then
	echo "samples to remove:"
	cat ${sampleList}
	awk '{print "1\t"$1}' ${sampleList} > ${resultsUnimputed}/samples.txt
else
	echo "File does not exist: ${sampleList}"
fi

sh "${EBROOTMOLGENISMINCOMPUTE}/molgenis_compute.sh" \
-p "${EBROOTGWASMINSUBSET}/parameters.converted.csv " \
-p "${EBROOTGWASMINSUBSET}/chromosomelist.csv" \
-w "${EBROOTGWASMINSUBSET}/workflow.csv" \
-rundir "${jobsDirectory}" \
--submit "${EBROOTGWASMINSUBSET}/templates/slurm/submit.ftl" \
-o workDirectory="${workDirectory};\
imputedDirectory=${imputedDirectory};\
unimputedDirectory=${unimputedDirectory};\
listOfSamplesToRemove=${sampleList}; "\
-b slurm \
-weave \
--generate

# add qos line to header for datastaging queue.
cd "${jobsDirectory}"
match='--export=NONE'
insert='#SBATCH --qos=ds'
sed -i "s/$match/$match\n$insert/" s1_copyPrmDataToTmp_{0..21}.sh
cd -
