# Reproducible Research Project

### Jakub Cudak
### Paulina Sereikyte
### Dawid Szyszko-Celinski

![alt text](https://www.netia.pl/Netia/media/blog/spam-co-to-jest.png)

## Aim of the initial project

The main aim of the project is to reproduce the econometric project submited for "Advanced Econometric" subject. The initial project idea was to create logit or probit econometric model in RStudio that would predic if the email is spam. The dataset used for the initial analysis mainly consited of certain keywords frequenies in the text and additional metrics such as number of words in the email.

The approach of the modeling was as follows:
1) Create a basic probit and logit model that consits of all explanatory variables
2) Perform LR (likelihood Ratio) test to verify if the model`s parameters are jointly significant
3) Perform stepwise regression for both models to remove all coefficients that p-value is above 5% threshold
4) Again perform LR test and additionally Link test that would check if the model has a good specification
5) Add interaction between variables to the analysis
6) Perform stepwise regression
7) Execute LR and Link tesr
8) Execute Hosmer-Lemershow test and Osjus-Rojek test to verify specification
9) Verify goodness of fit statistics
10) Calculate marginal effects

The whole analysis and report can be found in the "Initial research" file:
1) The "Advanced Econometrics 2022 project" contains report and description of steps of the analysis
2) "spambase - raw data" consists of raw dataset used for initial analysis
3) "Spam detection codes" - consist of R script used to perform the analysis
4) "names.csv" is an updated file with variables names, that can be read by R studio in csv format
5) "linktest.R" and "marginaleffects.R" are custom function written in R by dr Rafal Wozniak, Faculty of Economic Sciences, University of Warsaw

## Aim of this project

The aim of this project is to try reproducing the initial research in different programming languane - Python. We would like to verify if the actions pefrormed in R can be easily translated to Python codes. We would like to verify if the ourcomes are same or if they differ due to possibly different algorithms that could be used in certain functions.

What is more we would like to perform same analysis, but on different dataset with the same keyword that were used in the initial research. Based in the new dataset the new keywords will be also obtained and new model will be produced to verify how probit and logit models will work on the different dataset and keywords. The new dataset that will be used contains only text and label if the message is spam or not, that is why it will be necessary to perform some data transformations. The process of the initial research will be followed.

The whole analysis can be found in the "Updated Research" file:
1) "Combined research" consists of report and codes in jupyter notebook that contains all codes necessary to recreate initial research one-to-one and 2 updated varsions: with old and new keywords on new dataset.
2) "new_data_new_words.csv" dataset that will be used to analyse new keywords on new dataset
3) "new_data_old_words.csv" dataset that will be used to analyse old keywords on new dataset
4) "Technical" folder that contains all codes that were used as a technical parts to create main file "Combined research"
5) "Link to the dataset" - text file containing link to the new dataset
