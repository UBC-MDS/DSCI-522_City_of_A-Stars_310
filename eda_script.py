# author: A. Muhammad
# date: 2020-01-18

'''This script performs EDA on the students performance datasets
for portuguese and math students.

Usage: quick_csv_stat.py --file_path=<file_path> --plot_path=<plot_path>

Options:
--file_path=<file_path>  Path (excluding filenames) to the csv file.
--plot_path=<plot_path>  Path for saving plots.
'''

import pandas as pd
import numpy as np
from docopt import docopt
import altair as alt


opt = docopt(__doc__)

def main(file_path, plot_path):
    # read in data
    df_mat = pd.read_csv(file_path + "student-mat.csv", sep = ";")
    df_por = pd.read_csv(file_path + "student-por.csv", sep = ";")

    df_mat["g_total"] = df_mat['G1'] + df_mat['G2'] + df_mat['G3']
    df_por["g_total"] = df_por['G1'] + df_por['G2'] + df_por['G3']

    # register the custom theme under a chosen name
    alt.themes.register('mds_special', mds_special)

    # enable the newly registered theme
    alt.themes.enable('mds_special')
    # print the findings

    print("{} math students were in relationships and {} were not.".format(
        df_mat['romantic'].value_counts()['yes'], 
        df_mat['romantic'].value_counts()['no']))

    print("{} portuguese language students were in relationships and {} were not.".format(
        df_por['romantic'].value_counts()['yes'], 
        df_por['romantic'].value_counts()['no']))

    print("The average total grade for math students in relationships was: {:.2f}/60".format(
        df_mat[df_mat['romantic'] == 'yes']['g_total'].mean()))
    print("The average total grade for math students not in relationships was: {:.2f}/60".format(
        df_mat[df_mat['romantic'] == 'no']['g_total'].mean()))
    print("The average total grade for portuguese students in relationships was: {:.2f}/60".format(
        df_por[df_por['romantic'] == 'yes']['g_total'].mean()))
    print("The average total grade for portuguese students not in relationships was: {:.2f}/60".format(
        df_por[df_por['romantic'] == 'no']['g_total'].mean()))

    # make and save plots
    error_bars = alt.Chart(df_mat).mark_errorbar(extent='stdev').encode(
    y=alt.Y('g_total:Q', 
            scale=alt.Scale(domain = (0, 60)),
            title = "Total grades (out of 60)"),
    x=alt.X('romantic:N',
            title = "Relationship")
    )
    points = alt.Chart(df_mat).mark_point(filled=True, color='black').encode(
    y=alt.Y('g_total:Q', aggregate='mean'),
    x=alt.X('romantic:N'),
    )

    (error_bars + points).properties(
        width = 200,
        height = 400,
        title = "Total grades for math students"
    ).save(plot_path + "math_plot.html")

    error_bars = alt.Chart(df_por).mark_errorbar(extent='stdev').encode(
    y=alt.Y('g_total:Q', 
            scale=alt.Scale(domain = (0, 60)),
            title = "Total grades (out of 60)"),
    x=alt.X('romantic:N',
            title = "Relationship")
    )
    points = alt.Chart(df_por).mark_point(filled=True, color='black').encode(
    y=alt.Y('g_total:Q', aggregate='mean'),
    x=alt.X('romantic:N'),
    )

    (error_bars + points).properties(
        width = 200,
        height = 400, 
        title = "Total grades for Portuguese language students"
    ).save(plot_path + "portuguese_plot.html")




def mds_special():
    font = "Arial"
    axisColor = "#000000"
    gridColor = "#DEDDDD"
    return {
        
        "config": {
            "title": {
                "fontSize": 24,
                "font": font,
                "anchor": "start", # equivalent of left-aligned.
                "fontColor": "#000000"
            },
            "background": "white",
            "axisX": {
                "domain": True,
                #"domainColor": axisColor,
                "gridColor": gridColor,
                "domainWidth": 1,
                "grid": False,
                "labelFont": font,
                "labelFontSize": 12,
                "labelAngle": 0, 
                #"tickColor": axisColor,
                "tickSize": 5, # default, including it just to show you can change it
                #"titleFont": font,
                "titleFontSize": 18,
                "titlePadding": 10, # guessing, not specified in styleguide
                "title": "X Axis Title (units)", 
            },
            "axisY": {
                "domain": False,
                "grid": True,
                "gridColor": gridColor,
                "gridWidth": 1,
                "labelFont": font,
                "labelFontSize": 12,
                "labelAngle": 0, 
                #"ticks": False, # even if you don't have a "domain" you need to turn these off.
                "titleFont": font,
                "titleFontSize": 18,
                "titlePadding": 10, # guessing, not specified in styleguide
                "title": "Y Axis Title (units)", 
                # titles are by default vertical left of axis so we need to hack this 
                #"titleAngle": 0, # horizontal
                #"titleY": -10, # move it up
                #"titleX": 18, # move it to the right so it aligns with the labels 
            },
                }
            }
    

if __name__ == "__main__":
    main(opt["--file_path"], opt["--plot_path"])