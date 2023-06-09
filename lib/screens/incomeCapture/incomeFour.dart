import 'package:astute_components/astute_components.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

class IncomeFour extends StatefulWidget {
  double? userIncomeOne;
  double? userIncomeTwo;
  double? userIncomeThree;
  double? income4;
  String? incomeFrequency;

  IncomeFour(
      {this.userIncomeOne,
      this.userIncomeTwo,
      this.userIncomeThree,
      this.income4,
      this.incomeFrequency});

  @override
  State<IncomeFour> createState() => _IncomeFourState(
      userIncomeOne, userIncomeTwo, userIncomeThree, income4, incomeFrequency);
}

class _IncomeFourState extends State<IncomeFour> {
  double? userIncomeOne;
  double? userIncomeTwo;
  double? userIncomeThree;
  double? income4;
  String? incomeFrequency;

  _IncomeFourState(this.userIncomeOne, this.userIncomeTwo, this.userIncomeThree,
      this.income4, this.incomeFrequency);
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
                    children: [Text('Income four')]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
