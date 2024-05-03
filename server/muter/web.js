require('dotenv-flow').config({
    silent: true
});
const Discord = require('discord.js');
const http = require('http');
const https = require('https');
const chalk = require('chalk');
const packageData = require('./package');

const VERSION = String(packageData.version);
const DEBUG = Boolean(process.env.DEBUG == 1);
const PORT = Number(process.env.PORT) || 37405; //unused port and since now the OFFICIAL ttt_discord_bot port ;)
const DISCORD_GUILD = String(process.env.DISCORD_GUILD);
const DISCORD_CHANNEL = String(process.env.DISCORD_CHANNEL);
const DISCORD_TOKEN = String(process.env.DISCORD_TOKEN);
const KEEPALIVE_HOST = String(process.env.KEEPALIVE_HOST);
const KEEPALIVE_PORT = Number(process.env.KEEPALIVE_PORT) || PORT;
const KEEPALIVE_ENABLED = Boolean(process.env.KEEPALIVE_ENABLED == 1);
const API_KEY = String(process.env.API_KEY) || false;

const getTimestamp = () => {
    let date = new Date();
    let hours = String(date.getHours() % 12).padStart(2, '0');
    let minutes = String(date.getMinutes()).padStart(2, '0');
    let seconds = String(date.getSeconds()).padStart(2, '0');
    return `[${hours}:${minutes}:${seconds}] `;
}

// Secure logging (for initial log of information)
const slog = (...msgs) => {
    if (!DEBUG) return;
    console.log(chalk.blue(...msgs.map((m) => getTimestamp() + m)));
}
// Regular logging (for requests/responses)
const log = (...msgs) => {
    if (!DEBUG) return;
    console.log(...msgs.map((m) => {
        if (typeof m === 'string') {
            return getTimestamp() + m.replace(API_KEY, "API_KEY_OBFUSCATED");
        }
        return getTimestamp() + m;
    }));
};
const error = (...msgs) => console.error(chalk.red.bold(...msgs.map((m) => getTimestamp() + m)));
const warn = (...msgs) => console.log(chalk.hex('#FF8800')(...msgs.map((m) => getTimestamp() + m)));
const br = newLine = () => console.log();

slog('Constants: ');
slog(`  VERSION: ${chalk.bold(VERSION)} (${typeof VERSION})`);
slog(`  DEBUG: ${chalk.bold(DEBUG)} (${typeof DEBUG})`);
slog(`  PORT: ${chalk.bold(PORT)} (${typeof PORT})`);
slog(`  DISCORD_GUILD: ${chalk.bold(DISCORD_GUILD)} (${typeof DISCORD_GUILD})`);
slog(`  DISCORD_CHANNEL: ${chalk.bold(DISCORD_CHANNEL)} (${typeof DISCORD_CHANNEL})`);
slog(`  DISCORD_TOKEN: ${chalk.bold(DISCORD_TOKEN)} (${typeof DISCORD_TOKEN})`);
slog(`  KEEPALIVE_HOST: ${chalk.bold(KEEPALIVE_HOST)} (${typeof KEEPALIVE_HOST})`);
slog(`  KEEPALIVE_PORT: ${chalk.bold(KEEPALIVE_PORT)} (${typeof KEEPALIVE_PORT})`);
slog(`  KEEPALIVE_ENABLED: ${chalk.bold(KEEPALIVE_ENABLED)} (${typeof KEEPALIVE_ENABLED})`);
slog(`  API_KEY: ${chalk.bold(API_KEY)} (${typeof API_KEY})`);
br(); // New Line

let isBotReady = false;

//create discord client
const bot = new Discord.Client();
bot.login(DISCORD_TOKEN);

bot.on('ready', () => {
    isBotReady = true;
        log(chalk.green('Bot is ready to mute them all! :)'));
        br();
});

bot.on('error', (err) => {
    error(err)
})

