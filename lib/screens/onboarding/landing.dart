import 'package:astute_components/astute_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prod_mode/screens/onboarding/legalText.dart';
import 'package:prod_mode/services/authServices.dart';

class LandingScreen extends StatefulWidget {
  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final Color whiteTransparent = Color.fromRGBO(255, 255, 255, 0.35);

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * 1.0,
        height: MediaQuery.of(context).size.height * 1.0,
        color: AppTheme.colors.background,
        child: SafeArea(
          child: loading
              ? // the loading screen

              Column(
                  children: [
                    StandardTopSpace(),
                    Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // Set the shape to a circle
                          color: AppTheme.colors
                              .grey400, // Set the desired background color of the circle
                        )),

                    SS16(),

                    Container(
                      width: 185,
                      height: 29,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            20), // Set the desired corner radius
                        color: AppTheme.colors
                            .grey400, // Set the desired background color of the container
                      ),
                    ),

                    SS16(),

                    Container(
                      width: 271,
                      height: 29,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            20), // Set the desired corner radius
                        color: AppTheme.colors
                            .grey400, // Set the desired background color of the container
                      ),
                    ),

                    SS16(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 91,
                          height: 29,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                20), // Set the desired corner radius
                            color: AppTheme.colors
                                .grey400, // Set the desired background color of the container
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Container(
                          width: 91,
                          height: 29,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                20), // Set the desired corner radius
                            color: AppTheme.colors
                                .grey400, // Set the desired background color of the container
                          ),
                        ),
                      ],
                    )
                    //
                  ],
                )
              :

              //the home screen
              Column(children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.28,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.20,
                    child: Column(
                      children: [
                        BTL60('astute', AppTheme.colors.blue500, 1),
                        SS8(),
                        BTM16('make, keep and grow your money',
                            AppTheme.colors.blue500, 1),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.40,
                    width: MediaQuery.of(context).size.width * 1.0,
                    color: whiteTransparent,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //top content
                          Container(
                            child: Column(children: [
                              SS16(),
                              BR10(
                                  'Upon continuing you agree to our terms and conditions.',
                                  AppTheme.colors.black,
                                  1),
                              SS8(),
                              InkWell(
                                child: PLS10('View our terms and conditions.',
                                    AppTheme.colors.black, 1),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return LargeAlertBox(
                                            title: 'Terms and Conditions',
                                            message1: legalText,
                                            message2: 'message2',
                                            positiveText: '',
                                            negativeText: 'Close',
                                            negativeAction: () {
                                              Navigator.pop(context);
                                            },
                                            positiveAction: () {});
                                      });
                                },
                              ),
                              SS16(),

                              //Continue button
                              InkWell(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.78,
                                  height: 50,
                                  color: Colors.white,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        //icon and text
                                        Container(
                                          width: 21.59,
                                          height: 21.59,
                                          child: Image(
                                              image: AssetImage(
                                                  'assets/google-icon.png')),
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),

                                        Text(
                                          'Continue with Google',
                                          style: GoogleFonts.roboto(
                                              fontSize: 16.79,
                                              color: AppTheme.colors.blue500,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ]),
                                ),
                                onTap: () {
                                  signInWithGoogle(context);
                                  setState(() {
                                    loading = true;
                                  });
                                },
                              ),
                            ]),
                          ),

                          //the footer
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 35,
                              color: Colors.white,
                              child: Center(
                                  child: BB10(
                                      'Made with ❤️ by  kukuracapital.com',
                                      AppTheme.colors.blue500,
                                      1)),
                            ),
                          )
                        ]),
                  ),
                ]),
        ),
      ),
    );
  }
}
