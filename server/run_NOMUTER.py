import startserver, subprocess

startserver.start()
subprocess.run(["start", "cmd", "/K", "npm start --prefix ./FastDL"], shell=True)