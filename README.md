# Reproducible Research Project

### Jakub Cudak
### Paulina Sereikyte
### Dawid Szyszko-Celinski

![alt text](https://www.netia.pl/Netia/media/blog/spam-co-to-jest.png)

Source: https://www.netia.pl/Netia/media/blog/spam-co-to-jest.png

## Aim of the initial project

The main aim of the project is to reproduce the econometric project submitted for the "Advanced Econometric" subject. The initial project idea was to create a logit and probit econometric model in RStudio that would predict if the email is spam. The dataset used for the initial analysis mainly consisted of certain keywords frequenies in the text and additional metrics such as a number of words in the email.

The approach of the modelling was as follows:
1) Create a basic probit and logit model that consists of all explanatory variables
2) Perform LR (likelihood Ratio) test to verify if the model`s parameters are jointly significant
3) Perform stepwise regression for both models to remove all coefficients whose p-value is above the 5% threshold
4) Again perform the LR test and additional Link test that would check if the model has a good specification
5) Add interaction between variables to the analysis
6) Perform stepwise regression
7) Execute LR and Link test
8) Execute the Hosmer-Lemershow test and Osjus-Rojek test to verify the specification
9) Verify goodness of fit statistics
10) Calculate marginal effects

The whole analysis and report can be found in the "Initial research" file:
1) The "Advanced Econometrics 2022 project" contains a report and description of the steps of the analysis
2) "spambase - raw data" consists of the raw dataset used for initial analysis
3) "Spam detection codes" - consist of R script used to perform the analysis
4) "names.csv" is an updated file with variables names, that can be read by R studio in CSV format
5) "linktest.R" and "marginaleffects.R" are custom functions written in R by dr Rafal Wozniak, Faculty of Economic Sciences, University of Warsaw

## Aim of this project

The aim of this project is to try reproducing the initial research in a different programming language - Python. We would like to verify if the actions performed in R can be easily translated into Python codes. We would like to verify if the outcomes are the same or if they differ due to possibly different algorithms that could be used in certain functions.

What is more, we would like to perform the same analysis, but on a different dataset with the same keyword that was used in the initial research. Based on the new dataset new keywords will be also obtained and a new model will be produced to verify how probit and logit models will work on the different datasets and keywords. The new dataset that will be used contains only text and labels if the message is spam or not, which is why it will be necessary to perform some data transformations. The process of the initial research will be followed.

The whole analysis can be found in the "Updated Research" file:
1) "Combined research" consists of a report and codes in jupyter notebook that contains all codes necessary to recreate initial research one-to-one and 2 updated versions: with old and new keywords on the new dataset.
2) "new_data_new_words.csv" dataset that will be used to analyse new keywords on a new dataset
3) "new_data_old_words.csv" dataset that will be used to analyse old keywords on a new dataset
4) "Technical" folder that contains all codes that were used as technical parts to create the main file "Combined research"
5) "Link to the dataset" - a text file containing a link to the new dataset

## General results

We were able to replicate the analysis, which was originally designed in R, in Python. Some adjustments had to be made to create new formulas and utilise a different set of packages, however the results generated in Python were the same as the results generated in R when using the same dataset.

Applying the same methodologies to a new dataset were more challenging, as the initial analysis was based on the word frequencies of certain words in the text. At first, the analysis was conducted based on the most common words and characters present in the new dataset. Then the models were replicated by calculating the frequencies of the words from the initial word list. 
While it was still possible to construct the models, they were generally less efficient in detecting spam. One of the main reasons was the much lower frequencies of the selected and previously used words in the new text. This resulted in very low variances within the variable which then had to be removed to be included in the models.
This issue was more prevalent when trying to replicate the analysis using the old word list - many of the words were highly specific to the initial dataset and thus were not found in the new data. This resulted in a big reduction in the number of variables and possible interactions, therefore the analysis could not be replicated exactly.

Overall, this excercise has proven what has been discussed in the initial research report- while econometric analysis performed well or on par with more complex models, it was determined to be highly specific to the data it was built on. As spam detection is a fast evolving subject that would need frequent updating and flexibility, other models, such as machine learning, are preferable.
