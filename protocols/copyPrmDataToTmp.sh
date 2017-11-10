#MOLGENIS walltime=5:59:00 mem=1gb ppn=1

#Parameter mapping
#string chr,chrName
#string inputDirectory
#string outputDirectory
#string listOfSamplesToRemove
#string workDirectory
#string rawdataDirectory

# Let's do something
echo "${inputDirectory}"
echo "${outputDirectory}"
echo "${listOfSamplesToRemove}"
echo "${chr}"
echo ${chrName}

###Copying data to tmp

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${inputDirectory}/${chrName}.sample" \
"${rawdataDirectory}/"

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${inputDirectory}/${chrName}.sample.md5sum" \
"${rawdataDirectory}/"

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${inputDirectory}/${chrName}.gen" \
"${rawdataDirectory}/"

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${inputDirectory}/${chrName}.gen.md5sum" \
"${rawdataDirectory}/"
