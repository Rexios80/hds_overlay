# Health Data Server Overlay
This is a stream overlay that shows heart rate and calorie burn information sent from an Apple Watch running the [Health Data Server app](https://apps.apple.com/us/app/health-data-server/id1496042074).

![Preview Image](https://github.com/Rexios80/Health-Data-Server-Overlay/blob/4534a59d792d7f172a7e9958010fe4bc692c5ca7/PreviewImage.png)

[Twitch highlight of me using this application in practice](https://www.twitch.tv/videos/626646069)

### How to set up
1. [Download the latest release executable](https://github.com/Rexios80/Health-Data-Server-Overlay/releases)
2. Double click the downloaded file to run it
  - On linux and macOS, you will first need to run `sudo chmod 777 HDS-Overlay-macos` in a terminal
3. Open a browser and go to `localhost:8080`

You should see the images for health data in your browser, but no actual numbers yet.

### Connecting to the Apple Watch application
1. Make sure the Apple Watch and device running the overlay application are on the same network. If the watch is connected to an iPhone, you just need to make sure the iPhone is connected to the same network.
2. [Install the Health Data Server application on your Apple Watch](https://apps.apple.com/us/app/health-data-server/id1496042074)
3. Open the application
4. Type the IP address of the machine running the overlay application and the port the server is running at into the text field
   - If you need help finding the IP address of your machine, read [this](https://www.tp-link.com/us/support/faq/838/). It probably looks something like this: `192.168.xxx.xxx`
   - The default port the overlay application runs on is 8080, but this can be changed if there is a conflict
   - After your IP address make sure to put your port. An example of what should go in this text field is this: `192.168.1.105:8080`
   - There is an input method in watchOS 6 that allows you to type in text fields from your iPhone. This is by far the easiest way to input the information into the watch application.
5. Click the start button

You should soon see numbers in the webpage you opened earlier. This is the health data the watch is sending over your local network.

### Configuration
If you need to change either of the server ports or want to change the images the application uses, you will need to create a config file. Create a file named `config.json` in the same folder as the application. A basic config file looks like this:
```
{
  "httpPort": 8080,
  "websocketPort": 3476,
}
```
All the fields in the text above are required or the application will crash. To change the images the application uses, you can create a config file that looks like this:
```
{
  "httpPort": 8080,
  "websocketPort": 3476,
  "hrImageFile": "hrImage.png",
  "calImageFile": "calImage.png"
}
```
You do not need to specify both image files. This example assumes the images are in the same folder as the application.

### Styling
If you need complex styling of the overlay, you can use the Custom CSS field on an OBS browser source. Use [styles.css](public/styles.css) as a reference of what can be changed. Here is an example that disables the calories display:
```
.cal { display: none; }
```

### Notes
If you want to use this as a stream overlay, simply add the url used to see the data in a web browser as a web source in your favorite streaming application.

### If you have problems
[Try these troubleshooting steps before creating an issue](https://github.com/Rexios80/Health-Data-Server-Overlay/wiki/Troubleshooting)

### Building it yourself
Most users won't need to do this, but here is how to build the application manually.

#### Prerequisites
   - [Node.js](https://nodejs.org/)
   - [Git](https://git-scm.com/)

#### Commands
   - `npm install`
   - `./buildscript.sh`
   - The generated files will be in the `output` folder
