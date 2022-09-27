# Health Data Server Overlay
This is a stream overlay that shows heart rate, calorie burn, and more information sent from an Apple Watch or Android watch running the Health Data Server app

## [Setup Tutorial Video](https://youtu.be/EyYIhK3kxUA)

## Links

- [Web app](https://hds.dev/)
  - For use as a browser source
  - If you use HDS Cloud, all you will need is this and the watch app
  - Heart rate is free forever with HDS Cloud (assuming you bought the watch app)
- [Apple Watch app](https://apps.apple.com/app/apple-store/id1496042074?pt=118722341&ct=GitHub&mt=8)
  - THE APP STORE VERSION OF THE WATCHOS APP REQUIRES WATCHOS 8+. The App Store will let you purchase it even if your watch can't run watchOS 8+, so make sure before buying.
  - If your watch cannot run watchOS 8+, join this [TestFlight group](https://testflight.apple.com/join/M0tjtpcS) to get HDS Legacy
- [Android watch app](https://play.google.com/store/apps/details?id=dev.rexios.hds_flutter)
  - The Wear OS app currently works on Wear OS 2, but can only send heart rate. If Wear OS 3 ever starts behaving, I will work on an update to send calories, step count, speed, and distance. Please note that this update will ONLY support Wear OS 3.
- [Windows/macOS/linux executables](https://github.com/Rexios80/hds_desktop/releases/latest)
  - For local data routing (no cloud)

## HDS in action

![Preview Image](https://github.com/Rexios80/Health-Data-Server-Overlay/raw/master/readme_assets/preview_image.gif)

You can track development progress [here](https://trello.com/healthdataserver)

## Set up with HDS Cloud
1. Download the watch app for your device
2. Add hds.dev as a browser source in OBS
3. Input the HDS Cloud ID from the browser source into the overlay ids section on the watch
4. (optional) Hold alt (Windows) or opt (macOS) and drag the edges of the browser source to crop it
5. Click the start button on the watch
6. It should *just work*™
7. To edit the overlay configuration right click on the browser source in the sources list and click `Interact`

## Set up the old fashioned way
**Heart rate is free forever with HDS Cloud. Unless you need more data than just heart rate and don't want to pay the subscription or do not have internet access this section is not for you.**
- [See the hds_desktop repo](https://github.com/Rexios80/hds_desktop)

## Useful things
- You can import a config with a url parameter. This is useful if you want to use something like the Streamlabs mobile app in which you cannot interact with the web page.
   1. Use hds.dev to create the overlay configuration you want
   2. Click the export button in the top right to copy the configuration to your clipboard
   3. Use https://www.urlencoder.org to encode the config that you just copied
   4. Create a url that looks like this: `https://hds.dev/#/overlay?config=Encoded config`
   5. Use that url as a browser source in your app of choice

## If you have problems
Try these [troubleshooting steps](https://github.com/Rexios80/Health-Data-Server-Overlay/wiki/Troubleshooting) and if your issue is still not resolved
- Then consider posting in the [support Discord server](https://discord.gg/FayYYcm)
- If the community is not able to resolve your issue, then consider [creating an issue](https://github.com/Rexios80/Health-Data-Server-Overlay/issues/new?assignees=&labels=&template=bug-report.md&title=) on GitHub

## Please consider writing a review
Many people only leave reviews when they have a problem with an app. Even if many users don't have an issue, these negative reviews can turn off potential new users. If you enjoy this application, please consider leaving a review on the [App Store page](https://apps.apple.com/app/apple-store/id1496042074?pt=118722341&ct=GitHub&mt=8). Even a quick star-rating review helps us a lot!
