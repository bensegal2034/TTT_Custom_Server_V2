from steam_workshop import collection as ws
from pathlib import Path
import os, random, time, subprocess

c = ws.Collection(2895023437)
collection_maps = [map["title"].split(" ")[0] for map in c.items.values() if "ttt_" in map["title"].lower()]
local_maps = [str(lmap).split("\\")[-1][:-4] for lmap in list(Path("D:\\SteamCMD\\GMod\\garrysmod\\downloadlists").glob('**/*.lst')) if any(str(lmap).split("\\")[-1][:-4] in cmap for cmap in collection_maps)]

#{random.choice(local_maps)}

os.system(f"start cmd.exe /k srcds.exe -console +maxplayers 7 -allowlocalhttp +gamemode terrortown +map {random.choice(local_maps)} +sv_setsteamaccount 7F69B937699BB050BE2036DE3448EC17 +host_workshop_collection 2895023437")
os.system("start cmd /c wsl")
os.system("npm start --prefix D:\\SteamCMD\\GMod\\Muter")