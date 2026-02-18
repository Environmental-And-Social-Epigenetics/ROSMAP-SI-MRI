# 06 Statistical Analysis

This stage captures analysis notebooks, data wrangling artifacts, and final model result tables used for the social isolation MRI analyses.

## Contents

### Modeling Notebooks

- `notebooks/r_stats.ipynb`
- `notebooks/r_stats_Mahmoud.ipynb`
- `notebooks/r_stats_Mahmoud_AllRegions.ipynb`
- `notebooks/r_stats_Mahmoud_Figures.ipynb`
- `notebooks/Mahmoud_HemiAveraged_r_stats.ipynb`
- `notebooks/Steve_Scripts/r_stats.ipynb`

### Data Wrangling

- `data_wrangling/slm_data_wrangle.ipynb`
- `data_wrangling/slm_add_qc.ipynb`
- `data_wrangling/site_check.ipynb`
- `data_wrangling/Count_Patients.ipynb`
- supporting CSVs (`slm_data*.csv`, `projid_dataframe.csv`)

### Final Results

- `results/ALFF_Results.csv`
- `results/Anat_Results.csv`
- `results/DWI_White_Matter_Results.csv`
- `results/T1T2Ratio_Results.csv`

## Outcome Domains Covered

- ALFF/fMRI-derived metrics
- anatomical measures
- DWI white matter metrics
- T1/T2 ratio measures

## Important Notes

- Notebook checkpoint files were intentionally excluded.
- Notebooks preserve the original development state, including historical path references.
- Some analyses depend on derivative outputs that are not stored in this repository.
