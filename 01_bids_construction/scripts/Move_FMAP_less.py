"""
Move patients with no fmaps to new directory
"""

import pandas as pd 
import os
import shutil
import json

locations = pd.read_csv('/om2/user/mabdel03/files/Ravi_ISO_MRI/Reference_CSVs/fmap_less.csv', dtype=str)

no_fmap_patients = []
directory = []

for row in locations.index:

	cur = locations['Directory'][row]

	cur_split = cur.split('/')

	sub = cur_split[-2]

	new_dir = ''

	for x, y in enumerate(cur_split[:-1]):
		if x == len(cur[:-1]) - 1:
			 new_dir+=str(y)
			 continue
		new_dir += str(y)+'/'

	shutil.move(new_dir, '/om2/user/mabdel03/files/Ravi_ISO_MRI/No_FMAPS'+'/'+sub)


