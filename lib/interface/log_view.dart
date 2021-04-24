import 'package:flutter/material.dart';

class LogView extends StatelessWidget {
  final String log;

  const LogView({Key? key, required this.log}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black),
      child: Text(
        log,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
