import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Credits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credits'),
      ),
      body: Center(
        child: Card(
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            child: ListView(
              padding: EdgeInsets.all(10),
              children: [
                Row(children: [
                  Text('Some icons provided by Font Awesome.'),
                  Spacer(),
                  TextButton(
                    onPressed: () => launch('https://fontawesome.com/license'),
                    child: Text('License'),
                  ),
                ]),
                SizedBox(height: 5),
                Text('App Store® is a registered trademark of Apple Inc.'),
                SizedBox(height: 10),
                Text(
                    'Google Play and the Google Play logo are trademarks of Google LLC.'),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
