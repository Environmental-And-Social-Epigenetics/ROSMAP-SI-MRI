# 04 Anatomical Processing (FreeSurfer + Tabulation)

This stage has two sequential sub-stages:

1. run FreeSurfer recon-all
2. tabulate cortical/subcortical outputs into analysis-ready tables

## Run Commands

### 04a FreeSurfer

```bash
bash 04_anatomical_processing/freesurfer/submit_job_array.sh
```

### 04b FreeSurfer Tabulate (run after 04a completes)

```bash
bash 04_anatomical_processing/freesurfer_tabulate/submit_job_array.sh
```

## Inputs

### FreeSurfer inputs

- `BIDS_DIR/sub-*/ses-*/anat/*T1w.nii.gz`
- optional `T2w` files
- `FREESURFER_IMG`
- `FREESURFER_LICENSE`

### Tabulate inputs

- `${OUTPUT_DIR}/freesurfer_${FREESURFER_VERSION}/sub-*`
- atlas files in `freesurfer_tabulate/annots/`
- `FMRIPREP_IMG`, `NEUROMAPS_IMG`

## Outputs

### FreeSurfer outputs

- `${OUTPUT_DIR}/freesurfer_${FREESURFER_VERSION}/sub-*`
- `${OUTPUT_DIR}/freesurfer_${FREESURFER_VERSION}/fsaverage`

### Tabulate outputs

- `${OUTPUT_DIR}/freesurfer_tabulate/sub-*/`
- per-subject `*brainmeasures.*` and `*regionsurfacestats.tsv`

## Verification

- FreeSurfer logs exist per subject under subject `scripts/`.
- Subject folders are present under `${OUTPUT_DIR}/freesurfer_${FREESURFER_VERSION}/`.
- Tabulation output files are present after stage 04b.

## SLURM Resources (per subject)

### FreeSurfer

- time: `2-00:00:00`
- memory: `20GB`
- CPUs: `8`
- array throttle: `${FREESURFER_ARRAY_CONCURRENCY}`

### FreeSurfer tabulate

- time: `3-00:00:00`
- memory: `8GB`
- CPUs: `4`
- array throttle: `${FS_TABULATE_ARRAY_CONCURRENCY}`

## Troubleshooting

- If FreeSurfer fails quickly, verify `FREESURFER_LICENSE` points to a real license file.
- If tabulate fails on atlas conversion, verify annotation files and container image paths.
- If no subjects are found for tabulation, confirm FreeSurfer output directories exist first.
