from startserver import startserver
import os

startserver()
os.system("start cmd /c wsl")
os.system("npm start --prefix ./Muter")