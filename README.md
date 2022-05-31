# Lpn-paper

## Data files

### One-hot encoded matrices
```environmental isolate training matrix 
data/329-535_SKA_align_m-0.1_k-15_p-0.1_CLIPPED_OHE.csv  
#### clinical isolate testing matrix
data/206-535_SKA_align_m-0.1_k-15_p-0.1_CLIPPED_OHE.csv  
```  

### Target observation label files
```data/target_329_[OB].csv```   


## Scripts

### upsample the training data
```
command:  
sh upsample.sh OB_list.txt  
  
runs:  
upsample.py   
  
outfiles:   
data/data_329-535_SKA_align_m-0.1_k-15_p-0.1_CLIPPED_OHE_[OB]_US-100.csv  
data/target_329-535_SKA_align_m-0.1_k-15_p-0.1_CLIPPED_OHE_[OB]_US-100.csv  
```  

### make the config file
```  
command:  
sh config-file-maker.sh OB_list.txt k_list.txt model_list.txt class_1_weight_list.txt  
  
outfile:  
config.csv  
```  

### run the cross-validation loop on the environmental isolate training dataset
command:  
```sh train_val_runner.sh config.csv```  
runs:  
```ML_train_val.py```  
outfies:  


### compile the train-validation cross-validation report
command:  
```sh report-maker.sh config.csv```  
outfile:  
```report.csv```  
  
### determin the best models  
command:  
```sh evaluate-report.sh report.csv```  
outfile:  
 ```BEST_MODELS.csv```  
 
### run the best models on the clinical isolate test dataset 
command:  
```sh test_runner.sh BEST_config.csv```  
runs:  
```ML_test.py```  
outfile:  


### compile the test report
command:  
```sh test_report-maker.sh BEST_config.csv```  
outfile:  
```TEST_report.csv```  
