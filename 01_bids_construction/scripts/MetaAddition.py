"""
Code to make metadata additions to relevant json files
Should add magnitude 1/2 echo times (Echo1 + Echo2) to phasediff fmap json
Should add IntendedFor field to phasediff fmap json (should be a list of relevant file directories, e.g ses-xx/type/file.xx)
Should add task field to BOLD jsons (task: rest)
"""

import pandas as pd 
import os
import shutil
import json

locations = pd.read_csv('/om2/user/mabdel03/files/Ravi_ISO_MRI/Reference_CSVs/Openmind_Directoris.csv', dtype=str)

for row in locations.index:

	cur = locations['Mabdel03_Locations'][row]

	IF_root_dwi = locations['Session'][row]+'/'+'dwi'+'/'
	IF_root_func = locations['Session'][row]+'/'+'func'+'/'
	print(IF_root_func)

	fmaps = os.path.join(cur, 'fmap')

	funcs = os.path.join(cur, 'func')

	dwis = os.path.join(cur, 'dwi')

	dwi_files = [f for f in os.listdir(dwis) if os.path.isfile(dwis+'/'+f)]

	dwi_nii = [f for f in dwi_files if f.endswith('.nii.gz')]

	print(dwi_nii)

	dwi_jsons = [f for f in dwi_files if f.endswith('.json')]

	func_files = [f for f in os.listdir(funcs) if os.path.isfile(funcs+'/'+f)]

	func_nii = [f for f in func_files if f.endswith('.nii.gz')]
	print(func_nii)

	func_jsons = [f for f in func_files if f.endswith('.json')]

	fmap_files = [f for f in os.listdir(fmaps) if os.path.isfile(fmaps+'/'+f)]

	fmap_jsons = [f for f in fmap_files if f.endswith('.json')]

	IF = [IF_root_func+f for f in func_nii] + [IF_root_dwi+f for f in dwi_nii]
	print(IF)

	if len(fmap_jsons) == 2:

		for file in fmap_jsons:

			with open(fmaps+'/'+file) as f:
				data = json.load(f)

			data['IntendedFor'] = IF 

			with open(fmaps+'/'+file, 'w') as outfile:
				json.dump(data, outfile, indent=2,sort_keys=True)

	elif len(fmap_jsons) == 3:

		echo1 = []

		echo2 = []

		filename = ''

		for file in fmap_jsons:

			if file.endswith('magnitude1.json'):

				with open(fmaps + '/' + file) as f:

					data = json.load(f)

				echo1.append(data['EchoTime'])

			if file.endswith('magnitude2.json'):

				with open(fmaps + '/' + file) as f:

					data = json.load(f)

				echo2.append(data['EchoTime'])


			if file.endswith('phasediff.json'):

				filename = file

		with open(fmaps+'/'+filename) as f:
			data = json.load(f)

		print(IF)

		data['IntendedFor'] = IF

		data['EchoTime1'] = echo1[0]

		data['EchoTime2'] = echo2[0]

		with open(fmaps+'/'+filename, 'w') as outfile:
			json.dump(data, outfile, indent=2,sort_keys=True)

	for file in func_jsons:

		with open(funcs+'/'+file) as f:
			data = json.load(f)

		data['TaskName'] = 'rest'

		with open(funcs+'/'+file, 'w') as outfile:
			json.dump(data, outfile, indent=2,sort_keys=True)






