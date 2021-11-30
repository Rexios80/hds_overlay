import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Credits extends StatelessWidget {
  const Credits({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credits'),
      ),
      body: Center(
        child: Card(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                Row(
                  children: [
                    const Text('Some icons provided by Font Awesome.'),
                    const Spacer(),
                    TextButton(
                      onPressed: () =>
                          launch('https://fontawesome.com/license'),
                      child: const Text('License'),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  'App Store® is a registered trademark of Apple Inc.',
                ),
                const SizedBox(height: 10),
                const Text(
                  'Google Play and the Google Play logo are trademarks of Google LLC.',
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
