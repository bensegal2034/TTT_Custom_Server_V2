from startserver import startserver
from pathlib import Path
import subprocess

startserver()
if Path("garrysmod/cfg/fastdlsetup.cfg").is_file():
    subprocess.run(["start", "cmd", "/K", "npm start --prefix ./FastDL"], shell=True)