let WebSocket = require('ws');
let express = require('express');
let app = express();
let path = require('path');
require(`dotenv-defaults`).config({
    path: path.dirname(process.execPath) + '/config.env',
    defaults: __dirname + '/config.env.defaults'
})

app.use(express.json());
app.use(express.static(__dirname));

app.get('/', function (req, res) {
    res.sendFile(__dirname + '/index.html');
});

let server = app.listen(process.env.HTTP_PORT, function () {
    let port = server.address().port;

    console.log('Listening at port %s', port);
});

let wss = new WebSocket.Server({port: process.env.WEBSOCKET_PORT});
let socket = null;
wss.on('connection', function connection(ws) {
    socket = ws;
    console.log('Client connected');
});

const rpClient = require('discord-rich-presence')('719260544481099857');
let startTimestamp = Date.now();
let currentHeartRate = '-'
let currentCalories = '-'

// Hide error when Discord is not open. It looks scary and might make users think there is a problem.
rpClient.on('error', function () {
})

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

    rpClient.updatePresence({
        details: 'HR: ' + currentHeartRate + ', CAL: ' + currentCalories,
        state: 'git.io/JfMAZ',
        startTimestamp: startTimestamp,
        largeImageKey: 'hds_icon',
    });

    res.end();
});