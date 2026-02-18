#!/bin/bash -l
#SBATCH --time=4:00:00
#SBATCH --mem=24GB
#SBATCH --cpus-per-task=12
#SBATCH -J mriqc

set -eu # Stop on errors
umask 0002

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
source "${REPO_ROOT}/config.sh"

mriqc_version="${MRIQC_VERSION}"
IMG="${MRIQC_IMG}"
module add "${APPTAINER_MODULE}"
cache_dir="${CACHE_DIR}"
templateflow_dir="${TEMPLATEFLOW_DIR}"
export APPTAINERENV_TEMPLATEFLOW_HOME=$templateflow_dir

# Import arguments from job submission script
args=($@)
subjs=(${args[@]:1})
bids_dir=${1:-${BIDS_DIR}}

# index slurm array to grab subject
subject=${subjs[${SLURM_ARRAY_TASK_ID}]}
# Copy data to scratch
scratch=${SCRATCH_DIR}/$subject
mkdir -p ${scratch}/data/
cp -n $bids_dir/*.json ${scratch}/data/
cp -n $bids_dir/*.tsv ${scratch}/data/
cp -n $bids_dir/README ${scratch}/data/
cp -n $bids_dir/.bidsignore ${scratch}/data/
cp -nr $bids_dir/$subject/ ${scratch}/data/

# assign output directory
output_dir=${OUTPUT_DIR}/mriqc_${mriqc_version}/

# Define the command
if [ ! -d $output_dir/$subject/ ]; then
cmd="singularity run -e --containall -B ${scratch},${templateflow_dir},${cache_dir} $IMG $scratch/data/ $scratch/data/derivatives/mriqc participant --mem 23 --nprocs 12 --omp-nthreads 8 --participant_label ${subject:4} -w $scratch --participant-label $subject --no-sub -m ${MRIQC_MODALITIES}"

# Run the command
echo "Submitted job for: ${subject}"
echo "$'Command :'${cmd}"

${cmd}

# Copy outputs to final destination
mkdir -p $output_dir
cp -nr $scratch/data/derivatives/mriqc/$subject/ $output_dir/
cp -n $scratch/data/derivatives/mriqc/$subject*.html $output_dir/
fi
