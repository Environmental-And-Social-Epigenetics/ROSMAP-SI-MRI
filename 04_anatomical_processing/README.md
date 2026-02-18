# 04 Anatomical Processing (FreeSurfer + Tabulation)

This stage contains two related workflows:

1. FreeSurfer surface reconstruction from anatomical MRI
2. post-recon extraction/tabulation of atlas-based anatomical metrics

## Contents

### FreeSurfer

- `freesurfer/submit_job_array.sh`
- `freesurfer/ss_freesurfer.sh`
- `freesurfer/license.txt`

### FreeSurfer Tabulate

- `freesurfer_tabulate/` copied as a full utility package
- includes shell/Python scripts, atlas annotation files (`annots/`), and template resources (`cpac_templates/`)
- includes internal tool README: `freesurfer_tabulate/README.md`

## FreeSurfer Workflow

`ss_freesurfer.sh`:

1. prepares scratch directories
2. copies T1w (and optional T2w) images
3. runs `recon-all` inside container
4. copies subject outputs back to BIDS derivatives

## FreeSurfer Tabulate Workflow

`ss_fs_tabulate.sh` and helper scripts:

- compute subject-level brain measures and region/surface statistics
- generate tabular outputs for many atlases
- support group-level combination (`group_combine.py`) and parquet export
- include optional CIFTI-related conversion scripts

## Important Notes

- Internal `.git` and `.datalad` directories from the original tabulation toolkit were excluded.
- Cluster paths, modules, and container references reflect the original environment.
- Review FreeSurfer version compatibility across all scripts before reprocessing.
