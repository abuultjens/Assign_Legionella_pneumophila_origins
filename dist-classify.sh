#!/bin/bash

PREFIX=$2
MATRIX=$3

##################################################

# generate random prefix for all tmp files
RAND_1=`echo $((1 + RANDOM % 100))`
RAND_2=`echo $((100 + RANDOM % 200))`
RAND_3=`echo $((200 + RANDOM % 300))`
RAND=`echo "${RAND_1}${RAND_2}${RAND_3}"`

##################################################

for OB in $(cat $1); do

if ls ${OB}_DIST.csv 1> /dev/null 2>&1; then
	rm ${OB}_DIST.csv
fi

if ls ${RAND}_${OB}_SMALLEST_DIST_TMP.csv 1> /dev/null 2>&1; then
        rm ${RAND}_${OB}_SMALLEST_DIST_TMP.csv
fi

##################################################

# write header
echo "ISOLATE,VALUE,THRESHOLD,PRED_CLASS,ORIGINAL_CLASS" > ${OB}_${PREFIX}_SMALLEST_DIST.csv

FIRST=`grep ",1" data/target_329_${OB}.csv | cut -f 1 -d ',' | head -1`
grep ",1" data/target_329_${OB}.csv | cut -f 1 -d ',' | tail -n +2 > ${RAND}_rest.txt

datamash transpose -H < ${MATRIX} | grep "${FIRST}$(printf '\t')" | datamash transpose -H | tail -n +2 > ${RAND}_file.txt

for TAXA in $(cat ${RAND}_rest.txt); do
	DIST=`grep "${TAXA}" ${RAND}_file.txt | cut -f 2`
	echo "${DIST}" >> ${OB}_DIST.csv
done

# calculate the mean dist among the environmental isolates for a OB group
python mean.py ${OB}_DIST.csv ${OB}

grep ",1" data/target_329_${OB}.csv | cut -f 1 -d ',' > ${RAND}_fofn.txt

head -1 ${MATRIX} > ${RAND}_file.txt

for TAXA in $(cat ${RAND}_fofn.txt); do
	grep "${TAXA}$(printf '\t')" ${MATRIX} | tail -n +2 >> ${RAND}_file.txt
done

# transpose
datamash transpose -H < ${RAND}_file.txt > ${RAND}_file.tr.txt		

cut -f 1 -d ',' data/target_205_${OB}.csv | tail -n +2 > ${RAND}_fofn.txt

# loop through and compare the smallest dist of each clinical isolate to the OB environmental isolates
for TAXA in $(cat ${RAND}_fofn.txt); do
	SMALLEST_DIST=`grep "${TAXA}$(printf '\t')" ${RAND}_file.tr.txt | tr '\t' '\n' | tail -n +2 | sort -n | head -1`
	THRESHOLD=`cat ${OB}_mean.csv`
	GT=`python gt.py ${SMALLEST_DIST} ${THRESHOLD}`
	echo "${TAXA},${SMALLEST_DIST},${THRESHOLD},${GT}" >> ${RAND}_${OB}_SMALLEST_DIST_TMP.csv	
done

# get ORIGINAL class column
cut -f 2 -d ',' data/target_205_${OB}.csv | tail -n +2 > ${RAND}_ORIGINAL_class.csv

# combine
paste ${RAND}_${OB}_SMALLEST_DIST_TMP.csv ${RAND}_ORIGINAL_class.csv | tr '\t' ',' >> ${OB}_${PREFIX}_SMALLEST_DIST.csv

# calculate CM and F1
python evaluate.py ${OB}_${PREFIX}_SMALLEST_DIST.csv ${OB}_${PREFIX}

done

# rm tmp files
rm ${RAND}_*
