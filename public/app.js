const version = '7.2.0'; // Make sure this matches the version in package.json

const WebSocket = require('ws');
const express = require('express');
const app = express();
const request = require('request');
const semver = require('semver');
const path = require('path');
const fs = require('fs');

// Show the error to the user instead of instantly exiting
process.on('uncaughtException', function (err) {
    console.log(err);
    console.log('The application has crashed. If you need help, please create an issue on the GitHub page.');
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
    // Default values
    config = JSON.parse('{ "httpPort": 8080, "websocketPort": 3476, "websocketIp": "localhost" }');
}

// Throw an exception if websocketIp is not specified to make this easily noticeable to the user
// Otherwise the webpage will not connect and the user may not know why
if (!config.websocketIp) {
    throw '\"websocketIp\" must be specified in the config file';
}

// Convert image files to base64
function base64_encode(file) {
    let bitmap = fs.readFileSync(file);
    return new Buffer.from(bitmap).toString('base64');
}

if (typeof config.hrImageFile !== 'undefined') {
    config.hrImage = 'data:image/png;base64, ' + base64_encode(path.dirname(process.execPath) + '/' + config.hrImageFile)
}
if (typeof config.calImageFile !== 'undefined') {
    config.calImage = 'data:image/png;base64, ' + base64_encode(path.dirname(process.execPath) + '/' + config.calImageFile)
}

// Collect and show the possible IP addresses of this machine
const { networkInterfaces } = require('os');

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
        console.log('There is a new version available! Download it here: https://git.io/JJ8uR');
    } else if (semver.gt(version, body.version)) {
        console.log('You are running an unreleased version. Feeling adventurous, are we?');
    } else {
        console.log('You are running the latest version. Enjoy!');
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
    console.log('WebSocket clients will connect to %s', config.websocketIp);
});
wss.on('connection', function connection(ws) {
    ws.on('message', function incoming(message) {
        if (message === 'webClient') {
            webClients.push(ws);
            console.log('WebSocket web client connected (' + ws._socket.remoteAddress + ')');
        } else {
            sendDataToWebClients(message);
        }
    });
});

let DiscordRPC = require('discord-rpc');
let discordRpc = new DiscordRPC.Client({transport: 'ipc'});
// Eat errors because the user probably doesn't care
discordRpc.login({clientId: '719260544481099857'}).catch(error => {
});
let startTimestamp = Date.now();
let currentHeartRate = '-'
let currentCalories = '-'

function sendDataToWebClients(data) {
    console.log(data)

    // Remove disconnected clients
    webClients.filter(client => client.readyState === WebSocket.CLOSED).forEach(disconnectedClient => {
        console.log('WebSocket client disconnected (' + disconnectedClient._socket.remoteAddress + ')');
        webClients = webClients.filter(client => client !== disconnectedClient);
    });

    webClients.forEach(client => {
        client.send(data);
    });

    let dataType = data.split(':')[0];
    let dataValue = data.split(':')[1];
    if (dataType === 'heartRate') {
        currentHeartRate = dataValue;
    } else if (dataType === 'calories') {
        currentCalories = dataValue;
    }

    let detailsString = 'HR: ' + currentHeartRate
    if (currentCalories !== '0') {
        detailsString += ', CAL: ' + currentCalories
    }

    // Eat errors because the user probably doesn't care
    discordRpc.setActivity({
        details: detailsString,
        state: 'git.io/JfMAZ',
        startTimestamp: startTimestamp,
        largeImageKey: 'hds_icon',
    }).catch(error => {
    });
}