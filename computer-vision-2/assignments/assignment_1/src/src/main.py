from helpers import read_data, read_xml, depth2cloud, get_files, read_pcd, make_homogeneous, clean_pcds
from ICP import icp
import os
from merge_scenes import get_merge_transformations, merge_frames
from functools import reduce
from scipy.io import savemat
import itertools
import time

data_path = '../data/'
transformed_data_path = '../data/transformed_data'

data_dir = os.path.join(os.getcwd(), f'{data_path}')
transformed_data_dir = os.path.join(os.getcwd(), f'{transformed_data_path}/')

weight_types = [None, 'dist', 'dist5', 'dist55']
sampling_types = [None, 'iterative', 'uniform']
outlier_rej_types = [None, 'threshold', 'variance', 'normals']
steps = [1, 2, 4, 10]
exp = [(None, None, None, i) for i in steps]

param_lists = list(itertools.product(sampling_types, weight_types, outlier_rej_types, steps))

for params in exp:
    weight_type,sampling_type, outlier_rej_type, step = params
    print(params)
    start = time.time()
    pcd_files = [x for x in get_files(
        transformed_data_dir, '.txt') if 'normal' not in x and 'clean' in x]
    normal_files = [x for x in get_files(
        transformed_data_dir, '.txt') if 'normal' in x and 'clean' in x]

    transformations,mean_error,times,mean_errors = get_merge_transformations(pcd_files[5:20], normal_files=normal_files[5:20], weight_type=weight_type,
                                     step=step, method='iterative', outlier_rejection=outlier_rej_type,
                                     sample_size=5000, sampling=sampling_type, tolerance=1e-5)
    final_pcd = reduce(lambda src, target: merge_frames(src, target[0], target[1]),
                        transformations[1:],
                        transformations[0])

    savemat(os.path.join(data_dir, f'full_{sampling_type}_{weight_type}_{outlier_rej_type}_{step}_Iterative.mat'),
            {'points': final_pcd})
    savemat(os.path.join(data_dir, f'full_{sampling_type}_{weight_type}_{outlier_rej_type}_{step}_Times.mat'),
        {'times': times})
    savemat(os.path.join(data_dir, f'full_{sampling_type}_{weight_type}_{outlier_rej_type}_{step}_errors.mat'),
        {'times': mean_errors})
    print(time.time() - start)

print("End")