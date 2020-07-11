let WebSocket = require('ws');
let express = require('express');
let app = express();
let path = require('path');
let fs = require('fs');

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

app.use(express.json());
app.use(express.static(__dirname));

app.get('/', function (req, res) {
    res.sendFile(__dirname + '/index.html');
});

app.get('/config', (req, res) => res.json(config));

let server = app.listen(config.httpPort, function () {
    let port = server.address().port;

    console.log('Listening at port %s', port);
});

let wss = new WebSocket.Server({port: config.websocketPort});
let socket = null;
wss.on('connection', function connection(ws) {
    socket = ws;
    console.log('Client connected');
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