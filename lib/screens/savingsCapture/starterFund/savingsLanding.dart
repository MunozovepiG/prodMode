import 'package:astute_components/astute_components.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:prod_mode/screens/savingsCapture/starterFund/starterFund.dart';

class SavingsLanding extends StatefulWidget {
  @override
  State<SavingsLanding> createState() => _SavingsLandingState();
}

class _SavingsLandingState extends State<SavingsLanding> {
  String? savingStatus;
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
                      BHCTSh(
                          false,
                          'Keep',
                          'Keep your money',
                          AppTheme.colors.orange500,
                          AppTheme.colors.orange500,
                          false,
                          false,
                          false,
                          false,
                          false,
                          true,
                          false,
                          'Time to pay yourself'),

                      MS24(),

                      //description
                      BBRM14(
                          "You work hard for your money, so it's important to prioritize paying yourself first.",
                          AppTheme.colors.black,
                          6,
                          TextAlign.center),
                      SS8(),
                      BBRM14(
                          "To achieve this, it's essential to have a complementary savings plan in place.",
                          AppTheme.colors.black,
                          6,
                          TextAlign.center),

                      SS36(),
                      RadioButtons(
                        options: [
                          'No, I do not have any savings',
                          'Yes, I have savings'
                        ],
                        buttonColor: AppTheme.colors.orange500,
                        onChanged: (value) {
                          setState(() {
                            savingStatus = value;
                            print(savingStatus);
                          });
                        },
                        labelText: 'Do you have any savings?',
                        disabledIndex: 1,
                      ),

                      LS72(),

                      (savingStatus != null)
                          ? NeonActiveButton('Next', () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => StarterFundDetails()));
                            })
                          : DisabledRoundButton('Next', () {})
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
