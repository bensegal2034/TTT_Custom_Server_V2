import startserver, os, subprocess

startserver.start()
subprocess.run(["start", "cmd", "/K", "npm start --prefix ./FastDL"], shell=True)
os.system("npm start --prefix ./Muter")