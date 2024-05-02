from pathlib import Path
import os, random, time

def start():
    os.system("taskkill /F /IM node.exe")
    time.sleep(5)
    maps = [str(lmap).split("\\")[-1][:-4] for lmap in list(Path(os.path.join(os.getcwd(), "garrysmod\\maps")).glob('**/*.bsp'))]

    os.system(f"start cmd.exe /k srcds.exe -console +maxplayers 7 -allowlocalhttp +gamemode terrortown +map {random.choice(maps)} +sv_setsteamaccount 7F69B937699BB050BE2036DE3448EC17 +host_workshop_collection 2895023437")