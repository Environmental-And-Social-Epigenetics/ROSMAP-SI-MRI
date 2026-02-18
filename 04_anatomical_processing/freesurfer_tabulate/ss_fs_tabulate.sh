#!/bin/bash -l 
#SBATCH --time=3-00:00:00
#SBATCH --mem=8GB
#SBATCH --cpus-per-task=4
#SBATCH -J fs_table
#SBATCH -p gablab

umask 000

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
source "${REPO_ROOT}/config.sh"

fmriprep_version="${FMRIPREP_VERSION}"
neuromaps_version="${NEUROMAPS_VERSION}"
freesurfer_version="${FREESURFER_VERSION}"
fmriprep_IMG="${FMRIPREP_IMG}"
neuromaps_IMG="${NEUROMAPS_IMG}"

module add "${APPTAINER_MODULE}"
module load "${MATLAB_MODULE}"
module load "${FREESURFER_HELPER_MODULE}"

set +eu # Code will stop on errors

# Import arguments from job submission script
args=($@)
subjs=(${args[@]:1})
bids_dir=${1:-${BIDS_DIR}}
fs_license="${FREESURFER_LICENSE}"
fs_tabulate_dir="${FS_TABULATE_DIR}"

# index slurm array to grab subject
subject=${subjs[${SLURM_ARRAY_TASK_ID}]}

# get FS directory
fs_sub_dir=${OUTPUT_DIR}/freesurfer_${freesurfer_version}

# assign output directory
output_dir=${OUTPUT_DIR}/freesurfer_tabulate/$subject/

# Remove FS temp files
rm -f ${fs_sub_dir}/${subject}/scripts/*Running*
rm -rf ${fs_sub_dir}/${subject}/surf/tmp*/
rm -f ${fs_sub_dir}/${subject}/surf/*pial*/
rm -f ${fs_sub_dir}/${subject}/*.tsv
rm -fr ${fs_sub_dir}/${subject}/trash/*

# Run the command
export FREESURFER_LICENSE="${fs_license}"
${fs_tabulate_dir}/collect_stats_to_tsv.sh $subject $fs_sub_dir $fmriprep_IMG $neuromaps_IMG $output_dir
