let WebSocket = require('ws');
let express = require('express');
let app = express();
app.use(express.json());

app.use(express.static(__dirname));

app.get('/', function (req, res) {
    res.sendFile(__dirname + '/index.html');
});

let server = app.listen(8080, function () {
    let port = server.address().port;

    console.log('Listening at port %s', port);
});

let wss = new WebSocket.Server({ port: 3476 });
let socket = null;
wss.on('connection', function connection(ws) {
    socket = ws;
    console.log('Client connected');
});

app.post('/', function (req, res) {
    if (socket != null) {
        let heartRate = req.body.heartRate;
        let calories = req.body.calories;

        if (typeof heartRate !== 'undefined'){
            socket.send('heartRate:' + heartRate);
            console.log('heartRate: ' + heartRate);
        }

        if (typeof calories !== 'undefined'){
            socket.send('calories:' + calories);
            console.log('calories:' + calories);
        }
    }
});