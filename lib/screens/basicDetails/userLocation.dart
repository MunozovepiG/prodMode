import 'package:astute_components/astute_components.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:prod_mode/screens/basicDetails/userMotive.dart';
import 'package:prod_mode/services/authServices.dart';

class LocationConfirmation extends StatefulWidget {
  String? correctName;
  String? userDoB;

  LocationConfirmation(
    this.correctName,
    this.userDoB,
  );

  @override
  State<LocationConfirmation> createState() =>
      _LocationConfirmationState(correctName, userDoB);
}

class _LocationConfirmationState extends State<LocationConfirmation> {
  String? correctName;
  String? userDoB;
  String imageURl = auth.currentUser!.photoURL.toString();
  String? userLocation;

  _LocationConfirmationState(
    this.correctName,
    this.userDoB,
  );

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
                            'Where are you at?',
                            'Let’s leverage your location.',
                            true),

                        MS24(),

                        //description
                        BBRM14(
                            'We want to help you take advantage of all the financial opportunities available in your country to achieve your financial goals.',
                            AppTheme.colors.black,
                            6,
                            TextAlign.center),

                        SS36(),
                        //conditional statement : when none of the above

                        if (userLocation == "None of the above")
                          Column(
                            children: [
                              BR10(
                                  '🌍 Do not worry, we are expanding and will soon be available in your country!',
                                  AppTheme.colors.black,
                                  6,
                                  TextAlign.left),
                              SS8(),
                            ],
                          ),

                        // the dropdown

                        MyDropdown(
                          labelText: 'Please select your location:',
                          iconColor: AppTheme.colors.blue500,
                          borderColor: AppTheme.colors.blue500,
                          values: [
                            'Please select an option',
                            'United States of America',
                            'South Africa',
                            'None of the above'
                          ],
                          preselectedValue: 'Please select an option',
                          onChanged: (value) {
                            print('Selected value: $value');
                            setState(() {
                              userLocation = value;
                            });
                          },
                        ),
                        //

                        // the CTA
                        LS72(),
                        (userLocation == 'Please select an option' ||
                                userLocation == null)
                            ? DisabledRoundButton('Next', () {})
                            : NeonActiveButton('Next', () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => UserMotive(
                                          correctName: correctName,
                                          userDoB: userDoB,
                                          userLocation: userLocation,
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
