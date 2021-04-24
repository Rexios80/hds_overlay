import 'package:flutter/material.dart';

class LogView extends StatelessWidget {
  final String log;

  const LogView({Key? key, required this.log}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.black),
      child: SingleChildScrollView(
        child: Text(
          log,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
