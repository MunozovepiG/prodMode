// the starter fund details

import 'package:astute_components/astute_components.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

class StarterFundDetails extends StatefulWidget {
  const StarterFundDetails({super.key});

  @override
  State<StarterFundDetails> createState() => _StarterFundDetailsState();
}

class _StarterFundDetailsState extends State<StarterFundDetails> {
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
                    children: [CBButton(), Text('the starter FUND')]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
