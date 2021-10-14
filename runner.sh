#!/bin/bash

#fofn-checker


for LINE in $(cat $1); do

	OB=`head -${LINE} config.csv | tail -1 | cut -f 1 -d ','`
	train_data=`head -${LINE} config.csv | tail -1 | cut -f 2 -d ','`
	train_target=`head -${LINE} config.csv | tail -1 | cut -f 3 -d ','`
	test_data=`head -${LINE} config.csv | tail -1 | cut -f 4 -d ','`
	test_target=`head -${LINE} config.csv | tail -1 | cut -f 5 -d ','`
	k=`head -${LINE} config.csv | tail -1 | cut -f 6 -d ','`
	model=`head -${LINE} config.csv | tail -1 | cut -f 7 -d ','`
	class_1_weight=`head -${LINE} config.csv | tail -1 | cut -f 8 -d ','`
	PREFIX=`head -${LINE} config.csv | tail -1 | cut -f 9 -d ','`
	
	sbatch test.slurm ${OB} ${train_data} ${train_target} ${test_data} ${test_target} ${k} ${model} ${class_1_weight} ${PREFIX}

done

		