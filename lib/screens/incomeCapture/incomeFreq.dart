import 'package:astute_components/astute_components.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:prod_mode/screens/incomeCapture/incomeOne.dart';

class IncomeFrequency extends StatefulWidget {
  @override
  State<IncomeFrequency> createState() => _IncomeFrequencyState();
}

class _IncomeFrequencyState extends State<IncomeFrequency> {
  String? incomeFrequency;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * 1.0,
        height: MediaQuery.of(context).size.height * 1.0,
        color: AppTheme.colors.background,
        child: SingleChildScrollView(
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
                        //heading
                        BHCTSh(
                            false,
                            'Make',
                            'Make more money',
                            AppTheme.colors.lavender750,
                            AppTheme.colors.lavender750,
                            false,
                            false,
                            false,
                            true,
                            false,
                            false,
                            false,
                            'Let’s account for each penny'),
                        MS24(),

                        //description
                        BBRM14(
                            'We want to help you allocate your money wisely by focusing on three key financial behaviors: saving, managing debt, and investing.',
                            AppTheme.colors.black,
                            6,
                            TextAlign.center),
                        SS8(), //description
                        BBRM14(
                            'To get started, we need to understand your current income.',
                            AppTheme.colors.black,
                            6,
                            TextAlign.center),
                        SS36(),

                        //the dropdown
                        MyDropdown(
                            values: [
                              'Please select an option',
                              'Monthly',
                              'Bi-weekly',
                              'Weekly'
                            ],
                            preselectedValue: 'Please select an option',
                            onChanged: (value) {
                              setState(() {
                                incomeFrequency = value;
                              });
                            },
                            iconColor: AppTheme.colors.lavender750,
                            borderColor: AppTheme.colors.lavender750,
                            labelText:
                                'How often do you receive and income in a month?'),

                        LS72(),

                        //the CTAs

                        (incomeFrequency == null ||
                                incomeFrequency == 'Please select an option')
                            ? DisabledRoundButton('Next', () {})
                            : NeonActiveButton("Next", () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => IncomeOne(
                                          incomeFrequency: incomeFrequency,
                                        )));
                              })
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
