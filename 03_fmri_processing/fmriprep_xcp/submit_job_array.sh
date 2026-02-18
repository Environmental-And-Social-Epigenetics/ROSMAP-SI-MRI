#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
source "${REPO_ROOT}/config.sh"

bids_dir="${BIDS_DIR}"
subjs=("$@")

if [[ ${#subjs[@]} -eq 0 ]]; then
    pushd "${bids_dir}" >/dev/null
    subjs=($(ls -d sub-*))
    popd >/dev/null
fi

if [[ ${#subjs[@]} -eq 0 ]]; then
    echo "No subjects found in ${bids_dir}"
    exit 1
fi

len=$(( ${#subjs[@]} - 1 ))
echo "Spawning ${#subjs[@]} sub-jobs."

sbatch --array=0-"${len}"%"${FMRIPREP_ARRAY_CONCURRENCY}" \
    "${SCRIPT_DIR}/ss_fmriprep_xcp.sh" "${bids_dir}" "${subjs[@]}"
