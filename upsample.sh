#!/bin/bash

# spartan parameters:
#SBATCH --time 00:50:00
#SBATCH -A punim0927
#SBATCH -p physical
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem 20G

# load spartan modules:
#source /usr/local/module/spartan_new.sh
# keras
#module load foss/2019b keras/2.3.1-python-3.7.4 
# scikit-learn
#module load foss/2019b scikit-learn/0.23.1-python-3.7.4 
# numpy
#module load foss/2019b numpy/1.17.3-python-3.7.4


for OB in $(cat $1); do
#OB=$1

	US=100
	
	echo "UPSAMPLING: ${OB}"

        python upsample.py \
               data/target_421_${OB}.csv \
               data/421-534_SKA_align_m-0.2_k-15_p-0.1.OHE.csv \
               421-534_SKA_align_m-0.2_k-15_p-0.1.OHE_${OB}_US-${US} \
               ${US}

	
done




