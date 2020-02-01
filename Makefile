all: data/student-por.csv data/student-mat.csv data/student-mat_clean.csv data/student-por_clean.csv results/math_table.csv results/por_table.csv results/figures/result_metrics_summary.rds results/figures/math_plot.png results/figures/por_plot.png results/figures/distribution_mean_ci_comparison.png results/figures/permutation_test_comparison.png

# render report
doc/final_report.md: doc/final_report.Rmd doc/references.bib results/math_table.csv results/por_table.csv results/figures/math_plot.png results/figures/por_plot.png
	Rscript -e "rmarkdown::render('doc/final_report.Rmd', output_format = 'github_document')"

# clean data
data/student-mat_clean.csv data/student-por_clean.csv: data/student-mat.csv data/student-por.csv
	python scripts/data_cleaning.py --file_path=data/ --clean_path=data/

# eda and plots
results/math_table.csv results/por_table.csv results/figures/math_plot.png results/figures/por_plot.png: data/student-mat_clean.csv data/student-por_clean.csv
	python scripts/eda_script.py --file_path=data/ --results_path=results/

clean:
	rm -rf data/*.csv
	rm -rf results/figures/*
	rm -rf results/*.csv
	rm -rf doc/final_report.md doc/final_report.html