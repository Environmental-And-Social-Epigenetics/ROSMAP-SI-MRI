#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
source "${REPO_ROOT}/config.sh"

bids_dir="${BIDS_DIR}"
subjs=("$@")

if [[ ${#subjs[@]} -eq 0 ]]; then
    pushd "${OUTPUT_DIR}/freesurfer_${FREESURFER_VERSION}/" >/dev/null
    subjs=($(ls -d sub-*))
    popd >/dev/null
fi

if [[ ${#subjs[@]} -eq 0 ]]; then
    echo "No subjects found in ${OUTPUT_DIR}/freesurfer_${FREESURFER_VERSION}/"
    exit 1
fi

len=$(( ${#subjs[@]} - 1 ))
echo "Spawning ${#subjs[@]} sub-jobs."

sbatch --array=0-"${len}"%"${FS_TABULATE_ARRAY_CONCURRENCY}" \
    "${SCRIPT_DIR}/ss_fs_tabulate.sh" "${bids_dir}" "${subjs[@]}"
