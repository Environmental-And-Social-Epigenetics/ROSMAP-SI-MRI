import os
import pandas as pd 
import shutil

df = pd.read_csv("/om2/user/mabdel03/files/Ravi_ISO_MRI/Reference_CSVs/OG_Locations.csv", dtype=str)

dest = '/om2/user/mabdel03/files/Ravi_ISO_MRI/reformatted'

target_folders = []

for row in df.index:
	target_folder = 'sub-' + df['Subject'][row]
	final_dest = dest + '/' + target_folder
	shutil.copytree(df['Original_Directory'][row], final_dest)

	target_folders.append(final_dest)

df['New_Directories'] = target_folders

write_csv('/om2/user/mabdel03/files/Ravi_ISO_MRI/Reference_CSVs/New_Locations.csv')