bot.on('voiceStateUpdate', (oldState, newState) => {
    if (newState.channelID !== oldState.channelID) {
        if (newState.channelID === null) {
            log(chalk.yellow(`${oldState.member.displayName} (${oldState.member.id}) left voice channels.`));
        }
        else {
            log(chalk.yellow(`${newState.member.displayName} (${newState.member.id}) joined "${newState.channel.name}" (${newState.channel.id})${(newState.channelID === DISCORD_CHANNEL) ? ' [Muter Channel]' : ''}.`));
        }
    }
});


const requests = {
    connect: (params, ret) => {
        let tag_utf8 = params.tag.split(" ");
        let tag = "";
    
        tag_utf8.forEach((char) => {
            tag = tag + String.fromCharCode(char);
        });
    
        log(
            "[Connect][Requesting]",
            `Searching for "${tag}" (utf8: "${params.tag}")`
        );
        let discordGuild = bot.guilds.cache.get(DISCORD_GUILD);
        const found = discordGuild.members.cache.find(user =>
            (user.id === tag || user.displayName.match(new RegExp(`.*${tag}.*`))) || false
        );
    
        if (!found) {
            ret({
                answer: 0 //no found
            });
            error(
                "[Connect][Error]",
                `0 users found with tag "${tag}".`
            );
        } else {
            ret({
                tag: found.displayName,
                id: found.id
            });
            log(chalk.green(
                "[Connect][Success]",
                `Connecting ${found.displayName} (${found.id})`
            ));
        }
    },

    mute: (params, ret) => {
        let id = params.id;
        let mute = params.mute;
        if (typeof id !== 'string' || typeof mute !== 'boolean') {
            ret({
                success: false,
                error: "ID or Mute value missing", //legacy
                errorMsg: "ID or Mute value missing",
                errorId: "INVALID_PARAMS"
            });
            error(
                "[Mute][Missing Params]",
                `id: "${id}" (${typeof id}),`,
                `mute: "${mute}" (${typeof mute})`
            );
            return;
        }
        log(
            "[Mute][Requesting]",
            params
        );
    
        let discordGuild = bot.guilds.cache.get(DISCORD_GUILD);
        discordGuild.members.fetch(id)
            .then((member) => {
                // Incorrect channel
                if (member.voice.channelID != DISCORD_CHANNEL) {
                    ret({
                        success: false,
                        error: "member not in voice channel", //legacy
                        errorMsg: "member not in voice channel",
                        errorId: "DISCORD_MEMBER_NOT_IN_CHANNEL"
                    });
                    warn(`Member ${member.displayName} was not in voice channel!`);
                    return;
                }

                // Already muted
                if (member.voice.serverMute && mute) {
                    ret({
                        success: false,
                        error: "member already muted", //legacy
                        errorMsg: "member already muted",
                        errorId: "DISCORD_MEMBER_NOT_IN_CHANNEL"
                    });
                    warn(`Member ${member.displayName} already muted!`);
                    return
                }

                // Already not muted
                if (!member.voice.serverMute && !mute) {
                    ret({
                        success: false,
                        error: "member not muted", //legacy
                        errorMsg: "member not muted",
                        errorId: "DISCORD_MEMBER_NOT_IN_CHANNEL"
                    });
                    warn(`Member ${member.displayName} was not muted!`);
                    return
                }

                if (mute) {
                    member.voice.setMute(true).then(() => {
                        ret({
                            success: true
                        });
                        log(
                            "[Mute][Discord:SetMute][Success]",
                            `Muted ${id}`
                        );
                    }).catch((err) => {
                        ret({
                            success: false,
                            error: err, //Legacy
                            errorMsg: err,
                            errorId: "DISCORD_ERROR"
                        });
                        error(
                            "[Mute][Discord:SetMute][Error]",
                            `Mute: ${id} - ${err}`
                        );
                    });
                }
                if (!mute) {
                    member.voice.setMute(false).then(() => {
                        ret({
                            success: true
                        });
                        log(
                            "[Mute][Discord:SetMute][Success]",
                            `Unmuted ${id}`
                        );
                    }).catch((err) => {
                        ret({
                            success: false,
                            error: err, //Legacy
                            errorMsg: err,
                            errorId: "DISCORD_ERROR"
                        });
                        error(
                            "[Mute][Discord:SetMute][Error]",
                            `Unmute: ${id} - ${err}`
                        );
                    });
                }
            })
            .catch((err) => {
                ret({
                    success: false,
                    error: "unknown error", //legacy
                    errorMsg: "unknown error",
                    errorId: "DISCORD_MEMBER_NOT_IN_CHANNEL"
                });
                error(
                    "[Mute][Error] Unknown error",
                    err
                );
            });
    },

    keep_alive: (params, ret) => {
        ret({
            success: true,
        });
        log(
            "[KeepAlive][Request]",
            params
        );
    },

    sync: (params, ret) => {
        ret({
            success: true,
            version: VERSION,
            debugMode: DEBUG,
            discordGuild: DISCORD_GUILD,
            discordChannel: DISCORD_CHANNEL
        });
        log(
            "[Sync][Request]",
            params
        );
    },

    keepAliveReq: () => {
        const options = {
            host: KEEPALIVE_HOST,
            port: KEEPALIVE_PORT,
            path: '/keep_alive',
            headers: {
                req: 'keep_alive',
                params: '{}',
                authorization: `Basic ${API_KEY}`
            },
            timeout: 5 * 1000 // 5 second request timeout.
        };
        log(
            "[KeepAlive][Requesting]",
            options
        );
        https.get(options, (res) => {
            const { statusCode } = res;
            if (statusCode === 200) {
                log(
                    "[KeepAlive][Success]",
                    `Request successful`
                );
            } else {
                error(
                    "[KeepAlive][Error]",
                    `Request Failed Status Code: ${statusCode}`
                );
            }
        });
    },
};


