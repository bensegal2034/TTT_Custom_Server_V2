from startserver import startserver
import os, subprocess

startserver()

subprocess.run(["start", "cmd", "/K", "npm start --prefix ./FastDL"], shell=True)
os.system("npm start --prefix ./Muter")