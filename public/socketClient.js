let config;

function connect() {
    let socket = new WebSocket('ws://localhost:' + config.websocketPort);

    let statusDisplay = null;
    let dataDisplay = null;

    let heartRateText = null;
    let caloriesText = null;

    socket.onopen = function (event) {
        console.log('Connected to server on port: ' + config.websocketPort);

        statusDisplay = document.getElementById('statusDisplay');
        dataDisplay = document.getElementById('dataDisplay');

        heartRateText = document.getElementById('heartRate');
        caloriesText = document.getElementById('calories');

        document.getElementById('hrImage').src = typeof config.hrImage === 'undefined' ? 'hrImage.png' : config.hrImage;
        document.getElementById('calImage').src = typeof config.calImage === 'undefined' ? 'calImage.png' : config.calImage;
    };

    socket.onclose = function (event) {
        console.log('Disconnected from server');
        setTimeout(function () {
            connect();
        }, 1000);
    };

    socket.onerror = function (event) {
        console.log('WebSocket error');
        // TODO: Does this mean the socket is disconnected?
        // setTimeout(function() {
        //     connect();
        // }, 1000);
    };

    let heartbeatTimeout;
    socket.onmessage = function (event) {
        console.log(event.data);

        statusDisplay.style.display = 'none'
        dataDisplay.style.display = 'block'
        clearTimeout(heartbeatTimeout)
        heartbeatTimeout = setTimeout(function () {
            statusDisplay.style.display = 'block'
            dataDisplay.style.display = 'none'
        }, 60000) // 60 seconds

        let data = event.data.split(':');

        if (data[0] === 'heartRate') {
            heartRateText.textContent = data[1];
        }

        if (data[0] === 'calories') {
            caloriesText.textContent = data[1];
        }
    };
}

// Request the config from the server
let xmlHttp = new XMLHttpRequest();
xmlHttp.open('GET', '/config', false); // false for synchronous request
xmlHttp.send(null);
config = JSON.parse(xmlHttp.responseText);
connect();