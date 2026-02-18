# 08 Data Transfer (Engaging Cluster)

This stage stores transfer automation used to copy BIDS subject directories from OM to the Engaging cluster via Globus.

## Contents

- `Transfer_BIDS.sh`

## Workflow Summary

The script:

1. activates a conda environment with Globus CLI
2. defines source and destination endpoint UUIDs
3. enumerates subject directories (`sub-*`) in a source BIDS root
4. builds a batch transfer file
5. submits a recursive Globus transfer request

## Important Notes

- Endpoint IDs and source/destination paths are hardcoded to the original project.
- Requires valid Globus authentication context at runtime.
- Verify destination directory policy and quota before bulk transfer.
