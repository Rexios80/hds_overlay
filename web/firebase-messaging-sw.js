importScripts("https://www.gstatic.com/firebasejs/8.4.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js");

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