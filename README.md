# What is this?
This repository contains a modified version of a Garry's Mod server. It is intended to host the Trouble in Terrorist Town gamemode (https://www.troubleinterroristtown.com/) created by Bad King Urgrain.

# Installation
1a) Install Git, Python, Node.JS, Counter-Strike: Source, and Team Fortress 2.
1b) Ensure Git, Python, and Node.JS are added to your PATH in Windows.

2) Open a new terminal window in this directory, run `pip install -r requirements.txt`

3a) Change directory to GMod/FastDL/, run `npm install`
3b) Change directory to GMod/Muter/, run `npm install`

4a) Create a new file in GMod/garrysmod/cfg/ named mount.cfg
4b) Format the mount.cfg file in accordance with this guide: https://wiki.facepunch.com/gmod/Mounting_Content_on_a_Dedicated_Server
4c) Ensure the paths are correct and pointed at /cstrike/ and /tf/ respectively

5a) Run run.bat in the main directory to launch the server