import 'package:astute_components/astute_components.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

class SavingsLanding extends StatefulWidget {
  const SavingsLanding({super.key});

  @override
  State<SavingsLanding> createState() => _SavingsLandingState();
}

class _SavingsLandingState extends State<SavingsLanding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * 1.0,
        height: MediaQuery.of(context).size.height * 1.0,
        color: AppTheme.colors.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: []),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
