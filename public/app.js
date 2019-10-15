let WebSocket = require('ws');
let express = require('express');
let app = express();
app.use(express.json());

app.use(express.static(__dirname));

app.get('/', function (req, res) {
    res.sendFile(__dirname + '/index.html');
});

app.post('/', function (req, res) {
    let heartRate = req.body.heartRate;
    let calories = req.body.calories;

    if (typeof heartRate !== 'undefined'){
        console.log("heartRate: " + heartRate);
    }

    if (typeof calories !== 'undefined'){
        console.log("calories: " + calories);
    }
});

let server = app.listen(8080, function () {
    let port = server.address().port;

    console.log('Listening at port %s', port);
});

let wss = new WebSocket.Server({ port: 3476 });
wss.on('connection', function connection(ws) {
    console.log('Client connected');
    ws.on('message', function incoming(message) {
        console.log('received: %s', message);
    });

    ws.send('something');
});