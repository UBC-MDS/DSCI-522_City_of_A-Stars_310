# author: A. Muhammad
# date: 2020-02-01

'''This script cleans the raw math and portuguese
students performance data.

Usage: data_cleaning.py --file_path=<file_path> --clean_path=<clean_path>

Example:
    python scripts/data_cleaning.py --file_path=data/ --clean_path=data/

Options:
--file_path=<file_path>  Path (excluding filenames) to the csv file.
--clean_path=<clean_path>  Path for saving clean data.
'''

import pandas as pd
import numpy as np
from docopt import docopt
import altair as alt
import re
import os


opt = docopt(__doc__)

def test_function():
    '''
    Tests the input data and specified paths.
    '''
    file_path_check = re.match("([A-Za-z]+[.]{1}[A-Za-z]+)", opt["--file_path"]) 
    out_path_check = re.match("([A-Za-z]+[.]{1}[A-Za-z]+)", opt["--clean_path"])
    assert file_path_check == None, "you can not have extensions in path, only directories."
    assert out_path_check == None, "you can not have extensions in path, only directories."
    try:
        os.listdir(opt["--file_path"])
        os.listdir(opt["--clean_path"])
    except Exception as e:
        print(e)

# test function runs here
test_function()

def main(file_path, clean_path):
    # read in data
    df_mat = pd.read_csv(file_path + "student-mat.csv", sep = ";")
    df_por = pd.read_csv(file_path + "student-por.csv", sep = ";")

    # create total grade column
    df_mat["total_grade"] = df_mat['G1'] + df_mat['G2'] + df_mat['G3']
    df_por["total_grade"] = df_por['G1'] + df_por['G2'] + df_por['G3']

    # change sex from M, F to Male Female
    df_mat["sex"] = df_mat["sex"].apply(lambda x: sex_decoding(x))
    df_por["sex"] = df_por["sex"].apply(lambda x: sex_decoding(x))
    
    # select necessary columns
    df_mat = df_mat[["sex", "romantic", "total_grade"]]
    df_por = df_por[["sex", "romantic", "total_grade"]]

    # write to csv
    df_mat.to_csv(clean_path + "student-mat_clean.csv", index=False)
    df_por.to_csv(clean_path + "student-por_clean.csv", index=False)

    # combine data
    df_mat["Course"] = "Math"
    df_por["Course"] = "Portuguese"
    df_combined = df_mat.append(df_por, ignore_index=True)
    df_combined.to_csv(clean_path + "student-combined_clean.csv", index= False)

def sex_decoding(sex):
    '''
    Decodes sex from M/F to full form
    Male and Female.
    '''
    if sex == "M":
        return "Male"
    else:
        return "Female"

if __name__ == "__main__":
    main(opt["--file_path"], opt["--clean_path"])
