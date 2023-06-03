import 'package:astute_components/astute_components.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:prod_mode/screens/basicDetails/stepOComp.dart';
import 'package:prod_mode/services/authServices.dart';

class UserMotive extends StatefulWidget {
  String? correctName;
  String? userDoB;
  String? userLocation;

  UserMotive({this.correctName, this.userDoB, this.userLocation});

  @override
  State<UserMotive> createState() =>
      _UserMotiveState(correctName, userDoB, userLocation);
}

class _UserMotiveState extends State<UserMotive> {
  String? correctName;
  String? userDoB;
  String? userLocation;
  String imageURl = auth.currentUser!.photoURL.toString();
  String? userMotive;

  _UserMotiveState(this.correctName, this.userDoB, this.userLocation);
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
                        //the heading

                        BAHTSh(
                            imageURl,
                            true,
                            false,
                            false,
                            'How can we help best?',
                            'Always on the same page.',
                            true),

                        //the description

                        MS24(),
                        BBRM14(
                            'To ensure your success, we value understanding your ultimate financial goal, as it allows us to tailor our services to your specific needs.',
                            AppTheme.colors.black,
                            6,
                            TextAlign.center),

                        SS36(),
                        RadioButtons(
                            options: [
                              'Stop living paycheck to paycheck',
                              'Achieve financial freedom',
                              'Build generational wealth',
                              'Prepare and plan for retirement',
                              'Retire early',
                              'Improve money management skills',
                              'Improve wealth management skills.'
                            ],
                            buttonColor: AppTheme.colors.blue500,
                            onChanged: (value) {
                              setState(() {
                                userMotive = value;
                              });
                            },
                            labelText:
                                'Please select your current financial goal.'),

                        // the CTA
                        SS36(),
                        (userMotive == null)
                            ? DisabledRoundButton('Next', () {})
                            : NeonActiveButton('Next', () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => StepOComp(
                                          userDoB: userDoB,
                                          correctName: correctName,
                                          userLocation: userLocation,
                                          userMotive: userMotive,
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
