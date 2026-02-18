#!/bin/bash -l 
#SBATCH --time=2-00:00:00
#SBATCH --mem=16GB
#SBATCH --cpus-per-task=4
#SBATCH -J func_proc

mem_mb="15500"
mem_gb="15"
nprocs="4"
omp_nprocs="4"
umask 000

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
source "${REPO_ROOT}/config.sh"

fmriprep_version="${FMRIPREP_VERSION}"
freesurfer_version="${FREESURFER_VERSION}"
xcp_version="${XCP_VERSION}"
fmriprep_IMG="${FMRIPREP_IMG}"
xcp_IMG="${XCP_IMG}"
module add "${APPTAINER_MODULE}"
templateflow_dir="${TEMPLATEFLOW_DIR}"
export APPTAINERENV_TEMPLATEFLOW_HOME=$templateflow_dir
cache_dir="${CACHE_DIR}"

set -eu # Code will stop on errors

# Import arguments from job submission script
args=($@)
subjs=(${args[@]:1})
bids_dir=${1:-${BIDS_DIR}}
fs_license="${FREESURFER_LICENSE}"

# index slurm array to grab subject
subject=${subjs[${SLURM_ARRAY_TASK_ID}]}

# Define scratch directory
scratch=${SCRATCH_DIR}/$subject
mkdir -p ${scratch}/data/derivatives/fmriprep/
mkdir -p ${scratch}/data/derivatives/freesurfer/

# assign output directory
output_dir=${OUTPUT_DIR}

# Copy data to scratch
cp -n $bids_dir/*.json ${scratch}/data/
cp -n $bids_dir/*.tsv ${scratch}/data/
cp -n $bids_dir/README ${scratch}/data/
cp -n $bids_dir/.bidsignore ${scratch}/data/
cp -nr $bids_dir/$subject/ ${scratch}/data/
cp -n $fs_license ${scratch}/license.txt

# If FS outputs already exist, move them to scratch
if [ -d ${output_dir}/freesurfer_${freesurfer_version}/$subject ]
then cp -rn ${output_dir}/freesurfer_${freesurfer_version}/$subject/ ${scratch}/data/derivatives/freesurfer/
fi

# Remove FS temp files
rm -f ${scratch}/data/derivatives/freesurfer/$subject/scripts/*Running*

cd $scratch

# Do fMRIPrep
if [ ! -e $output_dir/fmriprep_${fmriprep_version}/${subject}.html ]; then
	# define the command
	fmriprep_cmd="singularity run -e --containall -B ${scratch},${templateflow_dir},${cache_dir} $fmriprep_IMG --participant_label ${subject:4} -w $scratch --skip-bids-validation --fs-license-file ${scratch}/license.txt --fs-subjects-dir ${scratch}/data/derivatives/freesurfer/ --project-goodvoxels --notrack --cifti-output 91k --slice-time-ref 0 --mem_mb ${mem_mb} --nprocs ${nprocs} --omp-nthreads ${omp_nprocs} $scratch/data $scratch/data/derivatives/fmriprep participant"

	# run the command
	echo "Submitted fmriprep job for: ${subject}"
	echo $'Command :\n'${fmriprep_cmd}
	${fmriprep_cmd}

	# Copy data back to final destination
	mkdir -p ${output_dir}/fmriprep_${fmriprep_version}/
	mkdir -p ${output_dir}/freesurfer_${freesurfer_version}/
	cp -rn $scratch/data/derivatives/fmriprep/$subject ${output_dir}/fmriprep_${fmriprep_version}/
	cp -n $scratch/data/derivatives/fmriprep/*.* ${output_dir}/fmriprep_${fmriprep_version}/
	cp -n $scratch/data/derivatives/fmriprep/.bidsignore ${output_dir}/fmriprep_${fmriprep_version}/
	cp -rn $scratch/data/derivatives/freesurfer/$subject ${output_dir}/freesurfer_${freesurfer_version}/
else
# copy fMRIPrep data to scratch dir so fitlins can run
	cp -n ${output_dir}/fmriprep_${fmriprep_version}/*.json $scratch/data/derivatives/fmriprep/
	cp -n ${output_dir}/fmriprep_${fmriprep_version}/*.tsv $scratch/data/derivatives/fmriprep/
	cp -n ${output_dir}/fmriprep_${fmriprep_version}/.bidsignore $scratch/data/derivatives/fmriprep/
	cp -n ${output_dir}/fmriprep_${fmriprep_version}/${subject}.html $scratch/data/derivatives/fmriprep/
	cp -rn ${output_dir}/fmriprep_${fmriprep_version}/${subject}/ $scratch/data/derivatives/fmriprep/
fi


#######

# Run XCPD
set +eu # sometimes xcp_d has a small error but doesn't affect outputs, so don't stop on errors here
echo "Submitted job for: ${subject}"
xcp_cmd="singularity run -e --containall -B ${scratch},${templateflow_dir},${cache_dir} $xcp_IMG ${scratch}/data/derivatives/fmriprep ${scratch}/data/derivatives/ participant --nthreads ${nprocs} --omp-nthreads ${omp_nprocs} --mem_gb ${mem_gb} --despike -w $scratch --fs-license-file ${scratch}/license.txt --notrack --cifti"
echo $'Command :\n'${xcp_cmd}
#${xcp_cmd} 
mkdir -p ${output_dir}/xcp_d_${xcp_version}/
if [ -d $scratch/data/derivatives/xcp_d/$subject/ses*/func/ ]; then 
	cp -r $scratch/data/derivatives/xcp_d/*.* ${output_dir}/xcp_d_${xcp_version}/
	cp -f $scratch/data/derivatives/xcp_d/*.html ${output_dir}/xcp_d_${xcp_version}/
	cp -rn $scratch/data/derivatives/xcp_d/$subject ${output_dir}/xcp_d_${xcp_version}/
fi
