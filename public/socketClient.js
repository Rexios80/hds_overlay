let config;
let heartbeatTimeout;

let animateHrImage;
let beatSoundThreshold;

const hrImageScaleMin = 0.85;
const hrImageScaleMax = 1;

let currentHeartRate = 0;
let currentHrColor = null;
let currentHrMin = 500;
let currentHrMax = 0;

let hrMap = new Map();
let beatSound = null;
let animatingHeartRateImage = false;
let hrAverageText = null;

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
        hrAverageText = document.getElementById('hrAverageText');

        let hrImage = document.getElementById('hrImage');
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
                animatingHeartRateImage = false;
            } else {
                heartRateText.textContent = currentHeartRate;
                updateHeartRateUI();
                hrMap.set((new Date()).getTime(), currentHeartRate);
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
            startHrImageAnimation();
        }

        await sleep(100); // Wait for hrColor to arrive (might need tweaking)

        // Maybe a race condition?
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

function startHrImageAnimation() {
    if (!animatingHeartRateImage) {
        anime({
            targets: '.hrImage',
            easing: 'easeInOutSine',
            scale: hrImageScaleMin,
        }).finished.then(() => {
            animateHeartRateImage();
        });
        animatingHeartRateImage = true;
    }
}

function animateHeartRateImage() {
    let millisecondsPerBeat = 60 / currentHeartRate * 1000;

    let hrAnimation = anime.timeline({
        targets: '.hrImage',
        easing: 'easeInOutSine'
    });
    hrAnimation.add({
        scale: hrImageScaleMax,
        duration: millisecondsPerBeat * (1 / 4), // Grow for 1/4 of the animation
        complete: function (anim) {
            if (currentHeartRate >= beatSoundThreshold) {
                beatSound.play();
            }
        }
    });
    hrAnimation.add({
        scale: hrImageScaleMin,
        duration: millisecondsPerBeat * (3 / 4) // Shrink for 3/4 of the animation
    });

    hrAnimation.finished.then(() => {
        // Keep the animation going as long as there is a heart rate
        if (animatingHeartRateImage) {
            animateHeartRateImage();
        }
    });
}

// Calc the average hr over time
// Keys are timestamps
// Values are heart rates
async function calcHrAverage() {
    if (hrMap.size === 0) {
        // There are no values yet
        return;
    }

    let hrArray = Array.from(hrMap.entries());
    let now = (new Date()).getTime();
    let sum = 0;
    for (i = 0; i < hrArray.length; i++) {
        let [key, value] = hrArray[i];
        if (i === hrArray.length - 1) {
            // This is the last entry. Use the current time for the calculation.
            let diff = now - key;
            sum += diff * value;
            break;
        }

        let [nextKey, nextValue] = hrArray[i + 1];
        let diff = nextKey - key;
        sum += diff * value;
    }

    let [firstKey, firstValue] = hrArray[0];

    let totalTime = now - firstKey;
    let hrAverage = sum / totalTime;
    hrAverageText.textContent = Math.round(hrAverage);
    console.log('hrAverage: ' + hrAverage);
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

// Calculate hr average every second
setInterval(calcHrAverage, 1000);

setTimeout(function () {
    // Wait for the Custom CSS to load. I feel like this is dumb but it works and I'm sick of dealing with it.
    let hrImage = document.getElementById('hrImage');
    animateHrImage = getComputedStyle(hrImage).getPropertyValue('--animate').trim() === 'true';
    beatSoundThreshold = Number(getComputedStyle(hrImage).getPropertyValue('--beatSoundThreshold').trim());
}, 1000);