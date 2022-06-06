#!/bin/bash

# remove existing config file
if ls config.csv 1> /dev/null 2>&1; then
	rm config.csv
fi

# run loop
for OB in $(cat $1); do

	train_data=data/data_329-534_SKA_align_m-0.1_k-15_p-0.1_CLIPPED_OHE_${OB}_US-100.csv
	train_target=data/target_329-534_SKA_align_m-0.1_k-15_p-0.1_CLIPPED_OHE_${OB}_US-100.csv

	DATA=534_SKA_align_m-0.1_k-15_p-0.1.CLIPPED.OHE_US-100

	test_data=data/205-534_SKA_align_m-0.1_k-15_p-0.1_CLIPPED_OHE.csv
	test_target=data/target_205_${OB}.csv		

	for k in $(cat $2); do
					
		for model in $(cat $3); do
						
			for class_1_weight in $(cat $4); do
					
				echo "${OB},${train_data},${train_target},${test_data},${test_target},${k},${model},${class_1_weight},${OB}_${DATA}_VAL-0.8_k-${k}_model-${model}_class_1_weight-${class_1_weight}" >> config.csv
								
			done
					
		done
				
	done
			
done
		
		