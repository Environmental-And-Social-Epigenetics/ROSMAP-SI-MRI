# 08 Data Transfer (Engaging Cluster)

This stage contains the Globus-based transfer script used to copy BIDS subject folders to Engaging.

## Run Command

```bash
bash 08_data_transfer/Transfer_BIDS.sh
```

## Inputs

- source BIDS directory configured inside script (`SOURCE_DIR`)
- source and destination endpoint IDs
- Globus CLI authentication

## Outputs

- `transfer_batch.txt` file in the execution directory
- submitted Globus transfer task for all `sub-*` folders

## Verification

- confirm task was submitted successfully in script output
- run `globus task list` and `globus task show <task_id>`
- confirm destination has expected `sub-*` directory set

## SLURM Resources (from script)

- time: `47:00:00`
- memory: `128G`
- cores: `32`
- GPU request included (`--gres=gpu:a100:1`)

## Troubleshooting

- If auth fails, run `globus login` in the same environment.
- If transfer is denied, verify endpoint permissions and destination path access.
- If you are using a different project, update endpoint IDs and source/destination paths before running.
