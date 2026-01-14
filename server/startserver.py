from pathlib import Path
import os, random, psutil, subprocess

def start(test):
    for proc in psutil.process_iter():
        if proc.name() == "node.exe" and "elgato" not in proc.exe().lower():
            print(f"Killing {proc.name()} with PID {proc.pid} and path {proc.exe().lower()}")
            proc.kill()

    maps = [str(lmap).split("\\")[-1][:-4] for lmap in list(Path(os.path.join(os.getcwd(), "garrysmod\\maps")).glob('**/*.bsp'))]
    svArgs = [
        'srcds.exe',
        '-console',
        '-condebug',
        '+maxplayers',
        '7',
        '-allowlocalhttp',
        '+gamemode',
        'terrortown',
        '+map',
        f"{'ttt_apehouse_d' if test else random.choice(maps)}",
        '+sv_setsteamaccount',
        '85BFBDC8B9CA97217304A337729A25C8'
    ]
    cfg = os.path.join(os.getcwd(), "garrysmod/cfg/testmode.cfg")

    with open(cfg, "w") as f:
        if test:
            data = "exec test"
        else:
            data = ""
        f.write(data)

    subprocess.Popen(svArgs)
    subprocess.run(["start", "cmd", "/K", "npm start --prefix ./FastDL"], shell=True)

    if not test:
        os.system("npm start --prefix ./Muter")