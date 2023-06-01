import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:prod_mode/services/authServices.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        TextButton(
            onPressed: () {
              signInWithGoogle(context);
            },
            child: Text('CONTINE')),
        Text('Hello')
      ]),
    );
  }
}
