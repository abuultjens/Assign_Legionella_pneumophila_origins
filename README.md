# Lpn-paper

## About


## Data files

### One-hot encoded matrices
```  
environmental isolate training matrix  
data/329-535_SKA_align_m-0.1_k-15_p-0.1_CLIPPED_OHE.csv  
  
clinical isolate testing matrix  
data/206-535_SKA_align_m-0.1_k-15_p-0.1_CLIPPED_OHE.csv  
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
  
datamash  
python  
numpy  
pandas  
sklearn  
  
## Distance-based classifiers
  
### Run classifiers
  
```  
command:  
sh dist-classify.sh OB_list_min-2-env.txt [matrix.tab]  

runs:  
mean.py  
gt.py  
  
outfiles:  
  
```
  
### Generate classification report  
  
```
command:  
sh dist_report-maker.sh OB_list_TMP.txt [PREFIX]  
  
outfiles:  
[PREFIX]_DIST_report.csv  
  
```
  
  
## Machine learning classifiers

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
data/data_329-535_SKA_align_m-0.1_k-15_p-0.1_CLIPPED_OHE_[OB]_US-100.csv  
data/target_329-535_SKA_align_m-0.1_k-15_p-0.1_CLIPPED_OHE_[OB]_US-100.csv  
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
[OB]_535_SKA_align_m-0.1_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_AUC_val.csv  
[OB]_535_SKA_align_m-0.1_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_confusion_matrix_val.csv  
[OB]_535_SKA_align_m-0.1_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_f1_score_val.csv  
[OB]_535_SKA_align_m-0.1_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_precision_score_val.csv  
[OB]_535_SKA_align_m-0.1_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_recall_score_val.csv  
  
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
[OB]_535_SKA_align_m-0.1_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_AUC_test.csv  
[OB]_535_SKA_align_m-0.1_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_confusion_matrix_test.csv  
[OB]_535_SKA_align_m-0.1_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_f1_score_test.csv  
[OB]_535_SKA_align_m-0.1_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_precision_score_test.csv  
[OB]_535_SKA_align_m-0.1_k-15_p-0.1.CLIPPED.OHE_US-100_VAL-0.8_k-[k]_model-[model]_class_1_weight-[weight]_recall_score_test.csv  
  
```

### Generate the test report
```  
command:  
sh test_report-maker.sh BEST_config.csv  
  
outfile:  
TEST_report.csv  
  
```
