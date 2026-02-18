import pandas as pd 
import os
import shutil

suffixes = {
	'dwi': {'DTI.bval', 'DTI.bvec', 'DTI.json', 'DTI.nii.gz', 
	'Ax-DWI-PA-40-6.bval', 'Ax-DWI-PA-40-6.bvec', 'Ax-DWI-PA-40-6.json', 
	'Ax-DWI-PA-40-6.nii.gz', 'Ax-DWI-PA-40-6.bval', 'Ax-DWI-PA-40-6.bvec', 'Ax-DWI-PA-40-6.json', 'Ax-DWI-PA-40-6.nii.gz', 
	'DTI.bval', 'DTI.bvec', 'DTI.json', 'DTI.nii.gz', 'DIFF_DTI_45_directions.bval', 
	'DIFF_DTI_45_directions.bvec', 'DIFF_DTI_45_directions.json', 'DIFF_DTI_45_directions.nii.gz', 
	'DIFF_DTI_45_directions.bval', 'DIFF_DTI_45_directions.bvec', 'DIFF_DTI_45_directions.json', 'DIFF_DTI_45_directions.nii.gz', 
	'DIFF_DTI_45_directions.bval', 'DIFF_DTI_45_directions.bvec', 'DIFF_DTI_45_directions.json', 'DIFF_DTI_45_directions.nii.gz'},
	'func': {'EPI.json', 'EPI.nii.gz', 'ep2d_fid_basic_bold.json', 'ep2d_fid_basic_bold.nii.gz', }, 
	'anat': {'MPRAGE.json', 'MPRAGE.nii.gz', 'mprage-rms.nii.gz', 'T1_W_3D.json', 'T1_W_3D.nii.gz', 
	't1_mpr_ns_sag_pat2_iso.json', 't1_mpr_ns_sag_pat2_iso.nii.gz', 't1_mpr_ns_sag_pat2_iso.json', 
	't1_mpr_ns_sag_pat2_iso.nii.gz', 't1_mpr_ns_sag_pat2_iso.json', 't1_mpr_ns_sag_pat2_iso_ND.json', 
	't1_mpr_ns_sag_pat2_iso_ND.nii.gz', 't1_mpr_ns_sag_pat2_iso.nii.gz'}, 
	'fmap': {'SE_EPI_A.json', 'SE_EPI_A.nii.gz', 'SE_EPI_P.json', 'SE_EPI_P.nii.gz', 'gre_field_mapping_e1.json', 
	'gre_field_mapping_e1.nii.gz', 'gre_field_mapping_e2.json', 'gre_field_mapping_e2.nii.gz', 'gre_field_mapping_e2_ph.json', 
	'gre_field_mapping_e2_ph.nii.gz', 'gre_field_mapping_merged.nii.gz'}
}

locations = pd.read_csv('/om2/user/mabdel03/files/Ravi_ISO_MRI/Reference_CSVs/Openmind_Directoris.csv')

for row in locations.index:
	cur = locations['Mabdel03_Locations'][row]
	for folder in suffixes.keys():
		os.mkdir(cur + '/' + folder)

		for file in [f for f in os.listdir(cur) if os.path.isfile(cur+'/'+f)]:
			if file in suffixes[folder]:
				shutil.move(os.path.join(cur, file), cur+'/'+folder)



