import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaml/yaml.dart';

import 'package:hds_overlay/view/routes.dart';

class NavigationDrawer extends StatelessWidget {
  static const _githubUrl = 'https://git.io/J3NOR';
  static const _discordUrl = 'https://discord.gg/FayYYcm';
  static const _iosUrl =
      'https://apps.apple.com/app/apple-store/id1496042074?pt=118722341&ct=hds.dev&mt=8';
  static const _androidUrl =
      'https://play.google.com/store/apps/details?id=dev.rexios.hds_flutter';

  const NavigationDrawer({Key? key}) : super(key: key);

  // final _samsungUrl ='https://git.io/J3NOR';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          FutureBuilder(
            future: rootBundle.loadString('pubspec.yaml'),
            builder: (context, snapshot) {
              String version = 'Unknown';
              if (snapshot.hasData) {
                var yaml = loadYaml(snapshot.data as String);
                version = yaml['version'];
              }

              return DrawerHeader(
                child: Text(
                  version,
                  style: const TextStyle(color: Colors.white),
                ),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/icon.png'),
                  ),
                  color: Colors.grey,
                ),
              );
            },
          ),
          routeItem(
            const Text(kIsWeb ? 'Overlay' : 'Console'),
            Routes.overlay,
          ),
          routeItem(
            const Text('Settings'),
            Routes.settings,
          ),
          const Divider(),
          urlItem(
            const Text('Setup instructions'),
            Get.isDarkMode
                ? 'assets/images/githubDark.png'
                : 'assets/images/githubLight.png',
            _githubUrl,
          ),
          urlItem(
            const Text('Discord server'),
            'assets/images/discord.png',
            _discordUrl,
          ),
          Visibility(
            visible: kIsWeb,
            child: Column(
              children: [
                urlItem(
                  const Text('Apple Watch app'),
                  'assets/images/appStore.png',
                  _iosUrl,
                ),
                urlItem(
                  const Text('Android watch app'),
                  'assets/images/googlePlay.png',
                  _androidUrl,
                ),
              ],
            ),
          ),
          const Divider(),
          routeItem(
            const Text('Privacy Policy'),
            Routes.privacyPolicy,
          ),
          routeItem(
            const Text('Terms of Use'),
            Routes.terms,
          ),
          routeItem(
            const Text('Credits'),
            Routes.credits,
          ),
          routeItem(
            const Text('Licenses'),
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
          const Spacer(),
          SizedBox(
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
