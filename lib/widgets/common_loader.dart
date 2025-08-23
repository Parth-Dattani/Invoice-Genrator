import 'package:flutter/material.dart';

class CommonLoader extends StatelessWidget {
  const CommonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: Colors.blueAccent,
      color: Colors.red,
      strokeWidth: 3.5,
    );
  }
}
