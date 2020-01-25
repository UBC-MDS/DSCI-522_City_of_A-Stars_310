# To Love or Not to Love: Project Proposal

## About

With this project, we attempt to run inferential analysis to determine if there is any significant difference between the total grades of secondary school students who are in a relationship and those who are not.   
The analysis is conducted on the `Student Performance Dataset` from the UCI Machine Learning Repository (https://archive.ics.uci.edu/ml/datasets/student+performance)

This data set details student performance indicators (grades) of secondary school students for two courses in the form of two data sets, one for Maths and one for Portugese, along with 30 features spanning information pertaining to school activities, social behaviour and family background. The data set has been compiled using school reports and questionnaires answered by secondary school students in Portugal.

References:

- Original Owner: Paulo Cortez, University of Minho, GuimarÃ£es, Portugal, http://www3.dsi.uminho.pt/pcortez
- P. Cortez and A. Silva. Using Data Mining to Predict Secondary School Student Performance. In A. Brito and J. Teixeira Eds., Proceedings of 5th FUture BUsiness TEChnology Conference (FUBUTEC 2008) pp. 5-12, Porto, Portugal, April, 2008, EUROSIS, ISBN 978-9077381-39-7. [[Web Link](http://www3.dsi.uminho.pt/pcortez/student.pdf)]
- Dua, D. and Graff, C. (2019). UCI Machine Learning Repository [http://archive.ics.uci.edu/ml]. Irvine, CA: University of California, School of Information and Computer Science

## Research Questions

The analysis will focus on answering the following inferential research questions:

- Do secondary school students who are in a relationship have different grades for Maths than students who are not?
- Do secondary school students who are in a relationship have different grades for Portugese than students who are not?

## Report

The final report can be found [here](https://github.com/UBC-MDS/DSCI-522_City_of_A-Stars_310/blob/master/doc/final_report.md)

## Usage

To replicate this analysis, clone this GitHub repository, and run the following commands at the comman line/terminal from the root directory of this project:

  - download data
  
  `python scripts/data_download.py –url=https://archive.ics.uci.edu/ml/machine-learning-databases/00320/student.zip --destination=data/`
  
  - clean the data
  
  `python scripts/data_cleaning.py --file_path=data/ --clean_path=data/`
  
  - run the eda script
  
  `python scripts/eda_script.py --file_path=data/ --results_path=results/`
  
  - run the statistical analysis script
  
  `Rscript scripts/statistical_analysis_results.r –test=data/student-combined_clean.csv --out_dir=results/figures`
  
  - render the final report
  
  `Rscript -e "rmarkdown::render('doc/final_report.Rmd')"`
  
  
