#!/usr/bin/env bash
# Central configuration for the ROSMAP MRI pipeline repository.
# Edit this file once after cloning, then run stage scripts.

export ROSMAP_REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#############################
# Core dataset/run locations
#############################
export BIDS_DIR="/path/to/bids_dataset"
export SCRATCH_DIR="/path/to/scratch/${USER}/mri_proc"
export OUTPUT_DIR="${BIDS_DIR}/derivatives"

#############################
# Container and cache paths
#############################
export CONTAINER_DIR="/path/to/container_images"
export CACHE_DIR="/path/to/.cache"
export TEMPLATEFLOW_DIR="${CACHE_DIR}/templateflow"
export FREESURFER_LICENSE="/path/to/freesurfer/license.txt"

#############################
# Versions
#############################
export FMRIPREP_VERSION="23.2.0a3"
export XCP_VERSION="0.6.0"
export FREESURFER_VERSION="7.4.1"
export MRIQC_VERSION="22.0.6"
export QSIPREP_VERSION="0.20.0"
export NEUROMAPS_VERSION="0.0.5dev"

#############################
# Container image paths
#############################
export FMRIPREP_IMG="${CONTAINER_DIR}/fmriprep_${FMRIPREP_VERSION}.img"
export XCP_IMG="${CONTAINER_DIR}/xcp_d_${XCP_VERSION}.img"
export FREESURFER_IMG="${CONTAINER_DIR}/freesurfer_${FREESURFER_VERSION}.img"
export MRIQC_IMG="${CONTAINER_DIR}/mriqc_${MRIQC_VERSION}.img"
export QSIPREP_IMG="${CONTAINER_DIR}/qsiprep_${QSIPREP_VERSION}.img"
export NEUROMAPS_IMG="${CONTAINER_DIR}/neuromaps_${NEUROMAPS_VERSION}.img"

#############################
# Cluster modules
#############################
export APPTAINER_MODULE="openmind8/apptainer/1.1.7"
export MATLAB_MODULE="mit/matlab/2023a"
export FREESURFER_HELPER_MODULE="openmind/freesurfer/6.0.0"

#############################
# SLURM array throttles
#############################
export MRIQC_ARRAY_CONCURRENCY="80"
export FMRIPREP_ARRAY_CONCURRENCY="120"
export FREESURFER_ARRAY_CONCURRENCY="100"
export FS_TABULATE_ARRAY_CONCURRENCY="120"
export QSIPREP_ARRAY_CONCURRENCY="80"

#############################
# Stage-specific config
#############################
export MRIQC_MODALITIES="T1w T2w bold"

export FS_TABULATE_DIR="${ROSMAP_REPO_ROOT}/04_anatomical_processing/freesurfer_tabulate"
export QSIPREP_RECON_SPEC="${ROSMAP_REPO_ROOT}/05_dwi_processing/qsiprep/recon_spec.json"

# Optional: set to a prior qsiprep version (e.g., 0.19.1) to auto-clean old outputs.
# Leave empty to disable cleanup.
export QSIPREP_PREVIOUS_VERSION_TO_CLEAN=""

#############################
# Postprocessing config
#############################
export CONDA_SH_PATH="/path/to/anaconda/etc/profile.d/conda.sh"
export MRTRIX_CONDA_ENV="/path/to/conda_envs/MRtrix"
export XCP_DERIV_DIR="${OUTPUT_DIR}/xcp_d_${XCP_VERSION}"
export QSIRECON_DERIV_DIR="${OUTPUT_DIR}/qsirecon_${QSIPREP_VERSION}"
export T1T2_OUTPUT_DIR="${ROSMAP_REPO_ROOT}/07_postprocessing/t1t2_ratio/t1t2_ratio_results"

#############################
# Transfer defaults (optional)
#############################
export TRANSFER_SOURCE_ENDPOINT=""
export TRANSFER_DEST_ENDPOINT=""
export TRANSFER_SOURCE_DIR="${BIDS_DIR}"
export TRANSFER_DEST_DIR=""
