# author: Manuel Maldonado
# date: 2020-01-23

"Applies hypothesis testing on input data.

Usage: statistical_analysis_results.r --test=<test> --out_dir=<out_dir>

Options:
--test=<test>           Path (including filename) to test data (which needs to be saved as a csv file)
--out_dir=<out_dir>     Path to directory where the plots and resulting metrics summary are to be saved

" -> doc


library(tidyverse)
library(infer)
library(ggthemes)
library(docopt)
library(gridExtra)
library(cowplot)
library(tools)
library(testthat)



#set.seed(2019)

opt <- docopt(doc)





main <- function(test, out_dir) {
  

  test_that("test input must include a .csv file location",{
    expect_equal(file_ext(test), "csv")})

  test_that("output directory must not include an extension",{
    expect_equal(file_ext(out_dir), "")})  
  # Load data ----------------------------------------------
  grades_df <- read_csv(test)

  
  # Global (both genders) Comparison for each course --------------------------------------------------
  courses <- c("Math","Portuguese")
  i = 1
  global_plot_list = list()
  metrics_results_list = list()
  permutation_global_plot_list = list()
  for (course in courses) {
    data <- grades_df %>% 
      filter(Course == course)
    
    # get estimate info for Not in Romantinc Relationship
    Not_Rom <- data %>% 
      filter(romantic == "no")
    
    mean_Not_Rom <- mean(Not_Rom$total_grade)
    
    Not_Rom_ci <- Not_Rom %>% 
      specify(response = total_grade) %>% 
      generate(reps = 1000)  %>% 
      calculate(stat = "mean")  %>% 
      get_ci() %>% 
      rename(lower = `2.5%`, upper = `97.5%`) %>% 
      mutate(mean = mean_Not_Rom,
             romantic = "no")
    
    # get estimate info for people in Romantic Relationship
    Yes_Rom <- data %>% 
      filter(romantic == "yes")
    
    mean_Yes_Rom <- mean(Yes_Rom$total_grade)
    
    Yes_Rom_ci <- Yes_Rom %>% 
      specify(response = total_grade) %>% 
      generate(reps = 1000)  %>% 
      calculate(stat = "mean")  %>% 
      get_ci() %>% 
      rename(lower = `2.5%`, upper = `97.5%`) %>% 
      mutate(mean = mean_Yes_Rom,
             romantic = "yes")
    
    # combine summarized data
    summarized <- bind_rows(Not_Rom_ci, Yes_Rom_ci)
    
    # plot estimates and ci's
    
    plot_title = titles <- c("Distribution,CI, Mean Comparison - Course: Math","Distribution,CI, Mean Comparison - Course: Portuguese")
    
    options(repr.plot.width = 8, repr.plot.height = 6)
    plot <- ggplot(data, aes(x = romantic, y = total_grade)) +
      geom_violin(adjust = 5) +
      stat_summary(fun.y = mean, geom = "point", shape = 18, size = 5, color = "red") +
      geom_errorbar(data = summarized, 
                    mapping = aes(x = romantic, y = mean, ymin = lower, ymax = upper), 
                    size = 0.7, color = "red", width=1.02) + 
      theme_economist() + scale_colour_economist() +
      xlab("In a Romantic Relationship or Not") +
      scale_y_continuous(name = "Total Grade",breaks = c(0, 10, 20,30,40,50,60), limits = c(0,60))+
      ggtitle(plot_title[i])
    global_plot_list[[i]] = plot
    
    ##Calculate t-statistic
    t_statistic <- (mean_Not_Rom - mean_Yes_Rom)
    
    null_distribution_two_means <- data %>% 
      specify(formula = total_grade ~ romantic) %>% 
      hypothesize(null = "independence") %>% 
      generate(reps = 15000, type = "permute")  %>% 
      calculate(stat = "diff in means", order = c("no", "yes")) 
    
    ci <- null_distribution_two_means %>%  get_ci()
    
    ## Permutation T-Statistic - Plotting
    
    permut_plot_title = titles <- c("Permutation T-Statistic - Course: Math","Permutation T-Statistic - Course: Portuguese")
    
    permut_plot <- null_distribution_two_means %>% visualize() +
      geom_vline(xintercept = t_statistic, colour = "red") +
      geom_vline(xintercept = c(ci[[1]], ci[[2]]), color = "blue", lty = 2) +
      scale_y_continuous(name = "count",breaks = c(0, 500,1000,1500, 2000,2500,3000,3500), limits = c(0,3800))+
      labs(title =permut_plot_title[i])+
      theme_economist() + scale_colour_economist()
    permutation_global_plot_list[[i]] = permut_plot
    
    ##Saving Metrics Results
    
    p_value <- null_distribution_two_means %>% 
      get_p_value(obs_stat = t_statistic, direction = "both")
    
    summarized$t_statistic = t_statistic
    summarized$p_value = p_value[[1]]
    
    summarized <- cbind(Course = course, summarized)
    
    metrics_results_list[[i]] = summarized
    
    i = i + 1
  }
  
  
  ## Plot and result exporting
  
  result_metrics <- bind_rows(metrics_results_list[[1]], metrics_results_list[[2]])
  png(filename = paste0(out_dir, "/result_metrics_summary.png"), width=480,height=480,bg = "white")
  grid.table(result_metrics)
  dev.off()
  
  
  saveRDS(result_metrics, file = paste0(out_dir, "/result_metrics_summary.rds"))
  
  options(repr.plot.width = 14, repr.plot.height = 6)
  grid_plot_distribution_mean_ci_comparison <- plot_grid(
    global_plot_list[[1]],global_plot_list[[2]],
    align = "h",labels="AUTO",scale = 0.9)
  
  permutation_tests_comparison <- plot_grid(
    permutation_global_plot_list[[1]],permutation_global_plot_list[[2]],
    align = "h",labels="AUTO",scale = 0.9
  )
  
  
  
  ggsave(paste0(out_dir, "/distribution_mean_ci_comparison.png"), 
         grid_plot_distribution_mean_ci_comparison,
         width = 14, 
         height = 12)

  ggsave(paste0(out_dir, "/permutation_test_comparison.png"), 
         permutation_tests_comparison,
         width = 14, 
         height = 12)
  
}

main(opt[["--test"]], opt[["--out_dir"]])