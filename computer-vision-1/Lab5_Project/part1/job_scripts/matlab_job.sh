#PBS -S /bin/bash
#PBS -lnodes=1
#PBS -lwalltime=10:00:00
#PBS -e "$HOME"/computer-vision-1/Lab5_Project/part1/data/main_func_"$num_train"_"$num_neg"_"$cluster"_"$sift"_"$colorspace"_`date +%Y_%m_%d_%H:%M:%S`_error.log
#PBS -o "$HOME"/computer-vision-1/Lab5_Project/part1/data/main_func_"$num_train"_"$num_neg"_"$cluster"_"$sift"_"$colorspace"_`date +%Y_%m_%d_%H:%M:%S`_output.log
module load mcr/2017b

NAME="data_collect_"$num_train"_"$num_neg"_"$cluster"_"$sift"_"$colorspace""

echo "Job $PBS_JOBID started at `date`; $NAME is started" | mail $USER -s "Job $PBS_JOBID"
echo "Job $PBS_JOBID started at `date`; $NAME is started" > "$TMPDIR"/"$NAME".log

cd "$HOME"/computer-vision-1/Lab5_Project/part1

cp -r ../Caltech4 "$TMPDIR"/

./main_func "$TMPDIR" "$num_train" "$num_neg" "$cluster" "$sift" "$colorspace" >> "$TMPDIR"/"$NAME".log 2>&1

echo "Job $PBS_JOBID ended at `date`; $NAME has ended " | mail $USER -s "Job $PBS_JOBID"
echo "Job $PBS_JOBID ended at `date`; $NAME has ended" >> "$TMPDIR"/"$NAME".log

cp "$TMPDIR"/"$NAME".log "$HOME"/computer-vision-1/Lab5_Project/part1/data
cp -r "$TMPDIR"/data/* "$HOME"/computer-vision-1/Lab5_Project/part1/data
