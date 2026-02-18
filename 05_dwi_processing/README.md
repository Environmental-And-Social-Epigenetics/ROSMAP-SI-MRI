# 05 DWI Processing (QSIPrep + QSIRecon)

This stage runs diffusion preprocessing and reconstruction/tracking using QSIPrep/QSIRecon.

## Contents

- `qsiprep/submit_job_array.sh`: SLURM array launcher.
- `qsiprep/ss_qsiprep.sh`: participant-level run script.
- `qsiprep/recon_spec.json`: reconstruction specification (DSI Studio GQI + AutoTrack pipeline).

## Pipeline Behavior

`ss_qsiprep.sh` performs:

1. participant-level scratch setup and input copying
2. optional reuse of FreeSurfer outputs
3. QSIPrep preprocessing
4. QSIRecon reconstruction based on `recon_spec.json`
5. copying of `qsiprep_*` and `qsirecon_*` outputs back to derivatives

The reconstruction spec includes:

- GQI reconstruction
- scalar export
- AutoTrack tractography with predefined bundle groups

## Dependencies/Assumptions

- SLURM + Apptainer/Singularity
- QSIPrep container available in configured location
- FreeSurfer license and derivatives available when requested

## Important Notes

- Only the current scripts/spec were copied; archived and temporary variants were intentionally excluded.
- Script includes explicit path cleanup logic tied to prior versioned derivative directories.
- Validate flags (`--ignore fieldmaps`, `--use_syn_sdc`) for your desired rerun policy.
