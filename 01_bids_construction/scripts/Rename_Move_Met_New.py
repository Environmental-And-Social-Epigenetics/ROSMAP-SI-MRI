"""
Script to make corrections accounting for new naming convention we were not aware of
Renames files and moves them, then adds IntendedFor parameter to json
"""


import pandas as pd 
import os
import shutil
import json

locations = pd.read_csv('/om2/user/mabdel03/files/Ravi_ISO_MRI/Reference_CSVs/Openmind_Directoris.csv', dtype=str)

for row in locations.index:

	cur = locations['Mabdel03_Locations'][row]

	files = [f for f in os.listdir(cur) if os.path.isfile(cur+'/'+f)] 

	fmap_dir = os.path.join(cur, 'fmap')

	dwi_dir = os.path.join(cur, 'dwi')

	root = 'sub-' + str(locations['Subject'][row]) +'_'+locations['Session'][row]+'_'

	phasediff_json = ''

	if files:

		for f in files:

			if f == 'FieldMap.json':

				new_name = root+'acq-gre_run-1_magnitude1.json'

				shutil.move(os.path.join(cur, f), os.path.join(fmap_dir, new_name))

			if f == 'FieldMap.nii.gz':

				new_name = root+'acq-gre_run-1_magnitude1.nii.gz'

				shutil.move(os.path.join(cur, f), os.path.join(fmap_dir, new_name))

			if f == 'FieldMap_ph.json':

				new_name = root+ 'acq-gre_run-1_phasediff.json'

				phasediff_json = new_name

				shutil.move(os.path.join(cur, f), os.path.join(fmap_dir, new_name))

			if f == 'FieldMap_ph.nii.gz':

				new_name = root+ 'acq-gre_run-1_phasediff.nii.gz'

				shutil.move(os.path.join(cur, f), os.path.join(fmap_dir, new_name))

			if f == 'HARDI.bval':

				new_name = root+'acq-45dir_dir-AP_run-1_dwi.bval'

				shutil.move(os.path.join(cur, f), os.path.join(dwi_dir, new_name))

			if f == 'HARDI.bvec':

				new_name = root+'acq-45dir_dir-AP_run-1_dwi.bvec'

				shutil.move(os.path.join(cur, f), os.path.join(dwi_dir, new_name))

			if f == 'HARDI.json':

				new_name = root+'acq-45dir_dir-AP_run-1_dwi.json'

				shutil.move(os.path.join(cur, f), os.path.join(dwi_dir, new_name))

			if f == 'HARDI.nii.gz':

				new_name = root+'acq-45dir_dir-AP_run-1_dwi.nii.gz'

				shutil.move(os.path.join(cur, f), os.path.join(dwi_dir, new_name))

		for file in os.listdir(fmap_dir):
			if file.endswith('phasediff.json'):
				phasediff_json = file

		with open(os.path.join(fmap_dir, phasediff_json)) as f:

			data = json.load(f)

		IF = [os.path.join(locations['Session'][row], f) for f in os.listdir(dwi_dir) if f.endswith('.nii.gz')]

		data['IntendedFor'] = IF 

		with open(os.path.join(fmap_dir, phasediff_json), 'w') as outfile:

			json.dump(data, outfile, indent=2, sort_keys=True)









