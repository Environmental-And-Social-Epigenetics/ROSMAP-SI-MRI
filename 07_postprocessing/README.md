# 07 Postprocessing (T1/T2 Ratio Along Tracts)

This stage contains scripts used to compute mean T1/T2 ratio values sampled along selected white matter tracts.

## Contents

- `t1t2_ratio/Pull_T1T2_ForcepsMinor.sh`
- `t1t2_ratio/Pull_T1T2_ForcepsMinor_NoParallel.sh`

## Workflow Summary

These scripts:

1. load MRtrix tooling from a configured conda environment
2. locate subject/session-level T1/T2-ratio NIfTI images and tract `.tck` files
3. use MRtrix sampling/statistics commands to extract tract-level summary values
4. write per-subject CSV outputs and aggregate summary CSV

## Parallel vs Non-Parallel

- `Pull_T1T2_ForcepsMinor.sh`: SLURM array-oriented parallel strategy.
- `Pull_T1T2_ForcepsMinor_NoParallel.sh`: single-job serial/loop version.

## Important Notes

- Scripts use hardcoded input directories from a specific derivative layout.
- Resource requests are high in the parallel script; tune for your scheduler limits.
- Confirm MRtrix command availability after environment activation.
