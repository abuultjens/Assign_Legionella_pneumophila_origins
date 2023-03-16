#!/bin/bash


PREFIX=$2

# write report header
echo "PREFIX,TP_dist,TN_dist,FP_dist,FN_dist,f1_dist,AUC_dist,RANK_dist" > ${PREFIX}_DIST_report.csv

for OB in $(cat $1); do

	NAME=${OB}_${PREFIX}

	TN_dist=`head -1 ${NAME}_confusion_matrix_dist.csv | cut -f 1 -d ','`	
	FP_dist=`head -1 ${NAME}_confusion_matrix_dist.csv | cut -f 2 -d ','`  
	FN_dist=`tail -1 ${NAME}_confusion_matrix_dist.csv | cut -f 1 -d ','`  
	TP_dist=`tail -1 ${NAME}_confusion_matrix_dist.csv | cut -f 2 -d ','`  
        f1_dist=`cat ${NAME}_f1_score_dist.csv`
	auc_dist=`cat ${NAME}_auc_dist.csv`
	rank_dist=`grep "ALL" ${NAME}_RANK_dist.csv | head -1 | cut -f 1 -d ','`


	echo "${NAME},${TP_dist},${TN_dist},${FP_dist},${FN_dist},${f1_dist},${auc_dist},${rank_dist}" >> ${PREFIX}_DIST_report.csv


done

