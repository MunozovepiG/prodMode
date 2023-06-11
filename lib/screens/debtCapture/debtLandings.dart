import 'package:astute_components/astute_components.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:prod_mode/screens/debtCapture/debtDetails.dart';
import 'package:prod_mode/screens/priorityAssessment/priorityAssessment.dart';

class DebtsLanding extends StatefulWidget {
  @override
  State<DebtsLanding> createState() => _DebtsLandingState();
}

class _DebtsLandingState extends State<DebtsLanding> {
  String? debtStatus;
  int? debtCount = 0;
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
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(children: [
                  BHCTSh(
                      true,
                      'Keep',
                      'Debt-free is the way to be',
                      AppTheme.colors.orange500,
                      AppTheme.colors.orange500,
                      false,
                      false,
                      false,
                      false,
                      false,
                      false,
                      true,
                      'We have done the maths'),
                  MS24(),
                  //description
                  BBRM14(
                      "Debt can arise from different circumstances, and while some types of debt may be considered 'good,' our ultimate goal is to help you become debt-free. ",
                      AppTheme.colors.black,
                      6,
                      TextAlign.center),
                  SS36(),

                  RadioButtons(
                      options: [
                        'Yes, I have some debts',
                        'No, I do not have any debts'
                      ],
                      buttonColor: AppTheme.colors.orange500,
                      onChanged: (value) {
                        setState(() {
                          debtStatus = value;
                          if (debtStatus == 'No, I do not have any debts') {
                            debtCount = 0;
                          } else {
                            debtCount = 1;
                          }
                        });
                      },
                      labelText: 'Do you have debts?',
                      disabledIndex: 3),

                  LS72(),
                  //the next button
                  (debtStatus != null)
                      ? NeonActiveButton('Next', () {
                          (debtStatus == 'No, I do not have any debts')
                              ? Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PriorityAssessment()))
                              : Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DebtDetails(
                                        debtStatus: debtStatus,
                                        debtCount: debtCount,
                                      )));
                        })
                      : DisabledRoundButton('Next', () {})
                ]),
              )
            ],
          ),
        )),
      ),
    );
  }
}
