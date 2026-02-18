"""
Code to build csv containing all patients with no fmaps
"""

import pandas as pd 
import os
import shutil
import json

locations = pd.read_csv('/om2/user/mabdel03/files/Ravi_ISO_MRI/Reference_CSVs/Openmind_Directoris.csv', dtype=str)

no_fmap_patients = []
directory = []

for row in locations.index:

	cur = locations['Mabdel03_Locations'][row]

	fmaps = os.path.join(cur, 'fmap')

	fmap_files = [f for f in os.listdir(fmaps) if os.path.isfile(fmaps+'/'+f)]

	if not fmap_files:
		no_fmap_patients.append(locations['Subject'][row])
		directory.append(cur)

data = {'Subject': no_fmap_patients, 'Directory': directory}
df = pd.DataFrame(data)

df.to_csv('/om2/user/mabdel03/files/Ravi_ISO_MRI/Reference_CSVs/fmap_less.csv') #write to csv
