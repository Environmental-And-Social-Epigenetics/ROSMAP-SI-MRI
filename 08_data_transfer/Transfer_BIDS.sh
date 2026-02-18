#!/bin/bash
#SBATCH -n 32                    # Number of cores requested
#SBATCH -t 47:00:00             # Runtime in minutes or
#SBATCH --gres=gpu:a100:1
#SBATCH --mem=128G
#SBATCH --mail-user=mabdel03@mit.edu
#SBATCH --mail-type=BEGIN,END,FAIL

source /om2/user/mabdel03/anaconda/etc/profile.d/conda.sh
conda activate /om2/user/mabdel03/conda_envs/globus_env

SOURCE_ENDPOINT="cbc6f8da-d37e-11eb-bde9-5111456017d9"
DEST_ENDPOINT="c52fcff2-761c-11eb-8cfc-cd623f92e1c0"

SOURCE_DIR="/om2/user/mabdel03/files/Ravi_ISO_MRI/reformatted"
DEST_DIR="/pool001/mabdel03/BIDS_MRI_Data"

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
