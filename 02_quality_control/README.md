# 02 Quality Control (MRIQC)

This stage runs MRIQC to produce participant-level QC metrics and HTML reports.

## Run Command

```bash
bash 02_quality_control/mriqc/submit_job_array.sh
```

Optional: pass explicit subject IDs:

```bash
bash 02_quality_control/mriqc/submit_job_array.sh sub-00123456 sub-00999999
```

## Inputs

- BIDS directory at `BIDS_DIR` from `config.sh`
- expected files:
  - `BIDS_DIR/sub-*/ses-*/anat/*T1w.nii.gz`
  - optional `T2w` and `bold` files
- container image at `MRIQC_IMG`

## Outputs

- `${OUTPUT_DIR}/mriqc_${MRIQC_VERSION}/sub-*/`
- `${OUTPUT_DIR}/mriqc_${MRIQC_VERSION}/sub-*.html`

## Verification

- One HTML file per completed subject in `${OUTPUT_DIR}/mriqc_${MRIQC_VERSION}/`.
- Subject folders are present under the same directory.
- SLURM logs show completed `singularity run` for each array task.

## SLURM Resources (per subject)

- time: `4:00:00`
- memory: `24GB`
- CPUs: `12`
- array throttle: `${MRIQC_ARRAY_CONCURRENCY}` from `config.sh`

## Troubleshooting

- If jobs fail immediately, check `MRIQC_IMG`, `CACHE_DIR`, and `TEMPLATEFLOW_DIR` in `config.sh`.
- If no subjects are found, verify `BIDS_DIR` and subject folder naming (`sub-*`).
- If reports are missing, inspect subject SLURM logs for mount/permission errors.
