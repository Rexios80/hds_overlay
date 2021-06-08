import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Terms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          FutureBuilder(
            future: rootBundle.loadString('assets/strings/terms'),
            builder: (context, snap) => Text(snap.data as String),
          ),
        ],
      ),
    );
  }
}
