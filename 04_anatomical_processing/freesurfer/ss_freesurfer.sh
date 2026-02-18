#!/bin/bash -l 
#SBATCH --time=2-00:00:00
#SBATCH --mem=20GB
#SBATCH --cpus-per-task=8
#SBATCH -J freesurfer

set -eu # Stop on errors
umask 000

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
source "${REPO_ROOT}/config.sh"

version="${FREESURFER_VERSION}"
IMG="${FREESURFER_IMG}"
module add "${APPTAINER_MODULE}"

# Import arguments from job submission script
args=($@)
subjs=(${args[@]:1})
bids_dir=${1:-${BIDS_DIR}}

# index slurm array to grab subject
subject=${subjs[${SLURM_ARRAY_TASK_ID}]}

# Define scratch directory
scratch=${SCRATCH_DIR}/$subject
export APPTAINERENV_SUBJECTS_DIR=$scratch/data/derivatives/freesurfer/

mkdir -p ${scratch}/fs_files
mkdir -p ${scratch}/data/derivatives/freesurfer/

# assign output directory
output_dir=${OUTPUT_DIR}/freesurfer_${version}

# Copy license and fsaverage to scratch directory
license="${FREESURFER_LICENSE}"
cp -n $license $scratch/
fsaverage_path=${output_dir}/fsaverage/
cp -nr $fsaverage_path ${scratch}/data/derivatives/freesurfer/

# Copy anatomicals scratch directory
pushd $bids_dir

t1_file=$subject/ses*/anat/*T1w.nii.gz
cp -nL $bids_dir/$t1_file $scratch/fs_files/t1.nii.gz

t2_file=$subject/ses*/anat/*T2w.nii.gz
if [ -e $t2_file ]; then
cp -nL $bids_dir/$t2_file $scratch/fs_files/t2.nii.gz
t2_cmd_text="-T2 ${scratch}/fs_files/t2.nii.gz -T2pial"
else t2_cmd_text=''
fi
#t2_cmd_text=''
popd

# remove FS IsRunning files
rm -f $scratch/$subject/scripts/*Running*

# Define the command
pushd $scratch
cmd="singularity exec -e -B ${scratch},$scratch/license.txt:/usr/local/freesurfer/.license $IMG recon-all -subject $subject -i $scratch/fs_files/t1.nii.gz $t2_cmd_text -qcache -hires -openmp 8"

# Run the command
echo "Submitted job for: ${subject}"
echo "$'Command :\n'${cmd}"
${cmd}

# copy files back
mkdir -p $output_dir
cp -nr $scratch/data/derivatives/freesurfer/$subject $output_dir/
cp -nr $scratch/data/derivatives/freesurfer/fsaverage $output_dir/
popd
