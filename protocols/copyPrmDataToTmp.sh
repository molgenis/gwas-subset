#MOLGENIS walltime=5:59:00 mem=1gb ppn=1

#Parameter mapping
#string chr
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

###Copying data to tmp

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${inputDirectory}/samplesFilter_chr${chr}.sample" \
"${rawdataDirectory}/"

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${inputDirectory}/samplesFilter_chr${chr}.sample.md5sum" \
"${rawdataDirectory}/"

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${inputDirectory}/samplesFilter_chr${chr}.gen" \
"${rawdataDirectory}/"

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${inputDirectory}/samplesFilter_chr${chr}.gen.md5sum" \
"${rawdataDirectory}/"
