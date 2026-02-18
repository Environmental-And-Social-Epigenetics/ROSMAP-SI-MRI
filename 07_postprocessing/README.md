# 07 Postprocessing (T1/T2 Ratio Along Tracts)

This stage extracts tract-level T1/T2 mean values from XCP and QSIRecon derivatives.

## Run Commands

Serial/cohort loop:

```bash
bash 07_postprocessing/t1t2_ratio/Pull_T1T2_ForcepsMinor_NoParallel.sh
```

Array-style script (submit with explicit array when needed):

```bash
sbatch --array=0-99 07_postprocessing/t1t2_ratio/Pull_T1T2_ForcepsMinor.sh
```

## Inputs

- `XCP_DERIV_DIR` from `config.sh`
- `QSIRECON_DERIV_DIR` from `config.sh`
- MRtrix available in `MRTRIX_CONDA_ENV`

## Outputs

- `${T1T2_OUTPUT_DIR}/sub-*_ses-*_t1t2_stats.csv`
- `${T1T2_OUTPUT_DIR}/t1t2_ratio_summary.csv`

## Verification

- Per-subject CSVs exist in `${T1T2_OUTPUT_DIR}`.
- Summary CSV contains subject/session rows and non-empty mean values.
- SLURM logs show `tcksample` success.

## SLURM Resources

### `Pull_T1T2_ForcepsMinor.sh`

- time: `24:00:00`
- memory: `500G`
- cores: `256`

### `Pull_T1T2_ForcepsMinor_NoParallel.sh`

- time: `47:00:00`
- memory: `256G`
- cores: `64`

## Troubleshooting

- If `tcksample` is missing, check `CONDA_SH_PATH` and `MRTRIX_CONDA_ENV`.
- If files are not found, verify `XCP_DERIV_DIR` and `QSIRECON_DERIV_DIR`.
- If summary file has missing values, inspect per-subject CSV generation and awk parsing.