http.createServer((req, res) => {
    if (!isBotReady) {
        error('bot still loading');
        return;
    }
    if (
        typeof req.headers.params === 'string' &&
        typeof req.headers.req === 'string' &&
        typeof requests[req.headers.req] === 'function' &&
        typeof API_KEY === 'string' && req.headers.authorization === `Basic ${API_KEY}`
    ) {
        try {
            let params = JSON.parse(req.headers.params);
            requests[req.headers.req](
                params,
                (ret) => res.end(
                    JSON.stringify(ret)
                )
            );
        } catch (err) {
            res.end(err.msg);
            error(
                "[ERROR][Request]",
                err
            );
            error(
                "[ERROR][Request Headers]",
                JSON.stringify(req.headers)
            )
        }
    } else {
        error(
            "[ERROR][Request Headers]",
            req.headers
        )
        if (typeof API_KEY === 'string' && req.headers.authorization !== `Basic ${API_KEY}`) {
            res.writeHead(401);
            res.end(JSON.stringify({
                error: "Authorisation Miss-Match", //Legacy
                errorMsg: "Authorisation Miss-Match",
                errorId: "AUTHORIZATION_MISSMATCH"
            }));
            error(
                "[ERROR][Authorisation]",
                `"${req.headers.authorization}" !== "Basic ${API_KEY}"`
            );
        } else if (requests[req.headers.req] !== 'function') {
            res.writeHead(400);
            res.end(JSON.stringify({
                error: `Unknown request "${req.headers.req}"`, //Legacy
                errorMsg: `Unknown request "${req.headers.req}"`,
                errorId: "UNKNOWN_REQUEST"
            }));
            error(
                "[ERROR][Request]",
                `Unknown request "${req.headers.req}"`
            );
        } else {
            res.writeHead(400);
            res.end(JSON.stringify({
                error: `Unknown`, //Legacy
                errorMsg: `Unknown`,
                errorId: "UNKNOWN_ERROR"
            }));
            error(
                "[ERROR][Request]",
                `Unknown request "${req.headers.req}"`
            );
        }
    }
}).listen({
    port: PORT
}, () => {
    log(chalk.green(`Bot endpoint is running: https://${KEEPALIVE_HOST}:${KEEPALIVE_PORT || PORT}`));

    if (KEEPALIVE_ENABLED) {
        log(
            "[KeepAlive][Startup]",
            `Initialisation`
        );

        setInterval(keepAliveReq, 20 * 60 * 1000); // load every 20 minutes
        setTimeout(keepAliveReq, 3 * 1000); // load first attempt after 3 seconds.
    }
});