from pathlib import Path
import os, random, psutil, subprocess

def start():
    for proc in psutil.process_iter():
        if proc.name() == "node.exe" and "elgato" not in proc.exe().lower():
            print(f"Killing {proc.name()} with PID {proc.pid} and path {proc.exe().lower()}")
            proc.kill()

    maps = [str(lmap).split("\\")[-1][:-4] for lmap in list(Path(os.path.join(os.getcwd(), "garrysmod\\maps")).glob('**/*.bsp'))]

    subprocess.Popen([
        'srcds.exe',
        '-console',
        '-condebug',
        '+maxplayers',
        '7',
        '-allowlocalhttp',
        '+gamemode',
        'terrortown',
        '+map',
        random.choice(maps),
        '+sv_setsteamaccount',
        '85BFBDC8B9CA97217304A337729A25C8'
    ])
    #os.system(f"start cmd.exe /k srcds.exe -console +maxplayers 7 -allowlocalhttp +gamemode terrortown +map {random.choice(maps)} +sv_setsteamaccount 7F69B937699BB050BE2036DE3448EC17")