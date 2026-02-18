# 05 DWI Processing (QSIPrep + QSIRecon)

This stage runs diffusion preprocessing with QSIPrep and reconstruction/tracking with QSIRecon.

## Run Command

```bash
bash 05_dwi_processing/qsiprep/submit_job_array.sh
```

Optional subject subset:

```bash
bash 05_dwi_processing/qsiprep/submit_job_array.sh sub-00123456
```

## Inputs

- `BIDS_DIR/sub-*/ses-*/dwi/*dwi.nii.gz`
- corresponding `.bval`, `.bvec`, and sidecar JSON files
- `QSIPREP_IMG`
- recon specification file at `QSIPREP_RECON_SPEC`
- optional FreeSurfer outputs under `${OUTPUT_DIR}/freesurfer_${FREESURFER_VERSION}/`

## Outputs

- `${OUTPUT_DIR}/qsiprep_${QSIPREP_VERSION}/sub-*`
- `${OUTPUT_DIR}/qsirecon_${QSIPREP_VERSION}/sub-*`
- subject HTML reports in both output trees

## Verification

- Subject folders and HTML files are created in both qsiprep and qsirecon outputs.
- SLURM logs show successful completion of singularity run command.
- Tract/reconstruction derivatives exist for expected subjects.

## SLURM Resources (per subject)

- time: `2-00:00:00`
- memory: `16GB`
- CPUs: `8`
- array throttle: `${QSIPREP_ARRAY_CONCURRENCY}`

## Troubleshooting

- If jobs fail before launch, verify `QSIPREP_IMG`, `CACHE_DIR`, and `QSIPREP_RECON_SPEC`.
- If FreeSurfer-based reconstruction fails, confirm `${OUTPUT_DIR}/freesurfer_${FREESURFER_VERSION}/sub-*` exists.
- If cleanup deletes wrong outputs, leave `QSIPREP_PREVIOUS_VERSION_TO_CLEAN` empty in `config.sh`.
