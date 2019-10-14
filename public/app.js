let WebSocket = require('ws');
let express = require('express');
let app = express();

app.use(express.static(__dirname));

app.get('/', function (req, res) {
    res.sendFile(__dirname + '/index.html');
});

let server = app.listen(8080, function () {
    let port = server.address().port;

    console.log('Listening at port %s', port);
});

// This wouldn't work in it's own file for some reason
let wss = new WebSocket.Server({ port: 3476 });

wss.on('connection', function connection(ws) {
    console.log('Client connected');
    ws.on('message', function incoming(message) {
        console.log('received: %s', message);
    });

    ws.send('something');
});