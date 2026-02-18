"""
Script to correct BOLD and DWI files
Must add phasencoding direction to these files
Seems like all of the directions are A>>P, Aka Anterior-Posterior
This is like the AP fmaps, the phaseencodingdirection should be 'j-'
"""

import pandas as pd 
import os
import shutil
import json

locations = pd.read_csv('/om2/user/mabdel03/files/Ravi_ISO_MRI/Reference_CSVs/Openmind_Directoris.csv', dtype=str)

dwi_directs = {
	'120221': 'AP',
	'140922': 'AP',
	'180604': 'AP', 
	'150706': 'AP',
	'151120': 'AP',
	'160125': 'AP',
	'220113': 'AP',
	'220419': 'AP',
	'120501': 'AP',
	'150715': 'AP',
	'160621': 'AP',
	'160627': 'AP',
	'210218': 'AP',
}

bold_directs = {
	
	'120221': 'AP',
	'140922': 'AP',
	'180604': 'AP', 
	'150706': 'AP',
	'151120': 'AP',
	'160125': 'AP',
	'220113': 'AP',
	'220419': 'AP',
	'120501': 'AP',
	'150715': 'AP',
	'160621': 'AP',
	'160627': 'AP',
	'210218': 'AP',

}



for row in locations.index:

	cur = locations['Mabdel03_Locations'][row]
	og_dir = locations['Original_Directory'][row]

	start_date = og_dir.split('/')[13]


	bolds = os.path.join(cur, 'bold')
	bolds_files = [f for f in bolds if os.path.isfile(bolds+'/'+f)]
	bolds_jsons = [f for f in bolds if f.endswith('json')]

	dwis = os.path.join(cur, 'dwi')
	dwi_files = [f for f in os.listdir(dwis) if os.path.isfile(dwis+'/'+f)]
	dwi_jsons = [f for f in dwi_files if f.endswith('.json')]


	for file in bolds_jsons:

		cur_file = os.path.join(bolds, file)

		with open(cur_file) as f:
			data = json.load(f)


		data['PhaseEncodingDirection'] = 'j-'

		og_dir = locations['Original_Directory'][row]


		with open(cur_file, 'w') as outfile:
			json.dump(data, outfile, indent=2,sort_keys=True)

	for file in dwi_jsons:

		cur_file = os.path.join(dwis, file)

		with open(cur_file) as f:
			data = json.load(f)


		data['PhaseEncodingDirection'] = 'j-'

		og_dir = locations['Original_Directory'][row]


		with open(cur_file, 'w') as outfile:
			json.dump(data, outfile, indent=2,sort_keys=True)
