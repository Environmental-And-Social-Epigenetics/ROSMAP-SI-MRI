import pandas as pd
import os
import shutil
import json
from pipeline_config import cfg

locations = pd.read_csv(cfg.OPENMIND_DIRECTORIES_CSV, dtype=str)

for row in locations.index:
	cur = locations['Mabdel03_Locations'][row]

	files = [os.path.join(cur, f) for f in os.listdir(cur) if os.path.isfile(cur+'/'+f)]

	if files:

		for file_path in files:
			shutil.move(file_path, os.path.join(cur, 'anat'))
