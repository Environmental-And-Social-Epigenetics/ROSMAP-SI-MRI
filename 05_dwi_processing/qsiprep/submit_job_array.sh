#!/bin/bash
subjs=($@) # You can input a list of subjects if you want to
code_dir=`dirname $0` # Get the directory of this file
sub_dir=/om2/user/mabdel03/files/Ravi_ISO_MRI/reformatted/ # BIDS ROOT DIRECTORY

if [[ $# -eq 0 ]]; then
    # first go to data directory, grab all subjects,
    # and assign to an array
    pushd $sub_dir
    subjs=($(ls sub-* -d))
    popd
fi

len=$(expr ${#subjs[@]} - 1) # len - 1

echo "Spawning ${#subjs[@]} sub-jobs."

sbatch --array=0-$len%80 $code_dir/ss_qsiprep.sh $sub_dir ${subjs[@]}
