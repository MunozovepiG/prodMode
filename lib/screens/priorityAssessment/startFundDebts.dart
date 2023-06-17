import 'package:astute_components/astute_components.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:prod_mode/services/authServices.dart';

class PriorityAsEFDebts extends StatefulWidget {
  double? totalIncome;
  double? totalDebtInstallment;
  String? name;

  PriorityAsEFDebts({this.totalIncome, this.totalDebtInstallment, this.name});

  @override
  State<PriorityAsEFDebts> createState() =>
      _PriorityAsEFDebtsState(totalIncome, totalDebtInstallment, name);
}

class _PriorityAsEFDebtsState extends State<PriorityAsEFDebts> {
  String imageURl = auth.currentUser!.photoURL.toString();
  double? totalIncome;
  double? totalDebtInstallment;
  String? name;

  _PriorityAsEFDebtsState(
      this.totalIncome, this.totalDebtInstallment, this.name);

  @override
  Widget build(BuildContext context) {
    double? debtPercentage = (totalDebtInstallment! / totalIncome!) * 100;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * 1.0,
        height: MediaQuery.of(context).size.height * 1.0,
        color: AppTheme.colors.background,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(children: [
                  BAHTSh(imageURl, false, false, true, 'Here is your focus',
                      'Focus on your priority', true),

                  MS24(),

                  //the description

                  (debtPercentage > 40 || debtPercentage == 40)
                      ? Column(
                          children: [
                            //the over indebted
                            //description
                            BBRM14(
                                "Hi ${name}, We've completed an assessment of your finances and found that your current debts are putting a significant strain on your earnings. ",
                                AppTheme.colors.black,
                                6,
                                TextAlign.center),

                            SS16(),

                            BBRM14(
                                "Before proceeding with building your starter fund, we recommend focusing on alleviating the burden of your debts. We have developed a plan that can help.  ",
                                AppTheme.colors.black,
                                6,
                                TextAlign.center),
                            LS72(),
                            NeonActiveButton('Continue', () {})
                          ],
                        )
                      : Column(
                          children: [
                            //in the case they are no over indebted

                            BBRM14(
                                "Hi ${name}, we have done an assessment of your finances based on the information provided. Based on our analysis it is best that you focus on building your emergency fund.  ",
                                AppTheme.colors.black,
                                6,
                                TextAlign.center),

                            SS16(),

                            BBRM14(
                                "As a result, we will not be fast-tracking the repayment of your debts.",
                                AppTheme.colors.black,
                                6,
                                TextAlign.center),
                            LS72(),
                            NeonActiveButton('Continue', () {})
                          ],
                        )
                ]),
              )
            ],
          ),
        )),
      ),
    );
  }
}
