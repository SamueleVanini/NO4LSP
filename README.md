# Introduction

The repository contains all the code developed for the Numerical Optimization for Large Scale Problem 2024-2025 course's project at Politecnico of Torino.

The repository is divided in 2 different folders: `num` for the Variants of Newton method developed in Matlab, and `stoc` for the Reinforcement Learning part developed in Python.

Reports are available in the respective pdfs: `report_numerical_optimization.pdf` and `report_stochastic_optimization.pdf`

We kindly advice to first read the reports provided to have a broad idea of what the scope of this project is.

# How to run

## Stochastic module (Python)
All the development have been done assuming a python version greater or equal to 3.11, previous versions are not tested or directly supported.
The following steps will guide you on the set-up to run the module:

1. Create a virtual environment using the built-in tool ```venv``` or the module ```virtualenv``` (all the instructions will consider only venv)
    ```
    python -m venv venv
    source venv/bin/activate   # on macOs/Linux
    venv\Scripts\activate.bat  # on Windows
    ```
2. Install all the required libraries (important: before running the following command be sure to be inside the virtual environment, otherwise the libraries will be installed globally)
    ```
    pip install -r requirements.txt # run it in the project root directory
    ```
3. Modify the constants in `stoc/main.py` if needed and then run:
    ```
    python stoc/main.py
    ```

## Numerical module (matlab)
To run the module simply download the repo and run one among `MNM_test.m` or `TNM_test.m` for obtaining results of respectively Modified Newton Method (Newton Method with matrix correction) and Truncated Newton Method. These will call the respective methods, defined as functions in `modifiedNM.m` and `truncatedNM.m` in a problem of choice, which can be set by following comments at the start of the test files.