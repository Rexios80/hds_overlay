import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
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
