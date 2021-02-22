let config;
let heartbeatTimeout;
let animateHrImage;

const hrImageScaleMin = 0.85;
const hrImageScaleMax = 1;

let currentHeartRate = 0;
let currentHrColor = null;
let currentHrMin = 500;
let currentHrMax = 0;

let beatSound = null;

function connect() {
    // Assume the websocket server is running in the same place as the web server
    // MAYBE a bad assumption to make, but if a user is competent enough to split the two pieces I think they can handle it
    // This makes life easier for normal users
    let socket = new WebSocket('ws://' + window.location.hostname + ':' + config.websocketPort + window.location.pathname);
    console.log(socket);

    let statusDisplay = null;
    let dataDisplay = null;
    let caloriesDisplay = null;

    let heartRateText = null;
    let caloriesText = null;

    let hrMinText = null;
    let hrMaxText = null;

    socket.onopen = function (event) {
        console.log('Connected to server on port: ' + config.websocketPort);

        // Identify as a web client to the server
        socket.send('webClient');

        statusDisplay = document.getElementById('statusDisplay');
        dataDisplay = document.getElementById('dataDisplay');
        caloriesDisplay = document.getElementById('caloriesDisplay');

        heartRateText = document.getElementById('heartRate');
        caloriesText = document.getElementById('calories');

        hrMinText = document.getElementById('hrMinText');
        hrMaxText = document.getElementById('hrMaxText');

        let hrImage = document.getElementById('hrImage');

        animateHrImage = getComputedStyle(hrImage).getPropertyValue('--animate').trim() === 'true';

        hrImage.src = typeof config.hrImage === 'undefined' ? 'hrImage.png' : config.hrImage;
        document.getElementById('calImage').src = typeof config.calImage === 'undefined' ? 'calImage.gif' : config.calImage;
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

    socket.onmessage = function (event) {
        console.log(event.data);

        statusDisplay.style.display = 'none';
        dataDisplay.style.display = 'flex';
        clearTimeout(heartbeatTimeout);
        heartbeatTimeout = setTimeout(function () {
            console.log('Disconnected from watch');
            statusDisplay.style.display = 'flex';
            dataDisplay.style.display = 'none';
        }, 60000); // 60 seconds

        let data = event.data.split(':');

        if (data[0] === 'heartRate') {
            currentHeartRate = data[1];
            if (currentHeartRate === '0') {
                heartRateText.textContent = '-';
            } else {
                heartRateText.textContent = currentHeartRate;
                updateHeartRateUI();
            }
        } else if (data[0] === 'calories') {
            let calories = data[1];
            caloriesText.textContent = calories;
            if (calories === '0') {
                caloriesDisplay.style.display = 'none';
            } else {
                caloriesDisplay.style.display = 'flex';
            }
        } else if (data[0] === 'hrColor') {
            currentHrColor = data[1];
            heartRateText.style.color = currentHrColor;
        }
    };

    async function updateHeartRateUI() {
        if (animateHrImage) {
            updateHrImageAnimation();
        }

        await sleep(100); // Wait for hrColor to arrive (might need tweaking)

        if (currentHeartRate < currentHrMin) {
            currentHrMin = currentHeartRate;
            hrMinText.textContent = currentHrMin;
            hrMinText.style.color = currentHrColor;
        }
        if (currentHeartRate > currentHrMax) {
            currentHrMax = currentHeartRate;
            hrMaxText.textContent = currentHrMax;
            hrMaxText.style.color = currentHrColor;
        }
    }
}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

let hrAnimation = null;
let hrAnimationLoopBeginnings = 0;
let hrAnimationLoopCompletions = 0;

function updateHrImageAnimation() {
    if ((hrAnimationLoopCompletions !== 0 && hrAnimationLoopCompletions % 2 !== 0) || hrAnimationLoopCompletions !== hrAnimationLoopBeginnings || currentHeartRate === 0) {
        // Mod of 0 is 1 (thanks math)
        // Wait for the current animation to finish before updating the duration
        // A loop is one direction of the animation so we need 2 of them to run for the full animation to be complete
        // Also the number of loop starts needs to equal the number of loop completions or else we might kill the animation in the middle
        // Also don't animate if the heart rate is currently 0 since that breaks things
        setTimeout(updateHrImageAnimation, 50);
        return;
    }

    // Prevent an overflow or something dumb from happening
    hrAnimationLoopBeginnings = 0;
    hrAnimationLoopCompletions = 0;

    if (hrAnimation == null) {
        // The animation is starting for the first time
        // Animate the image to the min before starting the animation
        anime({
            targets: '.hrImage',
            easing: 'easeInOutSine',
            scale: hrImageScaleMin,
        }).finished.then(() => {
            startHrAnimation();
        });
    } else {
        // The animation is being restarted with a new duration
        anime.remove('.hrImage');
        startHrAnimation();
    }
}

function startHrAnimation() {
    let millisecondsPerBeat = 60 / currentHeartRate * 1000;

    hrAnimation = anime.timeline({
        targets: '.hrImage',
        loop: true,
        easing: 'easeInOutSine',
        loopBegin: (() => {
            hrAnimationLoopBeginnings++;
        }),
        loopComplete: (() => {
            hrAnimationLoopCompletions++;
            if (beatSound != null && hrAnimationLoopCompletions % 2 === 1) {
                // Only play with one loop
                beatSound.currentTime = 0;
                beatSound.play();
            }
        })
    });
    hrAnimation.add({
        scale: hrImageScaleMax,
        duration: millisecondsPerBeat * (1 / 4) // Grow for 1/4 of the animation
    });
    hrAnimation.add({
        scale: hrImageScaleMin,
        duration: millisecondsPerBeat * (3 / 4) // Shrink for 3/4 of the animation
    })
}

// Request the config from the server
let xmlHttp = new XMLHttpRequest();
xmlHttp.open('GET', '/config', false); // false for synchronous request
xmlHttp.send(null);
config = JSON.parse(xmlHttp.responseText);
if (typeof config.beatSound !== 'undefined') {
    beatSound = new Audio(config.beatSound);
}
connect();