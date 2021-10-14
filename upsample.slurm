#!/bin/bash


#SBATCH --time 00:50:00

##SBATCH -A punim0577
#SBATCH -A punim0927

#SBATCH -p physical
##SBATCH -p bigmem

#SBATCH --nodes=1
#SBATCH --ntasks=1

#SBATCH --mem 50G

source /usr/local/module/spartan_new.sh
# keras
module load foss/2019b keras/2.3.1-python-3.7.4 
# scikit-learn
module load foss/2019b scikit-learn/0.23.1-python-3.7.4 
# numpy
module load foss/2019b numpy/1.17.3-python-3.7.4

OB=$1
US=100

python upsample_v1.py \
	target_files/target_329_${OB}.csv \
	329-686_s4.4.5_minfrac-0.8_Lpm7613_chr_p_mask.noref.OHE.csv \
	329-686_s4.4.5_minfrac-0.8_Lpm7613_chr_p_mask.noref.OHE_${OB}_US-${US} \
	${US}
	
#mv data_329_${OB}_US-${US}.csv data_329-688_SKA_align_m-0.1_k-15_p-0.1.OHE_${OB}_US-${US}.csv


#python upsample_v1.py target_files/target_329_MELB-C.csv 329-709_SKA_align_m-0.1_p-0.1.OHE.csv test

#for TAXA in $(cat fofn.txt); do

#	python ML_v1.py 329-709_SKA_align_m-0.1_p-0.1.OHE.csv target_files/target_329_${TAXA}.csv 380-709_SKA_align_m-0.1_p-0.1.OHE.csv target_files/target_380_${TAXA}.csv test_${TAXA} all RFC
	
#done
