import os
import pandas as pd
import shutil
from pipeline_config import cfg

df = pd.read_csv(cfg.OG_LOCATIONS_CSV, dtype=str)

dest = cfg.REFORMATTED_DIR

target_folders = []

for row in df.index:
	target_folder = 'sub-' + df['Subject'][row]
	final_dest = dest + '/' + target_folder
	shutil.copytree(df['Original_Directory'][row], final_dest)

	target_folders.append(final_dest)

df['New_Directories'] = target_folders

df.to_csv(os.path.join(cfg.REFERENCE_CSV_DIR, 'New_Locations.csv'))
