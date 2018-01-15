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
"${imputedDirectory}/${chrName}.sample" \
"${rawdataImputed}/"

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${imputedDirectory}/"*.md5 \
"${rawdataImputed}/"

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${imputedDirectory}/${chrName}.gen" \
"${rawdataImputed}/"

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${imputedDirectory}/${chrName}_info" \
"${resultsImputed}/"

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${imputedDirectory}/"*_info.md5 \
"${resultsImputed}/"

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${unimputedDirectory}/${chrName}.ped" \
"${rawdataUnimputed}/"

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${unimputedDirectory}/${chrName}.map" \
"${rawdataUnimputed}/"

rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
"${unimputedDirectory}/"*.md5 \
"${rawdataUnimputed}/"
