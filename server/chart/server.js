import express from 'express';
import sqlite3 from 'sqlite3';
import {open} from 'sqlite';
import path from 'path';
import {fileURLToPath} from 'url';
import fs from 'fs';

let lastRefresh = 0;
let stats = [];

// Establish database connection
const db = await open({
    filename: path.join(path.dirname(fileURLToPath(import.meta.url)), "..") + "/garrysmod/sv.db",
    driver: sqlite3.Database,
    mode: sqlite3.OPEN_READONLY,
})

async function refreshData(force=false) {
    if (!force && Date.now() - lastRefresh < 60 * 5) {
        return;
    }
    lastRefresh = Date.now();

    /*
    CREATE TABLE WeaponStats(
        Name TEXT PRIMARY KEY NOT NULL,
        Type TEXT,
        Damage NUMBER,
        Kills NUMBER,
        Headshots NUMBER,
        Usage NUMBER
    )
    */

    let raw = await db.all('SELECT Name, Usage, Damage FROM WeaponStats');

    // Filter out usage = 0
    raw = raw.filter((stat) => stat.Usage > 0);
    let processed = [];
    for (let stat of raw) {
        //await processIcon(stat.Name);
        let newStat = {
            name: stat.Name,
            presence: stat.Usage / Math.max(...raw.map((stat) => stat.Usage)),
            effectiveness: stat.Damage / Math.max(...raw.map((stat) => stat.Damage)),
            url: "/image/" + stat.Name + ".png",
        };
        processed.push(newStat);
    }
    stats = processed;
    console.log("Reprocessed stats!")
}

const app = express();
const port = 3000;

app.use((request, response, next) => {
    console.log("url:", request.url);
    next();
});

app.get("/all", async (request, response) => {
    await refreshData();
    response.send(JSON.stringify(stats));
});

app.get("/refresh", async (request, response) => {
    await refreshData(force=true);
    response.send(JSON.stringify(stats));
});

app.use(express.static('public'));
app.use(express.json());

app.listen(port, async () => {
    await refreshData();
    console.log(`Running webserver on port ${port}.`);
})