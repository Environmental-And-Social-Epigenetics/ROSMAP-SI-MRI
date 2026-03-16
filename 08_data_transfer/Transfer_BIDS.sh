#!/bin/bash
#SBATCH -n 32                    # Number of cores requested
#SBATCH -t 47:00:00             # Runtime in minutes or
#SBATCH --gres=gpu:a100:1
#SBATCH --mem=128G
#SBATCH --mail-user=mabdel03@mit.edu
#SBATCH --mail-type=BEGIN,END,FAIL

# Source central config
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${REPO_ROOT}/config.sh"

source "${CONDA_SH_PATH}"
conda activate globus_env

SOURCE_ENDPOINT="${TRANSFER_SOURCE_ENDPOINT}"
DEST_ENDPOINT="${TRANSFER_DEST_ENDPOINT}"

SOURCE_DIR="${TRANSFER_SOURCE_DIR}"
DEST_DIR="${TRANSFER_DEST_DIR}"

# Define batch file
BATCH_FILE="transfer_batch.txt"

# Create or empty the batch file
> $BATCH_FILE


# Find all subdirectories starting with 'sub' and add them to the batch file
for dir in "$SOURCE_DIR"/sub*/; do
    if [ -d "$dir" ]; then
        # Strip trailing slash
        DIR_NAME=$(basename "$dir")
        # Add the source and destination paths to the batch file with --recursive flag
        echo "$SOURCE_DIR/$DIR_NAME $DEST_DIR/$DIR_NAME --recursive" >> $BATCH_FILE
    fi
done

# Submit the batch transfer
globus transfer $SOURCE_ENDPOINT $DEST_ENDPOINT --batch $BATCH_FILE

echo "Transfer initiated."
