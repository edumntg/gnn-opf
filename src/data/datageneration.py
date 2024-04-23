"""
Vary different system parameters (such as loads), perform Load Flow on PowerFactory and extract results
"""
import sys
import os
print("Using Python env installed at:", os.path.dirname(sys.executable))
sys.path.append(r"C:\\Program Files\\DIgSILENT\\PowerFactory 2024 SP2\\Python\\3.11")


import argparse
import random

import openpyxl as xl
from openpyxl.chart import LineChart, Reference

if __name__ == '__main__':
    import powerfactory as pf
    parser = argparse.ArgumentParser()
    parser.add_argument('--iters',  type=int, default=100, help="Number of variations")

    args = parser.parse_args()
    # Get PF app
    app = pf.GetApplication()

    # Get active project
    app.ClearOutputWindow()
    pf_proj = app.GetActiveProject()
    pf_filename = app.GettAttribute("loc_name")
    print("Found project named", pf_proj)