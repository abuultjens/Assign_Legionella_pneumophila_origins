#!/bin/bash

#fofn-checker



for OB in $(cat OB_list.txt); do

#	train_data=../329_712_SKA_align_m-0.1_k-15_p-0.1.OHE.csv	
#	train_target=../target_files/target_329_${OB}.csv
#	train_data=../329-688_SKA_align_m-0.1_k-15_p-0.1.OHE.csv
#	train_target=../target_files/target_329_${OB}.csv 

#	train_data=../data_329-688_SKA_align_m-0.1_k-15_p-0.1.OHE_${OB}_US-50.csv
#	train_target=../target_329-688_SKA_align_m-0.1_k-15_p-0.1.OHE_${OB}_US-50.csv

#	train_data=../data_329-688_SKA_align_m-0.1_k-15_p-0.9.OHE_${OB}_US-100.csv
#	train_target=../target_329-688_SKA_align_m-0.1_k-15_p-0.9.OHE_${OB}_US-100.csv

#	train_data=../data_329-686_SKA_align_m-0.1_k-15_p-0.1.OHE_${OB}_US-100.csv
#	train_target=../target_329-686_SKA_align_m-0.1_k-15_p-0.1.OHE_${OB}_US-100.csv

	train_data=../data_329-686_s4.4.5_minfrac-0.8_Lpm7613_chr_p_mask.noref.OHE_${OB}_US-100.csv
	train_target=../target_329-686_s4.4.5_minfrac-0.8_Lpm7613_chr_p_mask.noref.OHE_${OB}_US-100.csv

	DATA=686_s4.4.5_minfrac-0.8_Lpm7613_chr_p_mask.noref.OHE_US-100

#	train_data=../data_329-688_s4.4.5_minfrac-0.8_Lpm7613_chr_p_mask.noref.OHE_${OB}_US-100.csv
#	train_target=../target_329-688_s4.4.5_minfrac-0.8_Lpm7613_chr_p_mask.noref.OHE_${OB}_US-100.csv

#	train_data=../data_329-688_SKA_align_m-0.1_k-15_p-0.1.OHE_${OB}_SMOTE.csv
#	train_target=../target_329-688_SKA_align_m-0.1_k-15_p-0.1.OHE_${OB}_SMOTE.csv

#	train_target=../target_329_${OB}_US-100.csv
#	test_data=../383_712_SKA_align_m-0.1_k-15_p-0.1.OHE.csv
#	test_target=../target_files/target_383_${OB}.csv
#	test_data=../359-688_SKA_align_m-0.1_k-15_p-0.9.OHE.csv
#	test_data=../357-686_SKA_align_m-0.1_k-15_p-0.1.OHE.csv
	test_data=../357-686_s4.4.5_minfrac-0.8_Lpm7613_chr_p_mask.noref.OHE.csv
#	test_data=../359-688_s4.4.5_minfrac-0.8_Lpm7613_chr_p_mask.noref.OHE.csv
	test_target=../target_files/target_357_${OB}.csv		

			for k in $(cat k_list.txt); do
					
				for model in $(cat model_list.txt); do
						
					for class_1_weight in $(cat class_1_weight_list.txt); do
					
						echo "${OB},${train_data},${train_target},${test_data},${test_target},${k},${model},${class_1_weight},${OB}_${DATA}_k-${k}_model-${model}_class_1_weight-${class_1_weight}_VAL-0.8" >> config.csv
						
#						mv ${OB}_SKA-m-0.1_p-0.1_k-${k}_model-${model}_class_1_weight-${class_1_weight}_confusion_matrix_test.csv ${OB}_SKA-m-0.1_p-0.1_US-100_k-${k}_model-${model}_class_1_weight-${class_1_weight}_confusion_matrix_test.csv
#						mv ${OB}_SKA-m-0.1_p-0.1_k-${k}_model-${model}_class_1_weight-${class_1_weight}_confusion_matrix_val.csv ${OB}_SKA-m-0.1_p-0.1_US-100_k-${k}_model-${model}_class_1_weight-${class_1_weight}_confusion_matrix_val.csv
#						mv ${OB}_SKA-m-0.1_p-0.1_k-${k}_model-${model}_class_1_weight-${class_1_weight}_f1_score_test.csv ${OB}_SKA-m-0.1_p-0.1_US-100_k-${k}_model-${model}_class_1_weight-${class_1_weight}_f1_score_test.csv
#						mv ${OB}_SKA-m-0.1_p-0.1_k-${k}_model-${model}_class_1_weight-${class_1_weight}_f1_score_val.csv ${OB}_SKA-m-0.1_p-0.1_US-100_k-${k}_model-${model}_class_1_weight-${class_1_weight}_f1_score_val.csv
#						mv ${OB}_SKA-m-0.1_p-0.1_k-${k}_model-${model}_class_1_weight-${class_1_weight}_ORIGINAL-PREDICT.csv ${OB}_SKA-m-0.1_p-0.1_US-100_k-${k}_model-${model}_class_1_weight-${class_1_weight}_ORIGINAL-PREDICT.csv
#						mv ${OB}_SKA-m-0.1_p-0.1_k-${k}_model-${model}_class_1_weight-${class_1_weight}_ORIGINAL-PREDICT_test.csv ${OB}_SKA-m-0.1_p-0.1_US-100_k-${k}_model-${model}_class_1_weight-${class_1_weight}_ORIGINAL-PREDICT_test.csv
#						mv ${OB}_SKA-m-0.1_p-0.1_k-${k}_model-${model}_class_1_weight-${class_1_weight}_precision_score_test.csv ${OB}_SKA-m-0.1_p-0.1_US-100_k-${k}_model-${model}_class_1_weight-${class_1_weight}_precision_score_test.csv
#						mv ${OB}_SKA-m-0.1_p-0.1_k-${k}_model-${model}_class_1_weight-${class_1_weight}_precision_score_val.csv ${OB}_SKA-m-0.1_p-0.1_US-100_k-${k}_model-${model}_class_1_weight-${class_1_weight}_precision_score_val.csv
#						mv ${OB}_SKA-m-0.1_p-0.1_k-${k}_model-${model}_class_1_weight-${class_1_weight}_recall_score_test.csv ${OB}_SKA-m-0.1_p-0.1_US-100_k-${k}_model-${model}_class_1_weight-${class_1_weight}_recall_score_test.csv
#						mv ${OB}_SKA-m-0.1_p-0.1_k-${k}_model-${model}_class_1_weight-${class_1_weight}_recall_score_val.csv ${OB}_SKA-m-0.1_p-0.1_US-100_k-${k}_model-${model}_class_1_weight-${class_1_weight}_recall_score_val.csv
			
								
					done
					
				done
				
			done
			
		done
		
#	done
	
#done

		