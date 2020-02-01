all: results/math_table.csv results/por_table.csv results/figures/result_metrics_summary.rds results/figures/math_plot.png results/figures/por_plot.png results/figures/distribution_mean_ci_comparison.png results/figures/permutation_test_comparison.png

# render report
doc/final_report.md: doc/final_report.Rmd doc/references.bib
	Rscript -e "rmarkdown::render('doc/final_report.Rmd', output_format = 'github_document')"

clean:
	rm -rf data
	rm -rf results
	rm -rf doc/final_report.md doc/final_report.html