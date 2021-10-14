#!/bin/bash

#fofn-checker

echo "PREFIX,TP_val,TN_val,FP_val,FN_val,precision_val,recall_val,f1_val,TP_test,TN_test,FP_test,FN_test,precision_test,recall_test,f1_test" > report.csv

for TAXA in $(cat $1); do

	PREFIX=${TAXA}

#	sbatch test.slurm 0.5 ${TAXA}

        TN_val=`head -1 ${PREFIX}_confusion_matrix_val.csv | cut -f 1 -d ','` 
        FP_val=`head -1 ${PREFIX}_confusion_matrix_val.csv | cut -f 2 -d ','`  
        FN_val=`tail -1 ${PREFIX}_confusion_matrix_val.csv | cut -f 1 -d ','`  
        TP_val=`tail -1 ${PREFIX}_confusion_matrix_val.csv | cut -f 2 -d ','`
	precision_val=`cat ${PREFIX}_precision_score_val.csv`
	recall_val=`cat ${PREFIX}_recall_score_val.csv`
	f1_val=`cat ${PREFIX}_f1_score_val.csv`
	

	TN_test=`head -1 ${PREFIX}_confusion_matrix_test.csv | cut -f 1 -d ','`	
	FP_test=`head -1 ${PREFIX}_confusion_matrix_test.csv | cut -f 2 -d ','`  
	FN_test=`tail -1 ${PREFIX}_confusion_matrix_test.csv | cut -f 1 -d ','`  
	TP_test=`tail -1 ${PREFIX}_confusion_matrix_test.csv | cut -f 2 -d ','`  
        precision_test=`cat ${PREFIX}_precision_score_test.csv`
        recall_test=`cat ${PREFIX}_recall_score_test.csv`
        f1_test=`cat ${PREFIX}_f1_score_test.csv`

	echo "${PREFIX},${TP_val},${TN_val},${FP_val},${FN_val},${precision_val},${recall_val},${f1_val},${TP_test},${TN_test},${FP_test},${FN_test},${precision_test},${recall_test},${f1_test}" >> report.csv

done

		