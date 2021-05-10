importScripts("https://www.gstatic.com/firebasejs/8.5.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.5.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyArjmNbUe6cnx9vJ5W65DIduUVoXMQpzNA",
  authDomain: "hds.dev",
  projectId: "health-data-server",
  storageBucket: "health-data-server.appspot.com",
  messagingSenderId: "47929674141",
  appId: "1:47929674141:web:eb5d3073bfeb038f860774",
  measurementId: "G-2YR45DMN6B",
});

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