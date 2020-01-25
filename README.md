# Health-Data-Server-Overlay
This is a stream overlay that shows heart rate and calorie burn information sent from an Apple Watch running the Health Data Server app.

![Preview Image](https://github.com/Rexios80/Health-Data-Server-Overlay/blob/develop/PreviewImage.png)
### How to set up
1. [Download node.js and install](https://nodejs.org)
2. [Download the latest release zip of this repository and extract where you want it](https://github.com/Rexios80/Health-Data-Server-Overlay/releases)
3. Open a terminal and move into the forlder of this repository
4. Run `npm install`
5. Run `node .\public\app.js` (use forward slashes if on macOS or Linux)
6. Open a browser and go to `localhost:8080`

You should see the labels for health data in your browser, but no actual numbers yet.

### How to start normally
After you set up the overlay application, all you have to do to start the application in the future is open a terminal, move into the repository's folder, and run `node .\public\app.js`.

### Connecting to the Apple Watch application
1. Make sure the Apple Watch and device running the overlay application are on the same network. If the watch is connected to an iPhone, you just need to make sure the iPhone is connected to the same network.
2. [Install the Health Data Server application on your Apple Watch](https://apps.apple.com/us/app/health-data-server/id1496042074)
3. Open the application
4. Type the IP address of the machine running the overlay application and the port the server is running at into the text field
   - The IP address of the machine running the overlay application can be found by opening a terminal and running ipconfig (or ifconfig on macOS and Linux)
   - The default port the overlay application runs on is 8080, but this can be changed in the code if there is a conflict
   - An example of what should go in this text field is this: `192.168.1.105:8080`
   - There is an input method in watchOS 6 that allows you to type in text fields from your iPhone. This is by far the easiest way to input the information into the watch application.
5. Click the start button

You should soon see numbers in the webpage you opened earlier. This is the health data the watch is sending over your local network.

### Notes
If you want to use this as a stream overlay, simply add the url used to see the data in a web browser as a web source in your favorite streaming application.

Feel free to change the code however you want. You might want to style the web page for one thing.
