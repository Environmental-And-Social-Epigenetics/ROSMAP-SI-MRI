#!/bin/bash -l
#SBATCH --time=4:00:00
#SBATCH --mem=24GB
#SBATCH --cpus-per-task=12
#SBATCH -J mriqc

set -eu # Stop on errors
umask 0002
##### CHANGE THESE VARIABLES AS NEEDED ######
mriqc_version=22.0.6
IMG=/om2/user/smeisler/mriqc_${mriqc_version}.img
module add openmind8/apptainer/1.1.7
cache_dir="/om2/user/smeisler/.cache"
templateflow_dir=${cache_dir}/templateflow/
export APPTAINERENV_TEMPLATEFLOW_HOME=$templateflow_dir
#module add openmind/singularity/3.9.5
#############################################

# Import arguments from job submission script
args=($@)
subjs=(${args[@]:1})
bids_dir=$1

# index slurm array to grab subject
subject=${subjs[${SLURM_ARRAY_TASK_ID}]}
# Copy data to scratch
scratch=/om2/scratch/tmp/$(whoami)/mri_proc/$subject # assign working directory
mkdir -p ${scratch}/data/
cp -n $bids_dir/*.json ${scratch}/data/
cp -n $bids_dir/*.tsv ${scratch}/data/
cp -n $bids_dir/README ${scratch}/data/
cp -n $bids_dir/.bidsignore ${scratch}/data/
cp -nr $bids_dir/$subject/ ${scratch}/data/

# assign output directory
output_dir=${bids_dir}/derivatives/mriqc_${mriqc_version}/

# Define the command
if [ ! -d $output_dir/$subject/ ]; then
cmd="singularity run -e --containall -B ${scratch},${templateflow_dir},${cache_dir} $IMG $scratch/data/ $scratch/data/derivatives/mriqc participant --mem 23 --nprocs 12 --omp-nthreads 8 --participant_label ${subject:4} -w $scratch --participant-label $subject --no-sub -m T1w T2w bold"

# Run the command
echo "Submitted job for: ${subject}"
echo "$'Command :'${cmd}"

${cmd}

# Copy outputs to final destination
mkdir -p $output_dir
cp -nr $scratch/data/derivatives/mriqc/$subject/ $output_dir/
cp -n $scratch/data/derivatives/mriqc/$subject*.html $output_dir/
fi
