# 02 Quality Control (MRIQC)

This stage runs MRIQC on BIDS participants to generate image-quality metrics and per-subject HTML reports.

## Contents

- `mriqc/submit_job_array.sh`: submits participant-level MRIQC as a SLURM array.
- `mriqc/ss_mriqc.sh`: single-subject MRIQC execution script.
- `mriqc_t1_model.json`: model/config JSON preserved from original workflow.

## Pipeline Behavior

The scripts:

1. enumerate subjects from the BIDS root
2. copy required files to per-subject scratch space
3. run MRIQC container in participant mode
4. copy outputs (`.html` and derivatives folder) back to BIDS derivatives path

## Expected Environment

- SLURM scheduler
- Apptainer/Singularity module available
- MRIQC container image path defined in script
- TemplateFlow/cache directories available

## Important Notes

- Paths are currently hardcoded to the original cluster layout.
- Script currently targets modalities `T1w T2w bold`.
- Review memory/thread settings in `ss_mriqc.sh` before running in a new environment.
