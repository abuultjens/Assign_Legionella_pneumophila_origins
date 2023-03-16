#!/bin/bash


FOFN=${1}
N_SPLIT=${2}


# generate random prefix for all tmp files
RAND_1=`echo $((1 + RANDOM % 100))`
RAND_2=`echo $((100 + RANDOM % 200))`
RAND_3=`echo $((200 + RANDOM % 300))`
RAND=`echo "${RAND_1}${RAND_2}${RAND_3}"`

# make dir for tmp files
mkdir ${RAND}

# get number of taxa in fofn
N_TAXA=`wc -l ${FOFN} | awk '{print $1}'`

# split fofn
split -d -l ${N_SPLIT} ${FOFN} ${RAND}/FOFN_${RAND}_

# make group fofn
ls ${RAND}/FOFN_${RAND}_* > ${RAND}/${RAND}_FOFN.txt

# loop through groups
for GROUP in $(cat ${RAND}/${RAND}_FOFN.txt); do

	FILE=`echo ${GROUP}`

	# loop through lines in group
	for TAXA in $(cat ${FILE}); do
		
		# for HPC cluster queue
#		sbatch train_val_runner.sh ${TAXA} &

		# for regular system
		sh train_val_runner.sh ${TAXA} &

	done

	wait

done

# rm tmp files		
rm *${RAND}*
rm -r ${RAND}


