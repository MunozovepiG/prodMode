import 'package:astute_components/astute_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class StarterFundOverview extends StatefulWidget {
  String? userLocation;
  String? savingStatus;
  double? totalIncome;

  @override
  State<StarterFundOverview> createState() => _StarterFundOverviewState();
}

class _StarterFundOverviewState extends State<StarterFundOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * 1.0,
        height: MediaQuery.of(context).size.height * 1.0,
        color: AppTheme.colors.background,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [CBButton()],
          ),
        )),
      ),
    );
  }
}
