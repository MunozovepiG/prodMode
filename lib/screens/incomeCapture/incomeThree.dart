import 'package:astute_components/astute_components.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

class IncomeThree extends StatefulWidget {
  double? userIncomeOne;
  double? userIncomeTwo;
  String? incomeFrequency;
  double? income3;
  double? income4;

  IncomeThree(
      {this.userIncomeOne,
      this.userIncomeTwo,
      this.incomeFrequency,
      this.income3,
      this.income4});

  @override
  State<IncomeThree> createState() => _IncomeThreeState(
      userIncomeOne, userIncomeTwo, incomeFrequency, income3, income4);
}

class _IncomeThreeState extends State<IncomeThree> {
  double? userIncomeOne;
  double? userIncomeTwo;
  String? incomeFrequency;
  double? income3;
  double? income4;
  _IncomeThreeState(this.userIncomeOne, this.userIncomeTwo,
      this.incomeFrequency, this.income3, this.income4);

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
                    children: [Text('Income three')]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
