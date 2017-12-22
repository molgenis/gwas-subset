#MOLGENIS walltime=23:59:00 mem=1gb ppn=1

#Parameter mapping
#string chr
#string chrName
#string imputedDirectory
#string unimputedDirectory
#string rawdataImputed
#string rawdataUnimputed
#string resultsImputed


###Copying data to tmp

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${imputedDirectory}/samplesFilter_${chrName}.sample" \
"${rawdataImputed}/"

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${imputedDirectory}/samplesFilter_${chrName}.sample.md5sum" \
"${rawdataImputed}/"

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${imputedDirectory}/samplesFilter_${chrName}.gen" \
"${rawdataImputed}/"

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${imputedDirectory}/samplesFilter_${chrName}.gen.md5sum" \
"${rawdataImputed}/"

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${imputedDirectory}/${chrName}_info" \
"${resultsImputed}/"

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${imputedDirectory}/${chrName}_info.md5sum" \
"${resultsImputed}/"

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${unimputedDirectory}/output.${chrName}.ped" \
"${rawdataUnimputed}/"

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${unimputedDirectory}/output.${chrName}.map" \
"${rawdataUnimputed}/"

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${unimputedDirectory}/${chrName}.ped.md5sum" \
"${rawdataUnimputed}/"

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${unimputedDirectory}/${chrName}.map.md5sum" \
"${rawdataUnimputed}/"
