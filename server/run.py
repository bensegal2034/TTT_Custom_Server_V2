import startserver, os, subprocess
if __name__ == "__main__":
    startserver.start()
    subprocess.run(["start", "cmd", "/K", "npm start --prefix ./FastDL"], shell=True)
    os.system("npm start --prefix ./Muter")