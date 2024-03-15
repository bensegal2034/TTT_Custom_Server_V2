from startserver import startserver
import os, subprocess, time

os.system ("git pull")
time.sleep(5)
startserver()
subprocess.run(["start", "cmd", "/K", "npm start --prefix ./FastDL"], shell=True)
os.system("npm start --prefix ./Muter")