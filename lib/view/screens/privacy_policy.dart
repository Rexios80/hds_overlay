import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: Center(
        child: Container(
          width: 500,
          height: 300,
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: FutureBuilder(
                future: rootBundle.loadString('assets/strings/privacy_policy'),
                builder: (context, snap) => Text(snap.data as String),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
