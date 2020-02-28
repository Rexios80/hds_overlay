# Health Data Server Overlay
This is a stream overlay that shows heart rate and calorie burn information sent from an Apple Watch running the [Health Data Server app](https://apps.apple.com/us/app/health-data-server/id1496042074).

![Preview Image](https://github.com/Rexios80/Health-Data-Server-Overlay/blob/4534a59d792d7f172a7e9958010fe4bc692c5ca7/PreviewImage.png)

[Twitch highlight of me using this application in practice](https://www.twitch.tv/videos/547255694)
### How to set up
1. [Download node.js and install](https://nodejs.org)
2. [Download the latest release zip of this repository and extract where you want it](https://github.com/Rexios80/Health-Data-Server-Overlay/releases)
3. Windows: run setup.bat, macOS: run setup.command, Linux: run setup.sh
4. Windows: run start.bat, macOS: run start.command, Linux: run start.sh
5. Open a browser and go to `localhost:8080`

You should see the images for health data in your browser, but no actual numbers yet.

### How to start normally
After you set up the overlay application, all you have to do to start the application in the future is run the start script.

### Connecting to the Apple Watch application
1. Make sure the Apple Watch and device running the overlay application are on the same network. If the watch is connected to an iPhone, you just need to make sure the iPhone is connected to the same network.
2. [Install the Health Data Server application on your Apple Watch](https://apps.apple.com/us/app/health-data-server/id1496042074)
3. Open the application
4. Type the IP address of the machine running the overlay application and the port the server is running at into the text field
   - If you need help finding the IP address of your machine, read [this](https://www.tp-link.com/us/support/faq/838/). It probably looks something like this: 192.168.xxx.xxx
   - The default port the overlay application runs on is 8080, but this can be changed in the code if there is a conflict
   - An example of what should go in this text field is this: `192.168.1.105:8080`
   - There is an input method in watchOS 6 that allows you to type in text fields from your iPhone. This is by far the easiest way to input the information into the watch application.
5. Click the start button

You should soon see numbers in the webpage you opened earlier. This is the health data the watch is sending over your local network.

### Notes
If you want to use this as a stream overlay, simply add the url used to see the data in a web browser as a web source in your favorite streaming application.

Feel free to change the code however you want. You might want to style the web page for one thing. Some simple configuration changes can be made in [styles.css](public/styles.css). You can swap out the images directly if they have the same file names as the originals. Otherwise you will need to change the names in [index.html](public/index.html).

If you need to change the server port, you can change it in [app.js](public/app.js).
