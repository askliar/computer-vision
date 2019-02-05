from ICP import icp
from helpers import read_data, read_pcd
from time import time
import numpy as np
from helpers import make_homogeneous

def get_merge_transformations(files, step, normal_files=None, weight_type='normals', method='consecutive',
                              tolerance=1e-5, max_iterations=200, sampling=None, sample_size=1000,
                              outlier_rejection=None):
    transformations = [read_data(files[0])]
    times=[]
    full_X = []
    mean_errors=[]
    for i in range(0, len(files)-step, step):
        print('frame ', i+1)
        # if i % 20 == 0:
        #     print(f'Estimating pose from files {i} and {i+step}.')
        start = time()

        if method is 'iterative' and len(transformations) > 1:
            src = np.concatenate((full_X, read_data(files[i])), axis=0)
        else:
            src = read_data(files[i])
        target = read_data(files[i+step])

        src_normals, target_normals = None, None
        if normal_files is not None:
            src_normals = np.array(read_pcd(normal_files[i]))
            target_normals = np.array(read_pcd(normal_files[i+step]))

        T, full_X, mean_error ,time_taken= icp(src, target,
                                src_normals=src_normals,
                                target_normals=target_normals,
                                max_iterations=max_iterations,
                                tolerance=tolerance,
                                sampling=sampling,
                                sample_size=sample_size,
                                weight_type=weight_type,
                                outlier_rejection=outlier_rejection
                           )
        mean_errors.append(mean_error)
        transformations.append((target, T))
        times.append(time_taken)
        stop = time()
        # if i % 20 == 0:
        #     print(f'Time elapsed: {stop - start}')
    # print(np.mean(mean_errors))

    return transformations,np.mean(mean_errors),times,mean_errors

def merge_frames(src, target, transformation):
    cat = np.concatenate((make_homogeneous(src) @ transformation, target), axis = 0)
    return np.unique(cat, axis=0)

