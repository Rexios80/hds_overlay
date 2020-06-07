function connect() {
    let socket = new WebSocket('ws://localhost:3476');

    let heartRateText = null;
    let caloriesText = null;

    socket.onopen = function (event) {
        console.log('Connected to server');
        heartRateText = document.querySelector('#heartRate');
        caloriesText = document.querySelector('#calories');
    };

    socket.onclose = function (event) {
        console.log('Disconnected from server');
        setTimeout(function() {
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

    socket.onmessage = function (event) {
        console.log(event.data);

        let data = event.data.split(':');

        if (data[0] === 'heartRate') {
            heartRateText.textContent = data[1];
        }

        if (data[0] === 'calories') {
            caloriesText.textContent = data[1];
        }
    };
}

connect();