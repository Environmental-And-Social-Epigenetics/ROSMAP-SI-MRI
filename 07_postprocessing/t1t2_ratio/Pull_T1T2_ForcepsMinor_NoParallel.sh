#!/bin/bash
#SBATCH -n 64
#SBATCH -t 47:00:00
#SBATCH --mem=256G
#SBATCH --output=t1t2_ratio_%j.log
#SBATCH --error=t1t2_ratio_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=mabdel03@mit.edu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
source "${REPO_ROOT}/config.sh"

# Activate conda environment
source "${CONDA_SH_PATH}"
conda activate "${MRTRIX_CONDA_ENV}"

# Base directories
XCP_DIR="${XCP_DERIV_DIR}"
QSIRECON_DIR="${QSIRECON_DERIV_DIR}"

# Output directory for results
OUTPUT_DIR="${T1T2_OUTPUT_DIR}"
mkdir -p "$OUTPUT_DIR"

# Create summary file
echo "subject_id,session_id,mean_t1t2_ratio" > "$OUTPUT_DIR/t1t2_ratio_summary.csv"

# Get list of all subject directories
for subject_dir in "$XCP_DIR"/sub-*; do
    # Extract subject ID
    sub_id=$(basename "$subject_dir" | sed 's/sub-//')
    
    echo "Processing subject $sub_id"
    
    # Find earliest session
    earliest_session=$(ls -d "$subject_dir"/ses-* 2>/dev/null | sort | head -n 1)
    if [ -z "$earliest_session" ]; then
        echo "Warning: No sessions found for subject $sub_id. Skipping..."
        continue
    fi
    
    ses_id=$(basename "$earliest_session" | sed 's/ses-//')
    
    # Construct file paths
    t1t2_file="$XCP_DIR/sub-${sub_id}/ses-${ses_id}/anat/sub-${sub_id}_ses-${ses_id}_acq-mpr_run-1_space-MNI152NLin2009cAsym_desc-preproc_T1wT2wRatio.nii.gz"
    tract_file="$QSIRECON_DIR/sub-${sub_id}/ses-${ses_id}/dwi/sub-${sub_id}_ses-${ses_id}_acq-45dir_dir-AP_run-1_space-T1w_desc-preproc_bundle-CorpusCallosumForcepsMinor_AutoTrackGQI.tck"
    
    # Check if files exist
    if [ ! -f "$t1t2_file" ]; then
        echo "Warning: T1/T2 ratio file not found for subject $sub_id: $t1t2_file"
        continue
    fi
    
    if [ ! -f "$tract_file" ]; then
        echo "Warning: Tract file not found for subject $sub_id: $tract_file"
        continue
    fi
    
    # Create output file name
    output_file="$OUTPUT_DIR/sub-${sub_id}_ses-${ses_id}_t1t2_stats.csv"
    
    echo "Running tcksample for subject $sub_id..."
    
    # Run tcksample
    tcksample "$tract_file" "$t1t2_file" "$output_file" -stat_tck mean
    
    # Check if output file was created and calculate mean
    if [ -f "$output_file" ]; then
        mean_value=$(awk 'NR>1 {sum+=$1} END {print sum/(NR-1)}' "$output_file")
        echo "$sub_id,$ses_id,$mean_value" >> "$OUTPUT_DIR/t1t2_ratio_summary.csv"
        echo "Successfully processed subject $sub_id. Mean T1/T2 ratio: $mean_value"
    else
        echo "Warning: Failed to generate output for subject $sub_id"
    fi
done

echo "Processing complete. Results are in $OUTPUT_DIR"
echo "Summary file: $OUTPUT_DIR/t1t2_ratio_summary.csv"
