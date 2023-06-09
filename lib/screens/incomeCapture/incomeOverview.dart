import 'package:astute_components/astute_components.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:prod_mode/services/authServices.dart';

class IncomeOverview extends StatefulWidget {
  double? userIncomeOne;
  double? userIncomeTwo;
  double? userIncomeThree;
  double? userIncomeFour;
  String? incomeFrequency;

  IncomeOverview(
      {this.userIncomeOne,
      this.userIncomeTwo,
      this.userIncomeThree,
      this.userIncomeFour,
      this.incomeFrequency});

  @override
  State<IncomeOverview> createState() => _IncomeOverviewState(userIncomeOne,
      userIncomeTwo, userIncomeThree, userIncomeFour, incomeFrequency);
}

class _IncomeOverviewState extends State<IncomeOverview> {
  double? userIncomeOne;
  double? userIncomeTwo;
  double? userIncomeThree;
  double? userIncomeFour;
  String? incomeFrequency;

  _IncomeOverviewState(this.userIncomeOne, this.userIncomeTwo,
      this.userIncomeThree, this.userIncomeFour, this.incomeFrequency);

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
                    children: [
                      CBButton(),
                      Text('the overview total income'),
                      Text('${incomeFrequency}'),
                      Text('${userIncomeOne}'),
                      Text('${userIncomeTwo}'),
                      Text('${userIncomeThree}'),
                      Text('${userIncomeFour}')
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
