
"""
Script to remove files in ses directories not organized into a sub directory
"""
import pandas as pd 
import os
import shutil
import json

locations = pd.read_csv('/om2/user/mabdel03/files/Ravi_ISO_MRI/Reference_CSVs/Openmind_Directoris.csv', dtype=str)

for row in locations.index:
	cur = locations['Mabdel03_Locations'][row]

	
	try:
		files = [os.path.join(cur, f) for f in os.listdir(cur) if os.path.isfile(cur+'/'+f)]

		if files:
			for file_path in files:
				os.remove(file_path)
	except:
		continue
