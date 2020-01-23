# Health-Data-Server-Overlay
### How to set up
1. [Download node.js and install](https://nodejs.org)
2. [Download the latest release zip of this repository and extract where you want it](https://github.com/Rexios80/Health-Data-Server-Overlay/releases)
3. Open a terminal and move into the forlder of this repository
4. Run `npm install`
5. Run `node .\public\app.js` (use forward slashes if on macOS or Linux)
6. Open a browser and go to `localhost:8080`

You should see the labels for health data in your browser, but no actual numbers yet.

### Connecting to the Apple Watch application
1. Install the Health Data Server application on your Apple Watch
2. Open the application
3. Type the IP address of the machine running the overlay application and the port the server is running at into the text field
   - The IP address of the machine running the overlay application can be found by opening a terminal and running ipconfig (or ifconfig on macOS and Linux)
   - The default port the overlay application runs on is 8080, but this can be changed in the code if there is a conflict
   - An example of what should go in this text field is this: `192.168.1.105:8080`
4. Click the start button

You should soon see numbers in the webpage you opened earlier. This is the health data the watch is sending over your local network.

### Notes
If you want to use this as a stream overlay, simply add the url used to see the data in a web browser as a web source in your favorite streaming application.
Feel free to change the code however you want. You might want to style the web page for one thing.
