# Lpn-paper

## Scripts

### upsample the training data
```sh upsample.sh```  
```upsample.py```  

### make the config file
```sh config-file-maker.sh```  

### run the CV-loop on the environmental isolate training dataset
```sh train_val_runner.sh config.csv```  
```ML_train_val.py```  

### compile the CV report
```sh report-maker.sh config.csv```  

### determin the best models
```sh evaluate-report.sh```  

### run best models on the clinical isolate test dataset
```sh test_runner.sh BEST_config.csv```  
```ML_test.py```  

