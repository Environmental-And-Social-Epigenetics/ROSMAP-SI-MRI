#!/bin/bash
#SBATCH -n 256
#SBATCH -t 24:00:00
#SBATCH --mem=500G
#SBATCH --output=/om2/user/mabdel03/files/Ravi_ISO_MRI/Reprocessing/T1T2Ratio/ForcepsMinor/Scripts/t1t2ratio.log
#SBATCH --error=/om2/user/mabdel03/files/Ravi_ISO_MRI/Reprocessing/T1T2Ratio/ForcepsMinor/Scripts/t1t2_ratio_%A_%a.err
#SBATCH --mail-type=START,END,FAIL
#SBATCH --mail-user=mabdel03@mit.edu

# Activate conda environment
source /om2/user/mabdel03/anaconda/etc/profile.d/conda.sh
conda activate /om2/user/mabdel03/conda_envs/MRtrix

# Check if MRtrix is available after activation
if ! command -v tcksample &> /dev/null; then
    echo "Error: MRtrix (tcksample) is not available after conda activation. Please check your environment."
    exit 1
fi

# Base directories
XCP_DIR="/om/scratch/Wed/mabdel03/MRI_Data/derivatives/Set_2/xcp_d_0.6.1"
QSIRECON_DIR="/om/scratch/Wed/mabdel03/MRI_Data/derivatives/Set_2/qsirecon_0.20.0"

# Count total subjects for array size
NUM_SUBJECTS=$(ls -d "$XCP_DIR"/sub-* | wc -l)
NUM_SUBJECTS=$((NUM_SUBJECTS - 1))

# Add array specification after counting subjects
#SBATCH --array=0-${NUM_SUBJECTS}%100  # Allow up to 100 concurrent jobs given the large resource allocation

# Output directory for results
OUTPUT_DIR="t1t2_ratio_results"
mkdir -p "$OUTPUT_DIR"

# Create summary file if this is the first job in the array
if [ $SLURM_ARRAY_TASK_ID -eq 0 ]; then
    echo "subject_id,session_id,mean_t1t2_ratio" > "$OUTPUT_DIR/t1t2_ratio_summary.csv"
fi

# Get list of all subjects
mapfile -t subjects < <(ls -d "$XCP_DIR"/sub-* | xargs -n1 basename | sed 's/sub-//')

# Get the subject ID for this array task
sub_id="${subjects[$SLURM_ARRAY_TASK_ID]}"

# Find earliest session for this subject
subject_dir="$XCP_DIR/sub-${sub_id}"
if [[ ! -d "$subject_dir" ]]; then
    echo "Warning: Directory not found for subject $sub_id. Skipping..."
    exit 1
fi

# Get earliest session
earliest_session=$(ls -d "$subject_dir"/ses-* 2>/dev/null | sort | head -n 1)
if [[ -z "$earliest_session" ]]; then
    echo "Warning: No sessions found for subject $sub_id. Skipping..."
    exit 1
fi

ses_id=$(basename "$earliest_session" | sed 's/ses-//')

# Construct file paths
t1t2_file="$XCP_DIR/sub-${sub_id}/ses-${ses_id}/anat/sub-${sub_id}_ses-${ses_id}_acq-mpr_run-1_space-MNI152NLin2009cAsym_desc-preproc_T1wT2wRatio.nii.gz"
tract_file="$QSIRECON_DIR/sub-${sub_id}/ses-${ses_id}/dwi/sub-${sub_id}_ses-${ses_id}_acq-45dir_dir-AP_run-1_space-T1w_desc-preproc_bundle-CorpusCallosumForcepsMinor_AutoTrackGQI.tck"

# Check if both files exist
if [[ ! -f "$t1t2_file" ]]; then
    echo "Warning: T1/T2 ratio file not found for subject $sub_id, session $ses_id: $t1t2_file"
    exit 1
fi

if [[ ! -f "$tract_file" ]]; then
    echo "Warning: Tract file not found for subject $sub_id, session $ses_id: $tract_file"
    exit 1
fi

# Create output file name
output_file="$OUTPUT_DIR/sub-${sub_id}_ses-${ses_id}_t1t2_stats.csv"

echo "Processing subject $sub_id, session $ses_id..."
echo "Input T1/T2 file: $t1t2_file"
echo "Input tract file: $tract_file"
echo "Output file: $output_file"

# Run tcksample
tcksample "$tract_file" "$t1t2_file" "$output_file" -stat_tck mean

# Extract the mean value and add to summary file
if [[ -f "$output_file" ]]; then
    # Calculate average of all values in the output file (excluding header if present)
    mean_value=$(awk 'NR>1 {sum+=$1} END {print sum/(NR-1)}' "$output_file")
    
    # Use flock to safely write to summary file
    flock -x "$OUTPUT_DIR/t1t2_ratio_summary.csv" bash -c \
        "echo '$sub_id,$ses_id,$mean_value' >> '$OUTPUT_DIR/t1t2_ratio_summary.csv'"
    
    echo "Successfully processed subject $sub_id"
    echo "Mean T1/T2 ratio: $mean_value"
else
    echo "Warning: Failed to generate output for subject $sub_id, session $ses_id"
    exit 1
fi

echo "Job completed successfully for subject $sub_id"
