import 'package:astute_components/astute_components.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:prod_mode/screens/debtCapture/debtLandings.dart';

class StarterFundInfo extends StatefulWidget {
  @override
  State<StarterFundInfo> createState() => _StarterFundInfoState();
}

class _StarterFundInfoState extends State<StarterFundInfo> {
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
                      'We have done the maths'),

                  MS24(),

                  //description
                  BBRM14(
                      "Congratulations on taking steps to secure your finances! To help you maintain control over your personal finances, we recommend focusing exclusively on building a strong foundation at this time. ",
                      AppTheme.colors.black,
                      6,
                      TextAlign.center),
                  SS8(),
                  //description
                  BBRM14(
                      "Once your foundation is established, we can collaborate to set additional savings goals that align with your long-term financial objectives.",
                      AppTheme.colors.black,
                      6,
                      TextAlign.center),

                  LS72(),
                  NeonActiveButton('Continue', () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DebtsLanding()));
                  })
                ]),
              )
            ],
          ),
        )),
      ),
    );
  }
}
