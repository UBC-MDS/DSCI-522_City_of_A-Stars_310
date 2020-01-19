# To Love or Not to Love: Project Proposal


## Datatset
We will be conducting analysis from the `Student Performance Dataset` from the UCI Machine Learning Repository (https://archive.ics.uci.edu/ml/datasets/student+performance)

This data set details student performance indicators (grades) of secondary school students for two courses in the form of two data sets, one for Maths and one for Portugese, along with 30 features spanning information pertaining to school activities, social behaviour and family background. The data set has been compiled using school reports and questionnaires answered by secondary school students in Portugal.

References:

- Original Owner: Paulo Cortez, University of Minho, GuimarÃ£es, Portugal, http://www3.dsi.uminho.pt/pcortez
- P. Cortez and A. Silva. Using Data Mining to Predict Secondary School Student Performance. In A. Brito and J. Teixeira Eds., Proceedings of 5th FUture BUsiness TEChnology Conference (FUBUTEC 2008) pp. 5-12, Porto, Portugal, April, 2008, EUROSIS, ISBN 978-9077381-39-7. [[Web Link](http://www3.dsi.uminho.pt/pcortez/student.pdf)]
- Dua, D. and Graff, C. (2019). UCI Machine Learning Repository [http://archive.ics.uci.edu/ml]. Irvine, CA: University of California, School of Information and Computer Science

## Research Questions

The analysis will focus on answering the following inferential research questions:

- Do secondary school students who are in a relationship have different grades for Maths than students who are not?
- Do secondary school students who are in a relationship have different grades for Portugese than students who are not?

## Analysis Plan

Our analysis of the data to answer both of the above stated research questions would include the following steps:

- Estimating average grade received by a student when they are in a relationship and when they are not in one. This will be reported along with the 95% confidence intervals for the average grade.
- Conducting a two-tailed hypothesis test and reporting the p-value.

## Exploratory Data Analysis

The following data analysis figures/tables will be part of the EDA: 
- Plots with error bars for standard deviation overlayed with the average grades for students who are in a relationship and who are not for both the subjects.    
- Descriptive statistics (counts and averages) for students of both subjects based on whether they are in a relationship or not.

## Reporting of Analysis

The results of the analysis for both research questions will be shared as a combination of the following figures/tables:

- A visualization showing the distribution of grades of students (jitter/ violin) with confidence intervals and average grade for both categories.
- A histogram for the null distribution which will be overlayed with the sample test statistic and shaded regions of confidence intervals.
- Further, we will report the p-value to infer to understand whether to reject or accept the null hypothesis.

