"""
Script to correct epi fmap files
Add PhaseEncodingDirection and TotalReadoutTime fields to epi json
"""

import pandas as pd 
import os
import shutil
import json

locations = pd.read_csv('/om2/user/mabdel03/files/Ravi_ISO_MRI/Reference_CSVs/Openmind_Directoris.csv', dtype=str)

readouts = {
	'120221': 0.04, 
	'140922': 0.0409, 
	'180604': 0.0409, 
	'210218': 0.048, 
	'150706': 0.0409,
	'151120': 0.0409,
	'160125': 0.0409,
	'220113': 0.0409,
	'220419': 0.0409,
	'120501': 0.069,
	'150715': 0.069,
	'160621': 0.069,
	'160627': 0.069
}

for row in locations.index:

	cur = locations['Mabdel03_Locations'][row]

	files = [f for f in os.listdir(cur) if os.path.isfile(cur+'/'+f)] 

	fmaps = os.path.join(cur, 'fmap')

	fmap_files = [f for f in os.listdir(fmaps) if os.path.isfile(fmaps+'/'+f)]

	fmap_jsons = [f for f in fmap_files if f.endswith('.json')]

	if len(fmap_jsons) == 2:

		for file in fmap_jsons:

			cur_file = os.path.join(fmaps, file)

			with open(cur_file) as f:
				data = json.load(f)

			if file.endswith('PA_epi.json'):
				data['PhaseEncodingDirection'] = 'j'

			if file.endswith('AP_epi.json'):

				data['PhaseEncodingDirection'] = 'j-'

			og_dir = locations['Original_Directory'][row]

			start_date = og_dir.split('/')[13]

			data['TotalReadoutTime'] = readouts[start_date]

			with open(cur_file, 'w') as outfile:
				json.dump(data, outfile, indent=2,sort_keys=True)


