# 03 fMRI Processing (fMRIPrep + XCP-D)

This stage runs fMRIPrep followed by XCP-D for resting-state fMRI preprocessing and denoised derivative generation.

## Contents

- `fmriprep_xcp/submit_job_array.sh`: submits fMRI processing across subjects.
- `fmriprep_xcp/ss_fmriprep_xcp.sh`: participant-level fMRIPrep + XCP-D script.

## Pipeline Behavior

The script workflow is:

1. receive BIDS root and subject list from SLURM array launcher
2. create per-subject scratch workspace
3. copy participant BIDS files and required root files
4. optionally pull prior FreeSurfer outputs into scratch for reuse
5. run fMRIPrep container
6. run XCP-D container on fMRIPrep outputs
7. copy resulting derivatives back to the output directory

## Dependencies/Assumptions

- SLURM array execution
- Apptainer/Singularity module
- fMRIPrep and XCP-D container images available at configured paths
- FreeSurfer license file at BIDS `code/license.txt`
- TemplateFlow/cache setup

## Important Notes

- This directory intentionally keeps only the main script variants (temporary scripts were excluded).
- Script currently contains hardcoded original cluster paths and versions.
- Validate output directory and cache paths before rerunning on a new system.
