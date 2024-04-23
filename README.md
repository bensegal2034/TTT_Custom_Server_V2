# What is this?
This repository contains a Garry's Mod server. It is intended to host a modified version of the [Trouble in Terrorist Town gamemode](https://www.troubleinterroristtown.com/) created by Bad King Urgrain, with new weapons, mechanics, and maps.

# Installation
1)
a. Install Git, Python, Node.JS, Counter-Strike: Source, and Team Fortress 2.\
b. Ensure Git, Python, and Node.JS are added to your PATH in Windows.

2)
a. Open a new terminal window in the root directory of the repository, run `pip install -r requirements.txt`.\
b. Change directory to GMod/FastDL/, run `npm install`.\
c. Change directory to GMod/Muter/, run `npm install`.

3)
a. Create a new file in GMod/garrysmod/cfg/ named mount.cfg.\
b. Format the mount.cfg file in accordance with this [guide](https://wiki.facepunch.com/gmod/Mounting_Content_on_a_Dedicated_Server).\
c. Ensure the paths are correct and pointed at /cstrike/ and /tf/ respectively.

4)
Run run.bat in the main directory to launch the server.
