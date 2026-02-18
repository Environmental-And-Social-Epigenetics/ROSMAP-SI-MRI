#!/bin/bash -l 
#SBATCH --time=3-00:00:00
#SBATCH --mem=8GB
#SBATCH --cpus-per-task=4
#SBATCH -J fs_table
#SBATCH -p gablab

umask 000
##### CHANGE THESE VARIABLES AS NEEDED ######
fmriprep_version=23.2.0a3
neuromaps_version=0.0.5dev
freesurfer_version=7.4.1
path_to_imgs=/om2/user/smeisler/
fmriprep_IMG=${path_to_imgs}/fmriprep_${fmriprep_version}.img
neuromaps_IMG=${path_to_imgs}/neuromaps_${neuromaps_version}.img

module add openmind8/apptainer/1.1.7
module load mit/matlab/2023a
module load openmind/freesurfer/6.0.0
#############################################

set +eu # Code will stop on errors

# Import arguments from job submission script
args=($@)
subjs=(${args[@]:1})
bids_dir=$1
fs_license=$bids_dir/code/license.txt
fs_tabulate_dir=$bids_dir/code/freesurfer_tabulate

# index slurm array to grab subject
subject=${subjs[${SLURM_ARRAY_TASK_ID}]}

# get FS directory
fs_sub_dir=$bids_dir/derivatives/freesurfer_${freesurfer_version}

# assign output directory
output_dir=${bids_dir}/derivatives/freesurfer_tabulate/$subject/
#mkdir -p ${output_dir}
#output_dir=/om2/scratch/tmp/mabdel03/Ravi_Mabdel_MRI/derivatives/

# Define scratch directory
#scratch=/om2/scratch/tmp/$(whoami)/mri_proc/$subject/ # assign working directory
#mkdir -p ${scratch}/data/derivatives/fmriprep/
#mkdir -p ${scratch}/data/derivatives/freesurfer/
# Copy data to scratch
#cp -n $bids_dir/*.json ${scratch}/data/
#cp -n $bids_dir/*.tsv ${scratch}/data/
#cp -n $bids_dir/README ${scratch}/data/
#cp -n $bids_dir/.bidsignore ${scratch}/data/
#cp -nr $bids_dir/$subject/ ${scratch}/data/
#cp -n $fs_license ${scratch}/license.txt
# If FS outputs already exist, move them to scratch
#if [ -d ${output_dir}/freesurfer_${freesurfer_version}/$subject ]
#then cp -rn ${output_dir}/freesurfer_${freesurfer_version}/$subject/ ${scratch}/data/derivatives/freesurfer/
#fi
# Remove FS temp files
rm -f ${fs_sub_dir}/${subject}/scripts/*Running*
rm -rf ${fs_sub_dir}/${subject}/surf/tmp*/
rm -f ${fs_sub_dir}/${subject}/surf/*pial*/
rm -f ${fs_sub_dir}/${subject}/*.tsv
rm -fr ${fs_sub_dir}/${subject}/trash/*
#rm -f ${scratch}/data/derivatives/freesurfer/$subject/scripts/*Running*
#cd $scratch

# Run the command
${fs_tabulate_dir}/collect_stats_to_tsv.sh $subject $fs_sub_dir $fmriprep_IMG $neuromaps_IMG $output_dir
