"""Shared path configuration for BIDS construction scripts.

Reads paths from environment variables set by sourcing config.sh.

Usage:
    source ../../config.sh
    python script.py

    from pipeline_config import cfg
    locations = pd.read_csv(cfg.OPENMIND_DIRECTORIES_CSV, dtype=str)
"""
import os

def _get(var, default=None):
    val = os.environ.get(var, default)
    if val is None:
        raise EnvironmentError(
            f"${var} not set. Source config.sh before running, "
            f"or set the environment variable directly."
        )
    return val

class _Config:
    @property
    def RAVI_MRI_ROOT(self):
        return _get("RAVI_MRI_ROOT")

    @property
    def REFERENCE_CSV_DIR(self):
        return _get("REFERENCE_CSV_DIR", os.path.join(self.RAVI_MRI_ROOT, "Reference_CSVs"))

    @property
    def REFORMATTED_DIR(self):
        return _get("REFORMATTED_DIR", os.path.join(self.RAVI_MRI_ROOT, "reformatted"))

    @property
    def NO_FMAPS_DIR(self):
        return _get("NO_FMAPS_DIR", os.path.join(self.RAVI_MRI_ROOT, "No_FMAPS"))

    @property
    def FINAL_DATA_DIR(self):
        return _get("FINAL_DATA_DIR", os.path.join(self.RAVI_MRI_ROOT, "Final_Data"))

    @property
    def METADATA_DIR(self):
        return _get("METADATA_DIR", os.path.join(self.RAVI_MRI_ROOT, "Metadata"))

    @property
    def MODEL_OUTPUT_DIR(self):
        return _get("MODEL_OUTPUT_DIR", os.path.join(self.RAVI_MRI_ROOT, "Mahmoud_Rerun_Model_Outputs"))

    # Convenience: specific CSV file paths
    @property
    def OPENMIND_DIRECTORIES_CSV(self):
        return os.path.join(self.REFERENCE_CSV_DIR, "Openmind_Directoris.csv")

    @property
    def FMAP_LESS_CSV(self):
        return os.path.join(self.REFERENCE_CSV_DIR, "fmap_less.csv")

    @property
    def OG_LOCATIONS_CSV(self):
        return os.path.join(self.REFERENCE_CSV_DIR, "OG_Locations.csv")

cfg = _Config()
