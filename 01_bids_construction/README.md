# 01 BIDS Construction

This stage contains historical Python scripts used to build and repair the BIDS structure before MRI processing.

## Run Command

There is no single launcher script for this stage. Run scripts manually in sequence, for example:

```bash
python 01_bids_construction/scripts/Copy_Files.py
python 01_bids_construction/scripts/Organize.py
python 01_bids_construction/scripts/Rename2.py
python 01_bids_construction/scripts/MetaAddition.py
python 01_bids_construction/scripts/Correct_Fmap-HARDI_Meta.py
python 01_bids_construction/scripts/EPI_Corrections.py
python 01_bids_construction/scripts/Bold_DWI_PEDs.py
```

## Recommended Execution Order

1. `Copy_Files.py`
2. `Organize.py`
3. `Rename2.py` (or `Rename.py` + correction scripts)
4. `MetaAddition.py`
5. `Correct_Fmap-HARDI_Meta.py`
6. `EPI_Corrections.py`
7. `Bold_DWI_PEDs.py`
8. `FMAP_less_subjects.py` and `Move_FMAP_less.py` (if missing fieldmaps need handling)
9. cleanup/fixes: `move_T2.py`, `Rem_Extras.py`, `DebugRename.py`, `Rename_Move_Met_New.py`

## Inputs

- `reference_csvs/OG_Locations.csv`
- `reference_csvs/Openmind_Directoris.csv`
- source raw MRI directories referenced by those CSVs

## Outputs

- BIDS-like tree under your target BIDS root:
  - `sub-*/ses-*/anat/*`
  - `sub-*/ses-*/dwi/*`
  - `sub-*/ses-*/func/*`
  - `sub-*/ses-*/fmap/*` (when available)
- updated sidecar JSON metadata
- optional missing-fieldmap tracking table (`fmap_less.csv`)

## Verification

- Confirm every subject/session has expected modality subfolders.
- Confirm expected BIDS filenames exist in each modality folder.
- Spot-check JSON sidecars for key fields (`IntendedFor`, `PhaseEncodingDirection`, echo/readout values).
- Validate folder structure against `example_bids_structure/`.

## SLURM Resources

- Not applicable in this stage (manual/local Python scripts).

## Troubleshooting

- If files are not found, verify CSV paths and mounted source storage.
- If metadata fields are missing, rerun metadata scripts after rename/folder corrections.
- If scripts fail due to absolute paths, update paths inside scripts or adapt wrappers before rerun.
