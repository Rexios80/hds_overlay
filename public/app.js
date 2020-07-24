const version = '6.0.0'; // Make sure this matches the version in package.json

const WebSocket = require('ws');
const express = require('express');
const app = express();
const request = require('request');
const semver = require('semver');
const path = require('path');
const fs = require('fs');

// Create config
let configFilePath = path.dirname(process.execPath) + '/config.json';
let config;
if (fs.existsSync(configFilePath)) {
    config = JSON.parse(fs.readFileSync(configFilePath, 'utf8'));
} else {
    // Default values
    config = JSON.parse('{ "httpPort": 8080, "websocketPort": 3476 }');
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
let socket = null;
wss.on('listening', function () {
    console.log('WebSocket server started on port %s', config.websocketPort);
});
wss.on('connection', function connection(ws) {
    socket = ws;
    console.log('WebSocket client connected');
});

let DiscordRPC = require('discord-rpc');
let discordRpc = new DiscordRPC.Client({transport: 'ipc'});
// Eat errors because the user probably doesn't care
discordRpc.login({clientId: '719260544481099857'}).catch(error => {
});
let startTimestamp = Date.now();
let currentHeartRate = '-'
let currentCalories = '-'

app.post('/', function (req, res) {
    console.log(req.body);

    let heartRate = req.body.heartRate;
    let calories = req.body.calories;

    if (typeof heartRate !== 'undefined') {
        if (socket != null) {
            socket.send('heartRate:' + heartRate);
        }
        currentHeartRate = heartRate
    }

    if (typeof calories !== 'undefined') {
        if (socket != null) {
            socket.send('calories:' + calories);
        }
        currentCalories = calories
    }

    // Eat errors because the user probably doesn't care
    discordRpc.setActivity({
        details: 'HR: ' + currentHeartRate + ', CAL: ' + currentCalories,
        state: 'git.io/JfMAZ',
        startTimestamp: startTimestamp,
        largeImageKey: 'hds_icon',
    }).catch(error => {
    });

    res.end();
});