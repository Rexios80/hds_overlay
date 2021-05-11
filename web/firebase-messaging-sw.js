importScripts("/__/firebase/8.5.0/firebase-app.js");
importScripts("/__/firebase/8.5.0/firebase-messaging.js");
importScripts("/__/firebase/init.js");

const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
    return promiseChain;
});