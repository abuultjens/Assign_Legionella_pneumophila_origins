#!/bin/bash


# spartan parameters:
#SBATCH --time 00:20:00
#SBATCH -A punim0927
#SBATCH -p physical
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem 10G

# load spartan modules:	
#source /usr/local/module/spartan_new.sh
# keras
#module load foss/2019b keras/2.3.1-python-3.7.4 
# scikit-learn
#module load foss/2019b scikit-learn/0.23.1-python-3.7.4 
# numpy
#module load foss/2019b numpy/1.17.3-python-3.7.4



# generate random prefix for all tmp files
RAND_1=`echo $((1 + RANDOM % 100))`
RAND_2=`echo $((100 + RANDOM % 200))`
RAND_3=`echo $((200 + RANDOM % 300))`
RAND=`echo "${RAND_1}${RAND_2}${RAND_3}"`

CONFIG=$1

SEQ=`wc -l ${CONFIG} | awk '{print $1}'`
seq 1 ${SEQ} > ${RAND}_seq.txt

for LINE in $(cat ${RAND}_seq.txt); do

	OB=`head -${LINE} ${CONFIG} | tail -1 | cut -f 1 -d ','`
	train_data=`head -${LINE} ${CONFIG} | tail -1 | cut -f 2 -d ','`
	train_target=`head -${LINE} ${CONFIG} | tail -1 | cut -f 3 -d ','`
	test_data=`head -${LINE} ${CONFIG} | tail -1 | cut -f 4 -d ','`
	test_target=`head -${LINE} ${CONFIG} | tail -1 | cut -f 5 -d ','`
	k=`head -${LINE} ${CONFIG} | tail -1 | cut -f 6 -d ','`
	model=`head -${LINE} ${CONFIG} | tail -1 | cut -f 7 -d ','`
	class_1_weight=`head -${LINE} ${CONFIG} | tail -1 | cut -f 8 -d ','`
	PREFIX=`head -${LINE} ${CONFIG} | tail -1 | cut -f 9 -d ','`
	
	echo "RUNNING: ${PREFIX}"
	
	python ML_test.py \
        	${train_data} \
        	${train_target} \
        	${test_data} \
        	${test_target} \
        	${PREFIX} \
        	${k} \
        	${model} \
        	0.5 \
        	${class_1_weight}

done

rm ${RAND}_seq.txt
		
