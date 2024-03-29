# Machine learning to assign origins to Legionaries’ disease infections

## About

Collection of scripts that train and optimise machine learning models using environmental _Legionella pneumophila_ isolate genomes to then predict the origins of Legionaries’ disease infections. The scripts are presented here in a serial manner to improve comprehension of the analytical pipeline. Several of the following steps can be greatly sped up by running in parallel. If running on a HPC system, it is recommended that train_val_runner.sh is run in parallel (see below).
  
## Dependencies  
```  
python 3.7.4   
datamash 1.7  
numpy 1.17.3  
pandas 0.25.3    
sklearn 0.23.1  
```  
  
## Data files  
  
### Outbreak group name file
```  
OB_list.txt  
ESSEX-A, ESSEX-B, ESSEX-E, ESSEX-G, ESSEX-H, MELB-2018, MELB-A, MELB-C, MELB-G, MELB-M, NY-1, NY-2, NY-3, NY-4, NY-5, NY-6, NY-7, NY-8, NY-9, NY-10  
  
OB_list_min-2-env.txt  
ESSEX-A, ESSEX-B, ESSEX-E, ESSEX-G, ESSEX-H, MELB-2018, MELB-A, MELB-C, MELB-G, MELB-M, NY-1, NY-2, NY-6, NY-9  
```    
  
### Target observation label files  
```  
data/target_421_[OB].csv  
data/target_113_[OB].csv  
```   
  
### Distance-based matrices  
```  
data/534_coreugate_FST-0.85_pad.tab  
data/534_PatristicDistMatrix.tab  
```  
  
### One-hot encoded matrices
```  
environmental isolate training matrix  
data/421-534_SKA_align_m-0.2_k-15_p-0.1.OHE.csv  
  
clinical isolate testing matrix  
data/113-534_SKA_align_m-0.2_k-15_p-0.1.OHE.csv  
```  
  
## Distance-based classifiers  
  
### Run classifiers  
```  
command:  
sh dist-classify.sh OB_list_min-2-env.txt [PREFIX] [matrix.tab]  

runs:  
mean.py  
gt.py  
evaluate.py  
  
outfiles:  
[OB]_[PREFIX]_confusion_matrix_dist.csv  
[OB]_[PREFIX]_f1_score_dist.csv

# run on cgMLST matrix
sh dist-classify.sh OB_list_min-2-env.txt 534_coreugate_FST-0.85_pad_dist-classify data/534_coreugate_FST-0.85_pad.tab

# run on Patristic distance matrix
sh dist-classify.sh OB_list_min-2-env.txt 534_PatristicDistMatrix_dist-classify data/534_PatristicDistMatrix.tab

```
  
### Generate classification report  
```
command:  
sh dist_report-maker.sh OB_list_min-2-env.txt [PREFIX]  
  
outfiles:  
[PREFIX]_DIST_report.csv

# run on cgMLST matrix
sh dist_report-maker.sh OB_list_min-2-env.txt 534_coreugate_FST-0.85_pad_dist-classify  

# run on Patristic distance matrix   
sh dist_report-maker.sh OB_list_min-2-env.txt 534_PatristicDistMatrix_dist-classify

```
  
## Machine learning classifiers   
```  
# uncompress files  
gunzip data/421-534_SKA_align_m-0.2_k-15_p-0.1.OHE.csv.gz  
gunzip data/113-534_SKA_align_m-0.2_k-15_p-0.1.OHE.csv.gz  
```
  
### Model parameter lists
```  
OB_list.txt  
ESSEX-A, ESSEX-B, ESSEX-E, ESSEX-G, ESSEX-H, MELB-2018, MELB-A, MELB-C, MELB-G, MELB-M, NY-1, NY-2, NY-3, NY-4, NY-5, NY-6, NY-7, NY-8, NY-9, NY-10  
  
k_list.txt  
50, 5000, all  
  
model_list.txt  
SVC-linear, SVC-rbf, SVC-poly, SVC-sigmoid, RFC  
  
class_1_weight_list.txt  
1, 2, 3, 4, 5  
```     
  
### Upsample the training data
```
command:  
sh upsample.sh OB_list.txt  
  
runs:  
upsample.py   
  
outfiles:   
data/data_421-534_SKA_align_m-0.2_k-15_p-0.1_OHE_[OB]_US-100.csv  
data/target_421-534_SKA_align_m-0.2_k-15_p-0.1_OHE_[OB]_US-100.csv  
```  
  
### Run the cross-validation loop on the environmental isolate training dataset [one at a time]  
```  
command:  
sh train_val_runner.sh config.csv  
  
runs:  
ML_train_val.py  
  
outfies:  
[OB]_534_SKA_align_m-0.2_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_AUC_val.csv  
[OB]_534_SKA_align_m-0.2_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_confusion_matrix_val.csv  
[OB]_534_SKA_align_m-0.2_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_f1_score_val.csv  
[OB]_534_SKA_align_m-0.2_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_precision_score_val.csv  
[OB]_534_SKA_align_m-0.2_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_recall_score_val.csv  
  
```

### Run the cross-validation loop on the environmental isolate training dataset [in parallel]  
```  
split up the config file into a single line per file:  
split -d -l 1 config.csv CONFIG_  
  
make a file of file names to run:  
ls CONFIG_* > config_fofn.txt  
  
command:  
sh parallel.sh [config_fofn.txt] [n-processes]  
```  
  
### Generate the training cross-validation report
```   
command:  
sh train_report-maker.sh config.csv  
  
outfile:  
TRAIN_report.csv  
```
  
### Determine the best models for each outbreak group 
```  
command:  
sh evaluate-report.sh TRAIN_report.csv  
  
outfile:   
BEST_config.csv  
```
  
### Run the best models on the clinical isolate test dataset 
```  
command:  
sh test_runner.sh BEST_config.csv  
  
runs:  
ML_test.py  
  
outfile:  
[OB]_534_SKA_align_m-0.2_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_AUC_test.csv  
[OB]_534_SKA_align_m-0.2_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_confusion_matrix_test.csv  
[OB]_534_SKA_align_m-0.2_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_f1_score_test.csv  
[OB]_534_SKA_align_m-0.2_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_precision_score_test.csv  
[OB]_534_SKA_align_m-0.2_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_recall_score_test.csv  
[OB]_534_SKA_align_m-0.2_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_ORIGINAL-PREDICT_test.csv  
  
```

### Generate the test report
```  
command:  
sh test_report-maker.sh BEST_config.csv  
  
outfile:  
TEST_report.csv  
  
```
