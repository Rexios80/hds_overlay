# Health Data Server Overlay
This is a stream overlay that shows heart rate and calorie burn information sent from an Apple Watch, Samsung watch, or Android watch running the Health Data Server app

### Links

- [iOS/Apple Watch/macOS app](https://apps.apple.com/app/apple-store/id1496042074?pt=118722341&ct=GitHub&mt=8)
  - Make sure to join the [TestFlight](https://testflight.apple.com/join/hG4FkmZ4) group or the new overlay will not work. Apple is being *very* slow at approving my updates.
- [Samsung watch app [COMING SOON]]()
  - If you would like to test the Samsung watch app, please join the [Discord server](https://discord.gg/FayYYcm) and message me (You need to have a Samsung phone too)
- [Android watch app](https://play.google.com/store/apps/details?id=dev.rexios.hds_flutter)
- [Windows app](https://www.microsoft.com/store/apps/9PHN402J6LVJ)
- [Web app](https://hds.dev/)
  - You can use this as a browser source as long as one of the desktop apps is running on the same machine

Binaries for macOS, linux, and Windows are also available on the [releases](https://github.com/Rexios80/Health-Data-Server-Overlay/releases) page.

### HDS in action

![Preview Image](https://github.com/Rexios80/Health-Data-Server-Overlay/raw/master/readme_assets/PreviewImage.png)

[Video of the overlay in action](https://www.youtube.com/watch?v=CFGlA7JWUFo)

You can track development progress [here](https://trello.com/healthdataserver)

### How to set up
1. Download the watch app and the desktop app for your platform
2. For the Windows Firewall prompt, make sure to check both the boxes and then click "Allow access"
    - ![Firewall Dialog](https://github.com/Rexios80/Health-Data-Server-Overlay/raw/master/readme_assets/firewall-dialog.png)

### Connecting to the watch application
1. Make sure the watch and device running the overlay application are on the same network. If the watch is connected to a phone, you just need to make sure the phone is connected to the same network.
2. Install the Health Data Server application on your watch
   - THE WATCHOS APP REQUIRES WATCHOS 6+. The App Store will let you purchase it even if your watch can't run watchOS 6+, so make sure before buying.
3. Open the application
4. Type the IP address of the machine running the overlay application
   - The overlay application will list possible IP addresses of your machine on startup. If none of those work, you may have to find the IP address manually.
   - If you need help finding the IP address of your machine, read [this](https://www.tp-link.com/us/support/faq/838/). It probably looks something like this: `192.168.xxx.xxx`
   - If you want to send data to an external server, you will need to input the full websocket URL ex: `ws://hostname:port/other/stuff`
5. Click the start button

You should soon see numbers in the desktop app. This is the health data the watch is sending over your local network.

### Configuration
All configuration is done in the watch app and desktop app

### Set up as stream overlay

#### Browser source
1. Add https://hds.dev as a browser source
2. Right click the source and "Interact" with it
3. Set the background color to transparent in the settings
4. Add a crop filter

#### Window capture
1. Add a window capture for the desktop app
2. Add a chroma key filter to the window capture
3. Add a crop filter to the window capture

### If you have problems
Try these [troubleshooting steps](https://github.com/Rexios80/Health-Data-Server-Overlay/wiki/Troubleshooting) before asking for help
- Ask for help in the [support Discord server](https://discord.gg/FayYYcm)
- [Create an issue](https://github.com/Rexios80/Health-Data-Server-Overlay/issues/new?assignees=&labels=&template=bug-report.md&title=)

### Please consider writing a review
Many people only leave reviews when they have a problem with an app. Even if many users don't have an issue, these negative reviews can turn off potential new users. If you enjoy this application, please consider leaving a review on the [App Store page](https://apps.apple.com/app/apple-store/id1496042074?pt=118722341&ct=GitHub&mt=8). Even a simple review helps a lot!
