# 01 BIDS Construction

This stage contains scripts and reference tables used to construct and clean the BIDS dataset layout before running processing pipelines.

## Contents

- `scripts/`: Python scripts for copy, organize, rename, and metadata repair.
- `reference_csvs/`: lookup and location tables used by scripts.
- `example_bids_structure/`: JSON-only example of a BIDS subject/session tree.

## Key Scripts

- `Copy_Files.py`: copies raw subject directories into a new reformatted root.
- `Organize.py`: creates modality subfolders (`anat`, `dwi`, `func`, `fmap`) and moves files.
- `Rename.py`, `Rename2.py`, `DebugRename.py`, `Rename_Move_Met_New.py`: apply BIDS naming conventions and corrections.
- `MetaAddition.py`, `Correct_Fmap-HARDI_Meta.py`, `EPI_Corrections.py`, `Bold_DWI_PEDs.py`: add or correct metadata in JSON sidecars.
- `FMAP_less_subjects.py`, `Move_FMAP_less.py`: identify and separate subjects missing fieldmaps.
- `move_T2.py`, `Rem_Extras.py`: additional cleanup/placement scripts.

## Reference Tables

- `reference_csvs/OG_Locations.csv`: source raw locations by subject/session.
- `reference_csvs/Openmind_Directoris.csv`: mapped destination locations used by multiple scripts.
- `reference_csvs/fmap_less.csv`: subjects detected with missing fieldmaps.

## Example BIDS Structure

`example_bids_structure/` includes:

- `dataset_description.json`
- one subject/session with JSON sidecars for `anat`, `dwi`, `fmap`, and `func`

This is included as a lightweight structural example without NIfTI data.

## Important Notes

- Most scripts use hardcoded absolute paths from the original cluster environment.
- Script order matters; these were historically run as iterative cleanup passes.
- Review each script before rerunning and parameterize paths for a new environment.
