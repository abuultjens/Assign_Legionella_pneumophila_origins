#!/bin/bash


# generate random prefix for all tmp files
RAND_1=`echo $((1 + RANDOM % 100))`
RAND_2=`echo $((100 + RANDOM % 200))`
RAND_3=`echo $((200 + RANDOM % 300))`
RAND=`echo "${RAND_1}${RAND_2}${RAND_3}"`

# write report header
echo "PREFIX,TP_val,TN_val,FP_val,FN_val,precision_val,recall_val,f1_val,AUC_val" > TRAIN_report.csv

CONFIG=$1

# make prefix file from config.csv
cut -f 9 -d ',' ${CONFIG} > ${RAND}_prefix.txt

for TAXA in $(cat ${RAND}_prefix.txt); do

	PREFIX=${TAXA}
	
#	if ls ${PREFIX}_confusion_matrix_val.csv 1> /dev/null 2>&1; then

        	TN_val=`head -1 ${PREFIX}_confusion_matrix_val.csv | cut -f 1 -d ','` 
 	        FP_val=`head -1 ${PREFIX}_confusion_matrix_val.csv | cut -f 2 -d ','`  
	        FN_val=`tail -1 ${PREFIX}_confusion_matrix_val.csv | cut -f 1 -d ','`  
	        TP_val=`tail -1 ${PREFIX}_confusion_matrix_val.csv | cut -f 2 -d ','`
		precision_val=`cat ${PREFIX}_precision_score_val.csv`
		recall_val=`cat ${PREFIX}_recall_score_val.csv`
		f1_val=`cat ${PREFIX}_f1_score_val.csv`
		AUC_val=`cat ${PREFIX}_AUC_val.csv`
	
		echo "${PREFIX},${TP_val},${TN_val},${FP_val},${FN_val},${precision_val},${recall_val},${f1_val},${AUC_val}" >> TRAIN_report.csv
#	fi

done

rm ${RAND}_*

