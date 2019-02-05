from helpers import sample_uniform, make_homogeneous, make_homogeneous_T
import numpy as np
from scipy.spatial import cKDTree as KDTree
import time

def icp(src, target, src_normals=None, target_normals=None, max_iterations=200, tolerance=1e-15,
        sampling=None, sample_size=1000, weight_type=None, outlier_rejection='np', param=0):
    ## outlier_rejection: threshold, fraction, variance
    ## weight_type: uniform, distance, normals
    now=time.time()
    d1 = src.shape[1]
    d2 = target.shape[1]

    full_X = src.copy()
    full_Y = target.copy()

    if sampling is None:
        src_idxs = sample_uniform(full_X.shape[0], full_X.shape[0])
        target_idxs = sample_uniform(full_Y.shape[0], full_Y.shape[0])

    elif sampling is 'uniform':
        src_idxs = sample_uniform(full_X.shape[0], sample_size)
        target_idxs = sample_uniform(full_Y.shape[0], sample_size)

    prev_error = 0
    R = np.eye(d1, d2)
    R_cumul = R.copy()
    t_cumul = np.zeros((d1, 1))
    T_cumul = np.zeros((4, 3))
    T_cumul[:3, :3] = R
    true_fullY = full_Y.copy()
    true_fullX = full_X.copy()
    # print(src_normals.shape, target_normals.shape)

    full_tree = KDTree(full_Y)

    # distances, indices = full_tree.query(full_X, k=1, sqr_dists=True)
    distances, indices = full_tree.query(full_X, k=1)

    mean_error = np.mean(distances)
    print(f'Initial MSE: {mean_error}')


    if sampling is 'uniform':
        sample_tree = KDTree(full_Y[target_idxs], leafsize=8)
    elif sampling is None:
        sample_tree = KDTree(full_Y[target_idxs], leafsize=8)

    for i in range(max_iterations):

        if sampling is 'iterative':
            src_idxs = sample_uniform(full_X.shape[0], sample_size)
            target_idxs = sample_uniform(full_Y.shape[0], sample_size)
            sample_tree = KDTree(full_Y[target_idxs])

        X = full_X[src_idxs]
        Y = full_Y[target_idxs]

        # if sampling is not None:
        # distances, indices = sample_tree.query(X, k=1, sqr_dists=True)
        distances, indices = sample_tree.query(X, k=1)

        ind2 = range(distances.shape[0])
        if outlier_rejection == 'threshold':
            ind2 = [distances < 0.002]
        elif outlier_rejection == 'fraction':
            permutation = np.argsort(distances)
            ind2 = permutation[:int(len(indices) / 10)]
        elif outlier_rejection == 'variance':
            std = np.std(distances)
            ind2 = [distances < 2.5*std]

        # apply outlier removal (by indexing with ind2)
        X = X[ind2]
        Y = Y[indices][ind2]
        w = None
        if weight_type == 'dist':
            w = (1 - distances[ind2] / np.max(distances[ind2])).reshape(1, -1)
        if weight_type == 'dist5' or weight_type == 'dist55':
            new_tree = KDTree(Y)
            distances5, indices5 = new_tree.query(X, k=5)
            distances5 = distances5.sum(axis = 1)
            if weight_type == 'dist5':
                w = (1 - distances5 / np.max(distances)).reshape(1, -1)
            else:
                w = (1 - distances5).reshape(1, -1)

        elif weight_type == 'normals':
            w = np.sum(src_normals[ind2] * target_normals[indices][ind2], axis=1).reshape(1, -1)

        T = best_fit_transform(X, Y, w)
        # full_X = (R @ full_X.T + t).T

        full_X = make_homogeneous(full_X) @ T
        T_cumul = make_homogeneous_T(T_cumul) @ T

        # distances, indices = full_tree.query(full_X, k=1, sqr_dists=True)
        distances, indices = full_tree.query(full_X, k=1)

        mean_error = np.mean(np.power(distances, 2))
        err_diff = np.abs(prev_error - mean_error)
        print(
            f'MSE after iteration {i}: {mean_error}, difference between errors: {err_diff}, tolerance: {tolerance}')
        if err_diff < tolerance:
            break
        prev_error = mean_error
    time_taken=time.time()-now
    print(f'Running time: {time_taken}')
    return T_cumul, full_X, mean_error,time_taken

def best_fit_transform(src, target, w=None):
    n = src.shape[0]
    d = src.shape[1]
    if w is None:
        w = np.ones(n).reshape(1, -1)
    src_mean = (w @ src / np.sum(w)).T
    target_mean = (w @ target / np.sum(w)).T
    X = src.T - src_mean
    Y = target.T - target_mean


    # we exploit the fact that W, as described in the given material, is a diagonal matrix.
    # instead of multiplying X @ W @ Y, we just multiply X element wise and obtain the same result.
    S = (X * w) @ Y.transpose()  # for d by n matrices

    U, _, Vt = np.linalg.svd(S)
    inner_mat = np.eye(d)
    inner_mat[-1, -1] = np.linalg.det(Vt.transpose() @ U)
    R = Vt.transpose() @ inner_mat @ U.transpose()

    # in this case, could do without inner matrix
    # if np.linalg.det(R) < 0:
    #     Vt[d - 1, :] *= -1
    # R = np.dot(Vt.T, U.T)
    # if np.sum(R2 - R) > 0.0001:
    #     raise 'weee'
    t = target_mean - R @ src_mean
    T = np.vstack((R.T, t.T))


    return T