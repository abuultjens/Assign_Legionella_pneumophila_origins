# Lpn-paper

## About

These scripts are presented here in a serial manner to improve comprehension of the analytical pipeline. Several of the following steps can be greatly sped up by running in parallel. If running on a HPC system, it is recommended that dist-classify.sh, upsample.sh and train_val_runner.sh are run in parallel.
  
## Data files
  
### Distance-based matrices  
```  
data/442_coreugate_FST-0.85_pad.tab  
data/442_PatristicDistMatrix.tab  
```  
  
### One-hot encoded matrices
```  
environmental isolate training matrix  
data/329-442_SKA_align_m-0.1_k-15_p-0.1_CLIPPED_OHE.csv  
  
clinical isolate testing matrix  
data/113-442_SKA_align_m-0.1_k-15_p-0.1_CLIPPED_OHE.csv  
```  

### Target observation label files
```data/target_329_[OB].csv```   

### Outbreak group name file
```  
OB_list.txt  
ESSEX-A, ESSEX-B, ESSEX-E, ESSEX-G, ESSEX-H, MELB-2018, MELB-A, MELB-C, MELB-G, MELB-M, NY-1, NY-2, NY-3, NY-4, NY-5, NY-6, NY-7, NY-8, NY-9, NY-10  
  
OB_list_min-2-env.txt  
ESSEX-A, ESSEX-B, ESSEX-E, ESSEX-G, ESSEX-H, MELB-2018, MELB-A, MELB-C, MELB-G, MELB-M, NY-1, NY-2, NY-6, NY-9  
```    

## Dependencies  
```  
python 3.7.4   
datamash 1.7  
numpy 1.17.3  
pandas 0.25.3    
sklearn 0.23.1  
```  

## Distance-based classifiers
  
### Run classifiers
```  
command:  
sh dist-classify.sh OB_list_min-2-env.txt [PREFIX] [matrix.tab]  

runs:  
mean.py  
gt.py  
  
outfiles:  
[OB]_[PREFIX]_confusion_matrix_dist.csv  
[OB]_[PREFIX]_f1_score_dist.csv  
```
  
### Generate classification report  
```
command:  
sh dist_report-maker.sh OB_list_min-2-env.txt [PREFIX]  
  
outfiles:  
[PREFIX]_DIST_report.csv  
  
```
  
## Machine learning classifiers   
```  
# uncompress files  
gunzip data/329-442_SKA_align_m-0.1_k-15_p-0.1_CLIPPED_OHE.csv.gz  
gunzip data/113-442_SKA_align_m-0.1_k-15_p-0.1_CLIPPED_OHE.csv.gz  
```
  
### Model parameter lists
```  
OB_list.txt  
ESSEX-A, ESSEX-B, ESSEX-E, ESSEX-G, ESSEX-H, MELB-2018, MELB-A, MELB-C, MELB-G, MELB-M, NY-1, NY-2, NY-3, NY-4, NY-5, NY-6, NY-7, NY-8, NY-9, NY-10  
  
k_list.txt  
50, 500, 5000, all  
  
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
data/data_329-442_SKA_align_m-0.1_k-15_p-0.1_CLIPPED_OHE_[OB]_US-100.csv  
data/target_329-442_SKA_align_m-0.1_k-15_p-0.1_CLIPPED_OHE_[OB]_US-100.csv  
```  

### Make the config file
```  
command:  
sh config-file-maker.sh \  
      OB_list.txt \  
      k_list.txt \  
      model_list.txt \  
      class_1_weight_list.txt  
  
outfile:  
config.csv  
```  

### Run the cross-validation loop on the environmental isolate training dataset  
```  
command:  
sh train_val_runner.sh config.csv  
  
runs:  
ML_train_val.py  
  
outfies:  
[OB]_442_SKA_align_m-0.1_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_AUC_val.csv  
[OB]_442_SKA_align_m-0.1_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_confusion_matrix_val.csv  
[OB]_442_SKA_align_m-0.1_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_f1_score_val.csv  
[OB]_442_SKA_align_m-0.1_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_precision_score_val.csv  
[OB]_442_SKA_align_m-0.1_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_recall_score_val.csv  
  
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
[OB]_442_SKA_align_m-0.1_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_AUC_test.csv  
[OB]_442_SKA_align_m-0.1_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_confusion_matrix_test.csv  
[OB]_442_SKA_align_m-0.1_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_f1_score_test.csv  
[OB]_442_SKA_align_m-0.1_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_precision_score_test.csv  
[OB]_442_SKA_align_m-0.1_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_recall_score_test.csv  
[OB]_442_SKA_align_m-0.1_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_ORIGINAL-PREDICT_test.csv  
  
```

### Generate the test report
```  
command:  
sh test_report-maker.sh BEST_config.csv  
  
outfile:  
TEST_report.csv  
  
```
