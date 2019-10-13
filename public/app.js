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