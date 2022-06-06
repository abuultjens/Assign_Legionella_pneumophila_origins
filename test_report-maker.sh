#!/bin/bash


# generate random prefix for all tmp files
RAND_1=`echo $((1 + RANDOM % 100))`
RAND_2=`echo $((100 + RANDOM % 200))`
RAND_3=`echo $((200 + RANDOM % 300))`
RAND=`echo "${RAND_1}${RAND_2}${RAND_3}"`

# write report header
echo "PREFIX,TP_test,TN_test,FP_test,FN_test,precision_test,recall_test,f1_test,AUC_test" > TEST_report.csv

CONFIG=$1

# make prefix file from config.csv
cut -f 9 -d ',' ${CONFIG} > ${RAND}_prefix.txt

for TAXA in $(cat ${RAND}_prefix.txt); do

	PREFIX=${TAXA}

	TN_test=`head -1 ${PREFIX}_confusion_matrix_test.csv | cut -f 1 -d ','`	
	FP_test=`head -1 ${PREFIX}_confusion_matrix_test.csv | cut -f 2 -d ','`  
	FN_test=`tail -1 ${PREFIX}_confusion_matrix_test.csv | cut -f 1 -d ','`  
	TP_test=`tail -1 ${PREFIX}_confusion_matrix_test.csv | cut -f 2 -d ','`  
        precision_test=`cat ${PREFIX}_precision_score_test.csv`
        recall_test=`cat ${PREFIX}_recall_score_test.csv`
        f1_test=`cat ${PREFIX}_f1_score_test.csv`
	AUC_test=`cat ${PREFIX}_AUC_test.csv`

	echo "${PREFIX},${TP_test},${TN_test},${FP_test},${FN_test},${precision_test},${recall_test},${f1_test},${AUC_test}" >> TEST_report.csv


done

#mv report.csv ${RUN}.report.csv
#mv config.csv ${RUN}.config.csv

# make dir for run
#mkdir RUN_${RUN}

# make dir for run reports
#mkdir ${RUN}_REPORT
#mv ${RUN}.report.csv ${RUN}_REPORT

# make reports for each OB 
#REPORT=${RUN}.report.csv
#head -1 ${RUN}_REPORT/${REPORT} > ${RUN}_REPORT/SUMMARY_${REPORT}
#for TAXA in $(cat OB_list.txt); do
#        head -1 ${RUN}_REPORT/${REPORT} > ${RUN}_REPORT/${RUN}.report.${TAXA}.csv
#        grep ^"${TAXA}_" ${RUN}_REPORT/${REPORT} >> ${RUN}_REPORT/${RUN}.report.${TAXA}.csv
#	
#	tail -n +2 ${RUN}_REPORT/${RUN}.report.${TAXA}.csv | tr ',' '\t' | sort -k8r | tr '\t' ',' | head -5 >> ${RUN}_REPORT/SUMMARY_${REPORT} 
#
#done

# mv files to run dir
#mv *${RUN}*.csv RUN_${RUN}
#mv ${RUN}_REPORT RUN_${RUN}		
#rm *.out		

rm ${RAND}_prefix.txt



