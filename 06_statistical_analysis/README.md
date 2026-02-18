# 06 Statistical Analysis

This stage contains notebooks and wrangling files used for the final regression analyses.

## Run Commands

There is no single SLURM launcher in this stage. Typical workflow:

```bash
jupyter lab
```

Then run notebooks in:

- `06_statistical_analysis/data_wrangling/`
- `06_statistical_analysis/notebooks/`

## Inputs

- derivative outputs from stages 03, 04, and 05
- participant metadata (`metadata/patient_metadata_3t_raw.csv`)
- intermediate wrangling CSVs in `data_wrangling/`

## Outputs

- updated notebook outputs
- final model tables in `06_statistical_analysis/results/`
  - `ALFF_Results.csv`
  - `Anat_Results.csv`
  - `DWI_White_Matter_Results.csv`
  - `T1T2Ratio_Results.csv`

## Verification

- notebooks execute without cell errors in your environment
- result CSV files are generated/updated with expected row counts
- model outputs are consistent with available subjects in derivatives

## SLURM Resources

- Not directly defined for this stage (interactive/local notebook workflow).

## Troubleshooting

- If notebook imports fail, create a dedicated Python/R environment for analysis.
- If derivative files are missing, verify stages 03-05 completed successfully first.
- If subject counts mismatch, rerun wrangling notebooks before model notebooks.
