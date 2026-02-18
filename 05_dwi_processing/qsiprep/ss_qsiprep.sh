#!/bin/bash -l
#SBATCH --time=2-00:00:00
#SBATCH --mem=16GB
#SBATCH --cpus-per-task=8
#SBATCH -J qsiprep
#SBATCH --constraint=rocky8
#SBATCH -p gablab

mem_mb="15500"
cpus="8"
omp_cpus="8"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
source "${REPO_ROOT}/config.sh"

cache_dir="${CACHE_DIR}"
module add "${APPTAINER_MODULE}"
set -eu # Code will stop on errors
umask 000
args=($@)
subjs=(${args[@]:1}) # Get subject names from array
# index slurm array to grab subject
subject=${subjs[${SLURM_ARRAY_TASK_ID}]}

qsiprep_version="${QSIPREP_VERSION}"
fs_version="${FREESURFER_VERSION}"
qsiprep_img="${QSIPREP_IMG}"

# assign working directory
# MAKE SURE THIS FOLDER WILL NOT BE WIPED WHILE YOU ARE PROCESSING
scratch=${SCRATCH_DIR}/${subject}
mkdir -p ${scratch}/data/derivatives/freesurfer
mkdir -p ${scratch}/data/code

# assign BIDS directory
bids_dir=${1:-${BIDS_DIR}}

# assign output directory
output_dir=${OUTPUT_DIR}
qsiprep_outdir=${output_dir}/qsiprep_${qsiprep_version}
qsirecon_outdir=${output_dir}/qsirecon_${qsiprep_version}

# Make single subject BIDS directory in scratch folder
cp -n $bids_dir/*.json ${scratch}/data/
cp -n $bids_dir/*.tsv ${scratch}/data/
cp -n $bids_dir/README ${scratch}/data/
cp -n $bids_dir/.bidsignore ${scratch}/data/
cp -nr $bids_dir/$subject/ ${scratch}/data/
fs_license="${FREESURFER_LICENSE}"
cp -n $fs_license $scratch/license.txt

# Copy Recon Spec to Scratch
recon_spec="${QSIPREP_RECON_SPEC}"
cp -f $recon_spec ${scratch}/recon_spec.json

# if FS outputs already exist, move them to scratch
if [ -d ${output_dir}/freesurfer_${fs_version}/$subject ]
	then cp -rn ${output_dir}/freesurfer_${fs_version}/$subject/ ${scratch}/data/derivatives/freesurfer/
fi

# Run QSIPrep
if [ ! -e $qsirecon_outdir/${subject}.html ]; then
cmd="singularity run --containall -e -B ${scratch},${cache_dir} ${qsiprep_img} $scratch/data $scratch/data/derivatives participant --participant_label ${subject:4} -w $scratch --unringing_method rpg --output-resolution 1.25 --recon-spec ${scratch}/recon_spec.json --freesurfer-input ${scratch}/data/derivatives/freesurfer/ --fs-license-file $scratch/license.txt --skip-odf-reports --notrack --mem-mb $mem_mb --nthreads $cpus --omp-nthreads $omp_cpus --ignore fieldmaps --use_syn_sdc --force_syn"
echo "Submitted job for: ${subject}"
echo $'Command :\n'${cmd}
${cmd}

# COPY QSIPrep OUTPUTS BACK TO ORIGINAL DRIVE
mkdir -p $qsiprep_outdir
cp -rn $scratch/data/derivatives/qsiprep/$subject $qsiprep_outdir/
cp -n $scratch/data/derivatives/qsiprep/${subject}.html $qsiprep_outdir/
cp -n $scratch/data/derivatives/qsiprep/*.json $qsiprep_outdir/

# COPY QSIRecon OUTPUTS BACK TO ORIGINAL DRIVE
mkdir -p $qsirecon_outdir
cp -rn $scratch/data/derivatives/qsirecon/$subject $qsirecon_outdir/
cp -n $scratch/data/derivatives/qsirecon/${subject}.html $qsirecon_outdir/

# REMOVE OLD OUTPUTS (optional)
if [[ -n "${QSIPREP_PREVIOUS_VERSION_TO_CLEAN}" ]]; then
rm -rf ${output_dir}/qsiprep_${QSIPREP_PREVIOUS_VERSION_TO_CLEAN}/${subject}/
rm -rf ${output_dir}/qsirecon_${QSIPREP_PREVIOUS_VERSION_TO_CLEAN}/${subject}/
rm -f ${output_dir}/qsiprep_${QSIPREP_PREVIOUS_VERSION_TO_CLEAN}/${subject}.html
rm -f ${output_dir}/qsirecon_${QSIPREP_PREVIOUS_VERSION_TO_CLEAN}/${subject}.html
fi

fi
