import startserver, subprocess
if __name__ == "__main__":
    startserver.start()
    subprocess.run(["start", "cmd", "/K", "npm start --prefix ./FastDL"], shell=True)