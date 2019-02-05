### RUNNING INSTRUCTIONS

Steps to take:

1. First, create necessary folders. Project structure should be as following:
	* final_code
	* data:
		* data_mat
		* transformed_data 
2. Install full [Anaconda] (https://www.anaconda.com/download/). Alternatively, you can install [Miniconda] (https://conda.io/miniconda.html) (for Python 3.6) and run `conda env create -f environment.yml` in the root of the project.
3. Follow instructions on [Mathworks website] (https://nl.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html) to install MATLAB Engine API for Python.
4. Activate environment using `source activate cv2_icp`.
5. Run `pip install tqdm`
6. Run `conda install -c conda-forge opencv`
7. Run `cd final_code && jupyter notebook demo_notebook.ipynb`. It will activate jupyter notebook, which has all the necessary code for running the demo.

