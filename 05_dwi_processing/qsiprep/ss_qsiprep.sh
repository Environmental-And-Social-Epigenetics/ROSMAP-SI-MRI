#!/bin/bash -l
#SBATCH --time=2-00:00:00
#SBATCH --mem=16GB
#SBATCH --cpus-per-task=8
#SBATCH -J qsiprep
#SBATCH --constraint=rocky8
#SBATCH -p gablab

mem_mb="15500"
cpus="8"
omp_cpus="8"
cache_dir=/om2/user/smeisler/.cache
module add openmind8/apptainer/1.1.7
set -eu # Code will stop on errors
umask 000
args=($@)
subjs=(${args[@]:1}) # Get subject names from array
# index slurm array to grab subject
subject=${subjs[${SLURM_ARRAY_TASK_ID}]}

qsiprep_version="0.20.0"
fs_version="7.4.1" # Freesurfer version
# Confirm your singularity image matches this naming convention
qsiprep_img=/om2/user/smeisler/qsiprep_${qsiprep_version}.img 

# assign working directory
# MAKE SURE THIS FOLDER WILL NOT BE WIPED WHILE YOU ARE PROCESSING
scratch=/om2/scratch/tmp/$(whoami)/mri_proc/${subject}
mkdir -p ${scratch}/data/derivatives/freesurfer
mkdir -p ${scratch}/data/code

# assign BIDS directory
bids_dir=$1

# assign output directory
output_dir=${bids_dir}/derivatives/
#output_dir=/om2/scratch/tmp/mabdel03/Ravi_Mabdel_MRI/derivatives/
qsiprep_outdir=${output_dir}/qsiprep_${qsiprep_version}
qsirecon_outdir=${output_dir}/qsirecon_${qsiprep_version}

# Make single subject BIDS directory in scratch folder
cp -n $bids_dir/*.json ${scratch}/data/
cp -n $bids_dir/*.tsv ${scratch}/data/
cp -n $bids_dir/README ${scratch}/data/
cp -n $bids_dir/.bidsignore ${scratch}/data/
cp -nr $bids_dir/$subject/ ${scratch}/data/
fs_license=${bids_dir}/code/license.txt
cp -n $fs_license $scratch/license.txt

# Copy Recon Spec to Scratch
recon_spec=$bids_dir/code/qsiprep/recon_spec.json
cp -f $recon_spec ${scratch}/recon_spec.json

# if FS outputs already exist, move them to scratch
if [ -d ${output_dir}/freesurfer_${fs_version}/$subject ]
	then cp -rn ${output_dir}/freesurfer_${fs_version}/$subject/ ${scratch}/data/derivatives/freesurfer/
fi

# Run QSIPrep
if [ ! -e $qsirecon_outdir/${subject}.html ]; then
cmd="singularity run --containall -e -B ${scratch},${cache_dir} ${qsiprep_img} $scratch/data $scratch/data/derivatives participant --participant_label ${subject:4} -w $scratch --fs-license-file ${scratch}/data/code/license.txt --unringing_method rpg --output-resolution 1.25 --recon-spec ${scratch}/recon_spec.json --freesurfer-input ${scratch}/data/derivatives/freesurfer/ --fs-license-file $scratch/license.txt --skip-odf-reports --notrack --mem-mb $mem_mb --nthreads $cpus --omp-nthreads $omp_cpus --ignore fieldmaps --use_syn_sdc --force_syn"
echo "Submitted job for: ${subject}"
echo $'Command :\n'${cmd}
${cmd}

# COPY QSIPrep OUTPUTS BACK TO ORIGINAL DRIVE
mkdir -p $qsiprep_outdir
cp -rn $scratch/data/derivatives/qsiprep/$subject $qsiprep_outdir/
cp -n $scratch/data/derivatives/qsiprep/${subject}.html $qsiprep_outdir/
cp -n $scratch/data/derivatives/qsiprep/*.json $qsiprep_outdir/

# COPY QSIRecon OUTPUTS BACK TO ORIGINAL DRIVE
mkdir -p $qsirecon_outdir
cp -rn $scratch/data/derivatives/qsirecon/$subject $qsirecon_outdir/
cp -n $scratch/data/derivatives/qsirecon/${subject}.html $qsirecon_outdir/

# REMOVE OLD OUTPUTS
rm -rf /om2/user/mabdel03/files/Ravi_ISO_MRI/reformatted/derivatives/qsiprep_0.19.1/${subject}/
rm -rf /om2/user/mabdel03/files/Ravi_ISO_MRI/reformatted/derivatives/qsirecon_0.19.1/${subject}/
rm -f /om2/user/mabdel03/files/Ravi_ISO_MRI/reformatted/derivatives/qsiprep_0.19.1/${subject}.html
rm -f /om2/user/mabdel03/files/Ravi_ISO_MRI/reformatted/derivatives/qsirecon_0.19.1/${subject}.html

fi
