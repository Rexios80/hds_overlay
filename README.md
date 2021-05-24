# Health Data Server Overlay
This is a stream overlay that shows heart rate and calorie burn information sent from an Apple Watch, Samsung watch, or Android watch running the Health Data Server app

### Links

- [Web app (for use as a browser source)](https://hds.dev/)
  - If you have an Apple Watch and just want heart rate (more HDS Cloud data is coming soon) all you need is this and the watch app
- [Apple Watch/iOS/macOS app](https://apps.apple.com/app/apple-store/id1496042074?pt=118722341&ct=GitHub&mt=8)
  - THE WATCHOS APP REQUIRES WATCHOS 6+. The App Store will let you purchase it even if your watch can't run watchOS 6+, so make sure before buying.
- [Samsung watch app [COMING SOON]]()
- [Android watch app](https://play.google.com/store/apps/details?id=dev.rexios.hds_flutter)
- [Windows app](https://www.microsoft.com/store/apps/9PHN402J6LVJ)
- [Windows/macOS/linux executables](https://github.com/Rexios80/Health-Data-Server-Overlay/releases)

### HDS in action

![Preview Image](https://github.com/Rexios80/Health-Data-Server-Overlay/raw/master/readme_assets/preview_image.gif)

You can track development progress [here](https://trello.com/healthdataserver)

### Set up with HDS Cloud (Apple Watch and heart rate only for now)
1. [Get the TestFlight version of the watch app](https://testflight.apple.com/join/hG4FkmZ4)
 - It's not quite stable yet, but I wanted to get it out there in case it works for anyone.
2. Download the watch app for your device
3. Add hds.dev as a browser source in OBS
4. Input the HDS Cloud ID from the browser source into the HDS Cloud config on the watch
5. Right click on the browser source in the sources section and click "Interact"
6. Go into the HDS settings and make the background color transparent
7. Add a crop filter to the browser source
8. Click the start button on the watch
9. It should *just work*

### Set up the old fashioned way
1. Download the watch app and the desktop app for your platform
2. For the Windows Firewall prompt, make sure to check both the boxes and then click "Allow access"
    - ![Firewall Dialog](https://github.com/Rexios80/Health-Data-Server-Overlay/raw/master/readme_assets/firewall-dialog.png)
3. Add hds.dev as a browser source in OBS
4. Right click on the browser source in the sources section and click "Interact"
5. Go into the settings and make the background color transparent and disable HDS Cloud
6. Make sure the watch and device running the overlay application are on the same network. If the watch is connected to a phone, you just need to make sure the phone is connected to the same network.
7. Disable HDS Cloud in the settings on the watch
8. Type the IP address of the machine running the overlay application
   - The overlay application will list possible IP addresses of your machine on startup. If none of those work, you may have to find the IP address manually.
   - If you need help finding the IP address of your machine, read [this](https://www.tp-link.com/us/support/faq/838/). It probably looks something like this: `192.168.xxx.xxx`
   - If you want to send data to an external server, you will need to input the full websocket URL ex: `ws://hostname:port/other/stuff`
9. Click the start button on the watch

### If you have problems
Try these [troubleshooting steps](https://github.com/Rexios80/Health-Data-Server-Overlay/wiki/Troubleshooting) before asking for help
- Ask for help in the [support Discord server](https://discord.gg/FayYYcm)
- [Create an issue](https://github.com/Rexios80/Health-Data-Server-Overlay/issues/new?assignees=&labels=&template=bug-report.md&title=)

### Please consider writing a review
Many people only leave reviews when they have a problem with an app. Even if many users don't have an issue, these negative reviews can turn off potential new users. If you enjoy this application, please consider leaving a review on the [App Store page](https://apps.apple.com/app/apple-store/id1496042074?pt=118722341&ct=GitHub&mt=8). Even a simple review helps a lot!
