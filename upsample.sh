#!/bin/bash


for OB in $(cat $1); do

	US=100
	
	echo "UPSAMPLING: ${OB}"

	python upsample.py \
		data/target_329_${OB}.csv \
		data/329-534_SKA_align_m-0.1_k-15_p-0.1_CLIPPED_OHE.csv \
		329-534_SKA_align_m-0.1_k-15_p-0.1_CLIPPED_OHE_${OB}_US-${US} \
		${US}
	
done




