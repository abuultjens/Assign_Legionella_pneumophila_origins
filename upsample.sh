#!/bin/bash


source /usr/local/module/spartan_new.sh
# keras
module load foss/2019b keras/2.3.1-python-3.7.4 
# scikit-learn
module load foss/2019b scikit-learn/0.23.1-python-3.7.4 
# numpy
module load foss/2019b numpy/1.17.3-python-3.7.4

for OB in $(cat $1); do

	US=100

	python upsample.py \
		data/target_329_${OB}.csv \
		data/329-534_SKA_align_m-0.1_k-15_p-0.1_CLIPPED_OHE.csv \
		329-534_SKA_align_m-0.1_k-15_p-0.1_CLIPPED_OHE_${OB}_US-${US} \
		${US}
	
done




