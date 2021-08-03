# Health Data Server Overlay
This is a stream overlay that shows heart rate and calorie burn information sent from an Apple Watch, Samsung watch, or Android watch running the Health Data Server app

### [Setup Tutorial Video](https://youtu.be/EyYIhK3kxUA)

### Links

- [Web app (for use as a browser source)](https://hds.dev/)
  - If you have an Apple Watch all you need is this and the watch app
- [Apple Watch/iOS/macOS app](https://apps.apple.com/app/apple-store/id1496042074?pt=118722341&ct=GitHub&mt=8)
  - THE WATCHOS APP REQUIRES WATCHOS 6+. The App Store will let you purchase it even if your watch can't run watchOS 6+, so make sure before buying.
- [Android watch app](https://play.google.com/store/apps/details?id=dev.rexios.hds_flutter)
- [Windows app](https://www.microsoft.com/store/apps/9PHN402J6LVJ)
- [Windows/macOS/linux executables](https://github.com/Rexios80/Health-Data-Server-Overlay/releases)

### HDS in action

![Preview Image](https://github.com/Rexios80/Health-Data-Server-Overlay/raw/master/readme_assets/preview_image.gif)

You can track development progress [here](https://trello.com/healthdataserver)

### Set up with HDS Cloud (Apple Watch only for now)
1. Download the watch app for your device
2. Add hds.dev as a browser source in OBS
3. Input the HDS Cloud ID from the browser source into the overlay ids section on the watch
4. (optional) Hold alt (Windows) or opt (macOS) and drag the edges of the browser source to crop it
5. Click the start button on the watch
6. It should *just work*™
7. To edit the overlay configuration right click on the browser source in the sources list and click `Interact`

### Set up the old fashioned way
1. Download the watch app and the desktop app for your platform
2. For the Windows Firewall prompt, make sure to check both the boxes and then click "Allow access"
    - ![Firewall Dialog](https://github.com/Rexios80/Health-Data-Server-Overlay/raw/master/readme_assets/firewall-dialog.png)
3. Add hds.dev as a browser source in OBS
4. Right click on the browser source in the sources section and click "Interact"
5. Go into the settings and disable HDS Cloud
6. Hold alt (Windows) or opt (macOS) and drag the edges of the browser source to crop it
7. Make sure the watch and device running the overlay application are on the same network. If the watch is connected to a phone, you just need to make sure the phone is connected to the same network.
8. Disable HDS Cloud in the settings on the watch
9. Type the IP address of the machine running the overlay application
   - The overlay application will list possible IP addresses of your machine on startup. If none of those work, you may have to find the IP address manually.
   - If you need help finding the IP address of your machine, read [this](https://www.tp-link.com/us/support/faq/838/). It probably looks something like this: `192.168.xxx.xxx`
   - If you want to send data to an external server, you will need to input the full websocket URL ex: `ws://hostname:port/other/stuff`
10. Click the start button on the watch

### Useful things
- You can import a config with a url parameter. This is useful if you want to use something like the Streamlabs mobile app in which you cannot interact with the web page.
   1. Use hds.dev to create the overlay configuration you want
   2. Click the export button in the top right to copy the configuration to your clipboard
   3. Use https://www.urlencoder.org to encode the config that you just copied
   4. Create a url that looks like this: `https://hds.dev/#/overlay?config=Encoded config`
   5. Use that url as a browser source in your app of choice

### If you have problems
Try these [troubleshooting steps](https://github.com/Rexios80/Health-Data-Server-Overlay/wiki/Troubleshooting) before asking for help
- Ask for help in the [support Discord server](https://discord.gg/FayYYcm)
- [Create an issue](https://github.com/Rexios80/Health-Data-Server-Overlay/issues/new?assignees=&labels=&template=bug-report.md&title=)

### Please consider writing a review
Many people only leave reviews when they have a problem with an app. Even if many users don't have an issue, these negative reviews can turn off potential new users. If you enjoy this application, please consider leaving a review on the [App Store page](https://apps.apple.com/app/apple-store/id1496042074?pt=118722341&ct=GitHub&mt=8). Even a simple review helps a lot!
