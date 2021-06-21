import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaml/yaml.dart';

import '../../routes.dart';

class NavigationDrawer extends StatelessWidget {
  final _githubUrl = 'https://git.io/J3NOR';
  final _discordUrl = 'https://discord.gg/FayYYcm';
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
                  version,
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
          routeItem(
            Text(kIsWeb ? 'Overlay' : 'Console'),
            Routes.overlay,
          ),
          routeItem(
            Text('Settings'),
            Routes.settings,
          ),
          Divider(),
          urlItem(
            Text('Setup instructions'),
            Get.isDarkMode
                ? 'assets/images/githubDark.png'
                : 'assets/images/githubLight.png',
            _githubUrl,
          ),
          urlItem(
            Text('Discord server'),
            'assets/images/discord.png',
            _discordUrl,
          ),
          Visibility(
            visible: kIsWeb,
            child: Column(
              children: [
                urlItem(
                  Text('Apple Watch app'),
                  'assets/images/appStore.png',
                  _iosUrl,
                ),
                urlItem(
                  Text('Android watch app'),
                  'assets/images/googlePlay.png',
                  _androidUrl,
                ),
                urlItem(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Samsung watch app'),
                        Text(
                          'Coming soon',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    'assets/images/galaxyStore.png',
                    ''),
              ],
            ),
          ),
          Divider(),
          routeItem(
            Text('Privacy Policy'),
            Routes.privacyPolicy,
          ),
          routeItem(
            Text('Terms of Use'),
            Routes.terms,
          ),
          routeItem(
            Text('Credits'),
            Routes.credits,
          ),
          routeItem(
            Text('Licenses'),
            Routes.licenses,
          ),
        ],
      ),
    );
  }

  Widget urlItem(Widget label, String imageAsset, String url) {
    return ListTile(
      title: Row(
        children: [
          label,
          Spacer(),
          Container(
            height: 30,
            child: Image.asset(imageAsset),
          ),
        ],
      ),
      onTap: () => launch(url),
    );
  }

  Widget routeItem(Widget label, String route) {
    return ListTile(
      title: label,
      onTap: () {
        if (Get.currentRoute != route) {
          Get.toNamed(route);
        } else {
          Get.back();
        }
      },
    );
  }
}
