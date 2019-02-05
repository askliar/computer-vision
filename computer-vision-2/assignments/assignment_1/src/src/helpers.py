import os 
import numpy as np
import re
from xml.etree import ElementTree

def read_pcd(file):
    with open(file, 'r') as f:
        data = f.readlines()

    x, y, z = list(map(lambda x: np.array(x).astype(np.float),
                       zip(*[line.split() for line in data])))

    return x, y, z


def read_data(file):
    with open(file, 'r') as f:
        sourcedata = f.readlines()

    source = np.array([data_str.split()
                       for data_str in sourcedata]).astype(np.float)
    return source


def read_xml(data_dir, files):
    pose_dict = {}
    for i, file in enumerate(files):
        if file.endswith(".xml"):
            xml = ElementTree.parse(file)
            pose_data = {'intrinsic': None, 'R': None, 't': None}
            for key in pose_data.keys():
                xml_root = xml.findall(f'.//{key}')[0]
                rows = int(xml_root.findall('.//rows')[0].text)
                cols = int(xml_root.findall('.//cols')[0].text)
                arr = np.array([float(i) for i
                                in xml_root.findall('.//data')[0].text.strip().split()])\
                    .reshape(rows, cols)
                pose_data[key] = arr
            pose_dict[i] = pose_data
    return pose_dict

def get_files(data_dir, extension):
    filtered_files = []
    for root, _, files in os.walk(data_dir):
        for file in sorted(files):
            if file.endswith(extension):
                filtered_files.append(os.path.join(root, file))
    return filtered_files

def sample_uniform(vector_size, sample_size=1000):
    idxs = np.random.choice(vector_size, sample_size, replace=False)
    return idxs

def depth2cloud(depth, fx, fy, cx, cy):
    m, n = depth.shape

    X = (np.ones((m, 1)) * np.arange(1, n+1).reshape(1, n) - cx) * depth * (1/fx)
    Y = (np.arange(1, m+1).reshape(m, 1) *
         np.ones((1, n)) - cy) * depth * (1/fy)
    ordered = np.stack((X.flatten(), Y.flatten(), depth.flatten()))
    ordered = ordered[:, np.where(ordered.any(axis=0))[0]]

    return ordered

def make_homogeneous(x):
    return np.hstack((x, np.ones((x.shape[0], 1))))

def make_homogeneous_T(x):
    T = np.hstack((x, np.zeros((x.shape[0], 1))))
    T[-1, -1] = 1.
    return T

def clean_pcds(pcd_files, normal_files):
    new_files = []
    new_files_normal = []
    for i, file in enumerate(pcd_files):
        file_id = re.search(r'(\d{5}\d+)', file).group()
        array = np.array(read_pcd(file))
        array_normal = np.array(read_pcd(normal_files[i]).T)
        meanZ = np.mean(array[2, :])
        idxs = np.where(array[2, :] <= 1.7)[0]
        filtered_array = array[:, idxs].T
        filtered_array_normal = array_normal[:, idxs].T

        newname = os.path.join(os.path.dirname(file), f'{file_id}_clean.txt')
        newname_normal = os.path.join(os.path.dirname(file), f'{file_id}_normal_clean.txt')

        np.savetxt(newname, filtered_array)
        np.savetxt(newname_normal, filtered_array_normal)
        new_files.append(newname)
        new_files_normal.append(newname_normal)

    return new_files, new_files_normal
