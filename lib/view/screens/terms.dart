import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Terms extends StatelessWidget {
  const Terms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Use'),
      ),
      body: Center(
        child: Card(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                FutureBuilder(
                  future: rootBundle.loadString('assets/strings/terms'),
                  builder: (context, snap) => Text(snap.data as String),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
