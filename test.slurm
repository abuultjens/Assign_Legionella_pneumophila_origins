#!/bin/bash


#SBATCH --time 00:10:00

##SBATCH -A punim0577
#SBATCH -A punim0927

#SBATCH -p physical
##SBATCH -p bigmem

#SBATCH --nodes=1
#SBATCH --ntasks=1

#SBATCH --mem 20G

source /usr/local/module/spartan_new.sh
# keras
module load foss/2019b keras/2.3.1-python-3.7.4 
# scikit-learn
module load foss/2019b scikit-learn/0.23.1-python-3.7.4 
# numpy
module load foss/2019b numpy/1.17.3-python-3.7.4

OB=$1 
train_data=$2
train_target=$3
test_data=$4
test_target=$5
k=$6
model=$7
class_1_weight=$8
PREFIX=$9

python ML_train-val-test_LOOP.py \
        ${train_data} \
        ${train_target} \
        ${test_data} \
        ${test_target} \
        ${PREFIX} \
        ${k} \
        ${model} \
        0.5 \
        ${class_1_weight}

#python ML_train-val-test_LOOP.py \
#	../../Lpn_ML/data_329_MELB-G_US-100.csv \
#	../../Lpn_ML/target_329_MELB-G_US-100.csv \
#	../../Lpn_ML/383_712_SKA_align_m-0.1_k-15_p-0.1.OHE.csv \
#	../../Lpn_ML/target_files/target_383_${OB}.csv \
#	test_OB-${OB}_SKA-US-100_m-0.1_p-0.1_K-50_SVC-sigmoid_TRAIN-VAL-0.8_${weight} \
#	50 \
#	SVC \
#	0.5 \
#	${weight}





