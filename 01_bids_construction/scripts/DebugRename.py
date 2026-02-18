import pandas as pd 
import os
import shutil

locations = pd.read_csv('/om2/user/mabdel03/files/Ravi_ISO_MRI/Reference_CSVs/Openmind_Directoris.csv', dtype=str)
subs = ['anat', 'fmap', 'func', 'dwi']


for row in locations.index:

	cur = locations['Mabdel03_Locations'][row]

	print(locations['Subject'][row])

	root = 'sub-' + str(locations['Subject'][row]) +'_'+locations['Session'][row]+'_'

	cur_sub = os.path.join(cur, 'fmap')

	contents = [f for f in os.listdir(cur_sub) if os.path.isfile(cur_sub+'/'+f)]

	new_name = ''

	for file in contents:

		if len(contents) == 7 or len(contents) == 6:
			if file.endswith(('run-phasediff.json', 'run-phasediff.nii.gz')):
				if file.endswith('.json'):
					new_name = root+ 'acq-gre_run-1_phasediff.json'
				if file.endswith('.nii.gz'):
					new_name = root+'acq-gre_run-1_phasediff.nii.gz'

				shutil.move(os.path.join(cur_sub, file), os.path.join(cur_sub, new_name))
