const version = '9.2.0'; // Make sure this matches the version in package.json

const WebSocket = require('ws');
const express = require('express');
const app = express();
const request = require('request');
const semver = require('semver');
const path = require('path');
const fs = require('fs');
const glob = require('glob');

// Show the error to the user instead of instantly exiting
process.on('uncaughtException', function (err) {
    console.log(err);
    console.log('The application has crashed. If you need help, please visit https://git.io/JTzfb.');
    while (true) {
        // Force the application to stay alive
    }
});

// Create config
let configFilePath = path.dirname(process.execPath) + '/config.json';
let config;
if (fs.existsSync(configFilePath)) {
    config = JSON.parse(fs.readFileSync(configFilePath, 'utf8'));
} else {
    config = JSON.parse('{}');
}

// Add missing config values
if (!config.httpPort) {
    config.httpPort = 8080;
}
if (!config.websocketPort) {
    config.websocketPort = 3476;
}
if (!config.discordRichPresenceEnabled) {
    config.discordRichPresenceEnabled = 'true';
}

// Convert image files to base64
function base64_encode(file) {
    let bitmap = fs.readFileSync(file);
    return new Buffer.from(bitmap).toString('base64');
}

function searchForFileAndEncode(fileName, encoding) {
    let files = glob.sync(`${path.dirname(process.execPath)}/${fileName}.*`, null);
    if (files.length === 0) {
        console.log(`No ${fileName} file found`);
        return null;
    } else if (files.length > 1) {
        console.log(`Multiple ${fileName} files found. Picking the worst one just for you.`);
    }

    return encoding + base64_encode(files[0]);
}

let hrImage = searchForFileAndEncode('hrImage', 'data:image/png;base64,');
if (hrImage != null) {
    config.hrImage = hrImage;
}
let calImage = searchForFileAndEncode('calImage', 'data:image/png;base64,');
if (calImage != null) {
    config.calImage = calImage;
}
let beatSound = searchForFileAndEncode('beatSound', 'data:audio/wav;base64,');
if (beatSound != null) {
    config.beatSound = beatSound;
}

// Collect and show the possible IP addresses of this machine
const {networkInterfaces} = require('os');

const nets = networkInterfaces();
const results = Object.create(null); // or just '{}', an empty object

for (const name of Object.keys(nets)) {
    for (const net of nets[name]) {
        // skip over non-ipv4 and internal (i.e. 127.0.0.1) addresses
        if (net.family === 'IPv4' && !net.internal) {
            if (!results[name]) {
                results[name] = [];
            }

            results[name].push(net.address);
        }
    }
}
console.log('Possible IP addresses of this machine:')
for (const [adapterName, addresses] of Object.entries(results)) {
    for (const address of addresses) {
        console.log('\t' + adapterName + ': ' + address);
    }
}

// Check for updates
request('https://git.io/JJ8uD', {json: true}, (err, res, body) => {
    if (err) {
        return console.log('Unable to complete version check');
    }

    if (semver.gt(body.version, version)) {
        console.log('There is a new version available (' + version + ' -> ' + body.version + ')! Download it here: https://git.io/JJ8uR');
    } else if (semver.gt(version, body.version)) {
        console.log('You are running an unreleased version (' + version + ' -> ' + body.version + '). Feeling adventurous, are we?');
    } else {
        console.log('You are running the latest version (' + version + '). Enjoy!');
    }
});

app.use(express.json());
app.use(express.static(__dirname));

app.get('/', function (req, res) {
    res.sendFile(__dirname + '/index.html');
});

app.get('/config', (req, res) => res.json(config));

let server = app.listen(config.httpPort, function () {
    let port = server.address().port;

    console.log('HTTP server started on port %s', port);
});

let wss = new WebSocket.Server({port: config.websocketPort});
let webClients = [];
wss.on('listening', function () {
    console.log('WebSocket server started on port %s', config.websocketPort);
});
wss.on('connection', function connection(ws) {
    ws.on('message', function incoming(message) {
        if (message === 'webClient') {
            // The client identified itself as a webClient
            webClients.push(ws);
            console.log('WebSocket web client connected (' + ws._socket.remoteAddress + ')');

            // Send current data to the web client
            ws.send('heartRate:' + currentHeartRate);
            ws.send('calories:' + currentCalories);
            ws.send('hrColor:' + currentHrColor);
        } else {
            sendDataToWebClients(message);
        }
    });
    ws.on('ping', function heartbeat() {
        // Let the web clients know the watch is connected
        sendDataToWebClients('ping');
    });
    // Catch web socket errors instead of crashing
    ws.on('error', console.error);
});

let currentHeartRate = '0';
let currentCalories = '0';
let currentHrColor = '#FC3718';

function sendDataToWebClients(data) {
    console.log(data);

    // Remove disconnected clients
    webClients.filter(client => client.readyState === WebSocket.CLOSED).forEach(disconnectedClient => {
        console.log('WebSocket client disconnected (' + disconnectedClient._socket.remoteAddress + ')');
        webClients = webClients.filter(client => client !== disconnectedClient);
    });

    webClients.forEach(client => {
        client.send(data);
    });

    // Save the data for later
    let dataType = data.split(':')[0];
    let dataValue = data.split(':')[1];
    if (dataType === 'heartRate') {
        currentHeartRate = dataValue;
    } else if (dataType === 'calories') {
        currentCalories = dataValue;
    } else if (dataType === 'hrColor') {
        currentHrColor = dataValue;
    }

    setDiscordRichPresence();
}

let DiscordRPC = require('discord-rpc');
let discordRpc = new DiscordRPC.Client({transport: 'ipc'});
discordRpc.login({clientId: '719260544481099857'}).catch(error => {
    // Eat errors because the user probably doesn't care
});
let startTimestamp = null;
let clearActivityTimeout;

function setDiscordRichPresence() {
    if (config.discordRichPresenceEnabled !== 'true') {
        return;
    }

    // Clear the activity if we have not received a message for a long time
    clearTimeout(clearActivityTimeout);
    clearActivityTimeout = setTimeout(function () {
        console.log('Data not received for a long time. Discord Rich Presence cleared.');
        discordRpc.clearActivity()
            .catch(error => {
                // Eat errors because the user probably doesn't care
            });

        // Reset the start timestamp so it makes sense
        startTimestamp = null;
    }, 5 * 60000); // 5 minutes

    let detailsString = 'HR: ';
    if (currentHeartRate !== '0') {
        detailsString += currentHeartRate;
    } else {
        detailsString += '-';
    }
    if (currentCalories !== '0') {
        detailsString += ', CAL: ' + currentCalories;
    }

    if (startTimestamp == null) {
        startTimestamp = Date.now();
    }

    discordRpc.setActivity({
        details: detailsString,
        state: 'git.io/JfMAZ',
        startTimestamp: startTimestamp,
        largeImageKey: 'hds_icon',
    }).catch(error => {
        // Eat errors because the user probably doesn't care
    });
}