let socket = new WebSocket("ws://localhost:3476");

socket.onopen = function (event) {
    socket.send("Here's some text that the server is urgently awaiting!");
};

socket.onmessage = function (event) {
    console.log(event.data);
};