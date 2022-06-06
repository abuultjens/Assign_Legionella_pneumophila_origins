#!/bin/bash


# generate random prefix for all tmp files
RAND_1=`echo $((1 + RANDOM % 100))`
RAND_2=`echo $((100 + RANDOM % 200))`
RAND_3=`echo $((200 + RANDOM % 300))`
RAND=`echo "${RAND_1}${RAND_2}${RAND_3}"`


# rm existing outfile
if ls BEST_config.csv 1> /dev/null 2>&1; then
	rm BEST_config.csv
fi

REPORT=$1

for OB in $(cat OB_list.txt); do

	BEST=`tail -n +2 ${REPORT} | grep "${OB}" | sort -t ',' -k 8 -nr | head -1 | cut -f 1 -d ','`
	grep "${BEST}"$ config.csv >> BEST_config.csv

done


