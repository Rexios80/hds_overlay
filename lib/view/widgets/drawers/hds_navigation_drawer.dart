import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:git_info/git_info.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:hds_overlay/view/routes.dart';

class HdsNavigationDrawer extends StatelessWidget {
  static const _githubUrl = 'https://git.io/J3NOR';
  static const _discordUrl = 'https://discord.gg/FayYYcm';
  static const _iosUrl =
      'https://apps.apple.com/app/apple-store/id1496042074?pt=118722341&ct=hds.dev&mt=8';
  static const _androidUrl =
      'https://play.google.com/store/apps/details?id=dev.rexios.hds_flutter';

  const HdsNavigationDrawer({super.key});

  // final _samsungUrl ='https://git.io/J3NOR';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/icon.png'),
              ),
              color: Colors.grey,
            ),
            child: SizedBox.shrink(),
          ),
          offRouteItem(
            const Text('Overlay'),
            Routes.overlay,
          ),
          offRouteItem(
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
          const Divider(),
          toRouteItem(
            const Text('Privacy Policy'),
            Routes.privacyPolicy,
          ),
          toRouteItem(
            const Text('Terms of Use'),
            Routes.terms,
          ),
          toRouteItem(
            const Text('Credits'),
            Routes.credits,
          ),
          toRouteItem(
            const Text('Licenses'),
            Routes.licenses,
          ),
          FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (context, packageInfoSnap) => FutureBuilder(
              future: GitInfo.get(),
              builder: (context, gitInfoSnap) {
                final version = packageInfoSnap.data?.version;
                final gitInfo = gitInfoSnap.data;
                if (version == null || gitInfo == null) {
                  return const SizedBox.shrink();
                }
                final hash = gitInfo.hash ?? gitInfo.branch;
                return ListTile(
                  title: Text('Version $version'),
                  subtitle: Text(hash),
                  onTap: () =>
                      Clipboard.setData(ClipboardData(text: '$version $hash')),
                );
              },
            ),
          ),
          ListTile(title: Text('Renderer: $renderer')),
        ],
      ),
    );
  }

  Widget urlItem(Widget label, String imageAsset, String url) {
    return ListTile(
      title: label,
      trailing: Image.asset(imageAsset, height: 30),
      onTap: () => launchUrlString(url),
    );
  }

  Widget offRouteItem(Widget label, String route) {
    return ListTile(
      title: label,
      onTap: () {
        if (Get.currentRoute != route) {
          Get.offNamed(route);
        } else {
          Get.back();
        }
      },
    );
  }

  Widget toRouteItem(Widget label, String route) {
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

  String get renderer {
    if (const bool.fromEnvironment('FLUTTER_WEB_USE_SKIA')) {
      return 'Skia';
    } else if (const bool.fromEnvironment('FLUTTER_WEB_USE_SKWASM')) {
      return 'WASM';
    } else {
      return 'HTML';
    }
  }
}
