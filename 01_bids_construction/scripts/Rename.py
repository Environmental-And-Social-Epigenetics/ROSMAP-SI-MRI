import pandas as pd 
import os
import shutil

locations = pd.read_csv('/om2/user/mabdel03/files/Ravi_ISO_MRI/Reference_CSVs/Openmind_Directoris.csv', dtype=str)
subs = ['anat', 'fmap', 'func', 'dwi']


for row in locations.index:

	cur = locations['Mabdel03_Locations'][row]

	root = 'sub-' + str(locations['Subject'][row]) +'_'+locations['Session'][row]+'_'

	for sub in subs:
		cur_sub = os.path.join(cur, sub)

		if sub == 'anat':

			for file in [f for f in os.listdir(cur_sub) if os.path.isfile(cur+'/'+f)]:
				if file.endswith('.json'):
					new_name = root+'acq-mpr_run-1_T1w.json'
				if file.endswith('.nii.gz'):
					new_name = root+'acq-mpr_run-1_T1w.nii.gz'

				shutil.move(os.path.join(cur_sub, file), os.path.join(cur_sub, new_name))

		elif sub == 'fmap':

			contents = [f for f in os.listdir(cur_sub) if os.path.isfile(cur+'/'+f)]

			for file in contents:
				
				if len(contents) == 4:

					if file.endswith('A.json') or file.endswith('A.nii.gz'):

						if file.endswith('.json'):
							new_name = root+'dir-AP_epi.json'
						if file.endswith('.nii.gz'):
							new_name = root+'dir-AP_epi.nii.gz'

					if file.endswith('P.json') or file.endswith('P.nii.gz'):
						if file.endswith('.json'):
							new_name = root+'dir-PA_epi.json'
						if file.endswith('.nii.gz'):
							new_name = root+'dir-PA_epi.nii.gz'

				if len(contents) == 7 or len(contents) == 6:

					if file.endswith('merged.nii.gz'):
						os.remove(os.path.join(cur_sub, file))
						continue

					if file.endswith(('e1.json', 'e1.nii.gz')):
						if file.endswith('.json'):
							new_name = root+ 'acq-gre_run-1_magnitude1.json'
						if file.endswith('.nii.gz'):
							new_name = root+'acq-gre_run-1_magnitude1.nii.gz'
					if file.endswith(('e2.json', 'e2.nii.gz')):
						if file.endswith('.json'):
							new_name = root+ 'acq-gre_run-1_magnitude2.json'
						if file.endswith('.nii.gz'):
							new_name = root+'acq-gre_run-1_magnitude2.nii.gz'
					if file.endswith(('ph.json', 'ph.nii.gz')):
						if file.endswith('.json'):
							new_name = root+ 'acq-gre_run-phasediff.json'
						if file.endswith('.nii.gz'):
							new_name = root+'acq-gre_run-phasediff.nii.gz'

				shutil.move(os.path.join(cur_sub, file), os.path.join(cur_sub, new_name))


		elif sub == 'func':

			for file in [f for f in os.listdir(cur_sub) if os.path.isfile(cur+'/'+f)]:

				if file.endswith('.json'):
					new_name = root+'task-rest_acq-ep2d_dir-AP_run-1_bold.json'
				if file.endswith('.nii.gz'):
					new_name = root+'task-rest_acq-ep2d_dir-AP_run-1_bold.nii.gz'
				shutil.move(os.path.join(cur_sub, file), os.path.join(cur_sub, new_name))

		else:

			for file in [f for f in os.listdir(cur_sub) if os.path.isfile(cur+'/'+f)]:

				if file.endswith('.bval'):
					new_name = root+'acq-45dir_dir-AP_run-1_dwi.bval'
				if file.endswith('.bvec'):
					new_name = root+'acq-45dir_dir-AP_run-1_dwi.bvec'
				if file.endswith('.json'):
					new_name = root+'acq-45dir_dir-AP_run-1_dwi.json'
				if file.endswith('.nii.gz'):
					new_name = root+'acq-45dir_dir-AP_run-1_dwi.nii.gz'

				shutil.move(os.path.join(cur_sub, file), os.path.join(cur_sub, new_name))


