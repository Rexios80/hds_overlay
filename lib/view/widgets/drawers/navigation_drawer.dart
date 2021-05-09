import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaml/yaml.dart';

import '../../routes.dart';

class NavigationDrawer extends StatelessWidget {
  final _githubUrl = 'https://git.io/J3NOR';
  final _iosUrl =
      'https://apps.apple.com/app/apple-store/id1496042074?pt=118722341&ct=hds.dev&mt=8';
  final _androidUrl =
      'https://play.google.com/store/apps/details?id=dev.rexios.hds_flutter';

  // final _samsungUrl ='https://git.io/J3NOR';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          FutureBuilder(
            future: rootBundle.loadString("pubspec.yaml"),
            builder: (context, snapshot) {
              String version = "Unknown";
              if (snapshot.hasData) {
                var yaml = loadYaml(snapshot.data as String);
                version = yaml["version"];
              }

              return DrawerHeader(
                child: Text(
                  'HDS $version',
                  style: TextStyle(color: Colors.white),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/icon.png')),
                  color: Colors.grey,
                ),
              );
            },
          ),
          ListTile(
            title: Text('Overlay'),
            onTap: () {
              if (Get.currentRoute != Routes.overlay) {
                Get.toNamed(Routes.overlay);
              } else {
                Get.back();
              }
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              if (Get.currentRoute != Routes.settings) {
                Get.toNamed(Routes.settings);
              } else {
                Get.back();
              }
            },
          ),
          Divider(),
          ListTile(
            title: Row(
              children: [
                Text('Setup instructions'),
                Spacer(),
                Container(
                  height: 30,
                  child: Image.asset(Get.isDarkMode
                      ? 'assets/images/githubDark.png'
                      : 'assets/images/githubLight.png'),
                ),
              ],
            ),
            onTap: () => launch(_githubUrl),
          ),
          ListTile(
            title: Row(
              children: [
                Text('Apple Watch app'),
                Spacer(),
                Container(
                  height: 30,
                  child: Image.asset('assets/images/appStore.png'),
                ),
              ],
            ),
            onTap: () => launch(_iosUrl),
          ),
          ListTile(
            title: Row(
              children: [
                Text('Android watch app'),
                Spacer(),
                Container(
                  height: 30,
                  child: Image.asset('assets/images/googlePlay.png'),
                ),
              ],
            ),
            onTap: () => launch(_androidUrl),
          ),
          ListTile(
            title: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Samsung watch app'),
                    Text('Coming soon', style: Theme.of(context).textTheme.caption,),
                  ],
                ),
                Spacer(),
                Container(
                  height: 30,
                  child: Image.asset('assets/images/galaxyStore.png'),
                ),
              ],
            ),
            onTap: () {
              // launch(_samsungUrl);
            },
          ),
        ],
      ),
    );
  }
}
