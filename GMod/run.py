from startserver import startserver
import os, subprocess

startserver()

os.system ("git pull")
subprocess.run(["start", "cmd", "/K", "npm start --prefix ./FastDL"], shell=True)
os.system("npm start --prefix ./Muter")