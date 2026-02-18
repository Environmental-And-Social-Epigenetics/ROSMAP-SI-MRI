# 03 fMRI Processing (fMRIPrep + XCP-D)

This stage runs participant-level fMRIPrep and then attempts XCP-D postprocessing.

## Run Command

```bash
bash 03_fmri_processing/fmriprep_xcp/submit_job_array.sh
```

Optional subject subset:

```bash
bash 03_fmri_processing/fmriprep_xcp/submit_job_array.sh sub-00123456
```

## Inputs

- BIDS directory at `BIDS_DIR`
- expected files:
  - `BIDS_DIR/sub-*/ses-*/func/*bold.nii.gz`
  - `BIDS_DIR/sub-*/ses-*/anat/*T1w.nii.gz`
- `FMRIPREP_IMG`, `XCP_IMG`
- FreeSurfer license at `FREESURFER_LICENSE`

## Outputs

- `${OUTPUT_DIR}/fmriprep_${FMRIPREP_VERSION}/`
- `${OUTPUT_DIR}/freesurfer_${FREESURFER_VERSION}/` (reuse/continuation)
- `${OUTPUT_DIR}/xcp_d_${XCP_VERSION}/` (if XCP execution is enabled)

## Verification

- fMRIPrep subject folders and HTML files appear in `${OUTPUT_DIR}/fmriprep_${FMRIPREP_VERSION}/`.
- FreeSurfer subject folders appear in `${OUTPUT_DIR}/freesurfer_${FREESURFER_VERSION}/`.
- If XCP is enabled, outputs appear in `${OUTPUT_DIR}/xcp_d_${XCP_VERSION}/`.

## SLURM Resources (per subject)

- time: `2-00:00:00`
- memory: `16GB`
- CPUs: `4`
- array throttle: `${FMRIPREP_ARRAY_CONCURRENCY}` from `config.sh`

## Troubleshooting

- If fMRIPrep fails at startup, check `FMRIPREP_IMG`, `TEMPLATEFLOW_DIR`, and `CACHE_DIR`.
- If FreeSurfer reuse fails, verify `${OUTPUT_DIR}/freesurfer_${FREESURFER_VERSION}/` exists and is readable.
- If no outputs are copied back, inspect subject-level scratch paths and copy commands in logs.
