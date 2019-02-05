#!/bin/bash
#declare -a cluster_idxs=(1 2 3 4 5)
#qsub -v num_train=3,num_neg=3,cluster=1,sift=1,colorspace=6 matlab_job.sh
#for cluster_idx in "${cluster_idxs[@]}"
#do
#	qsub -v num_train=3,num_neg=3,cluster="$cluster_idx",sift=1,colorspace=6 matlab_job.sh
#done
#
#declare -a num_neg_idxs=(1 2 3)
#declare -a num_train_idxs=(1 2 3)
#for num_neg_idx in "${num_neg_idxs[@]}"
#do
#	for num_train_idx in "${num_train_idxs[@]}"
#	do
#		qsub -v num_train="$num_train_idx",num_neg="$num_neg_idx",cluster=1,sift=1,colorspace=6 matlab_job.sh
#	done
#done
#
#declare -a colorspace_idxs=(1 2 3 4 5 6)
#for colorspace_idx in "${colorspace_idxs[@]}"
#do
#	qsub -v num_train=3,num_neg=3,cluster=1,sift=1,colorspace="$colorspace_idx" matlab_job.sh
#done

declare -a colorspace_idxs=(1 2 3 4 5 6)
declare -a sift_step_idxs=(1 2 3 4)
declare -a sift_size_idxs=(1 2 3 4)

for sift_step_idx in "${sift_step_idxs[@]}"
do
	    for sift_size_idx in "${sift_size_idxs[@]}"
		        do
				    for colorspace_idx in "${colorspace_idxs[@]}"
					            do
							                qsub -v num_train=3,num_neg=3,cluster=1,sift=2,colorspace="$colorspace_idx",sift_size="$sift_size_idx",sift_step="$sift_step_idx" matlab_dense_job.sh
									        done
										    done
									    done
