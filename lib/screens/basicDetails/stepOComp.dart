import 'package:astute_components/astute_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:prod_mode/services/authServices.dart';

class StepOComp extends StatefulWidget {
  String? correctName;
  String? userDoB;
  String? userLocation;
  String? userMotive;

  StepOComp(
      {this.correctName, this.userDoB, this.userLocation, this.userMotive});

  @override
  State<StepOComp> createState() =>
      _StepOCompState(correctName, userDoB, userLocation, userMotive);
}

class _StepOCompState extends State<StepOComp> {
  String? correctName;
  String? userDoB;
  String? userLocation;
  String? userMotive;
  String imageURl = auth.currentUser!.photoURL.toString();

  _StepOCompState(
      this.correctName, this.userDoB, this.userLocation, this.userMotive);

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
                      //the heading

                      BAHTSh(imageURl, true, false, false, 'It is simple',
                          'On to the next step', true),

                      MS24(),
                      //the description
                      BBRM14(
                          'In a few simple steps we will have all information needed to transform start working towards your financial goals.',
                          AppTheme.colors.black,
                          6,
                          TextAlign.center),

                      SS8(),

                      //the description
                      BBRM14(
                          'Although you can make changes in the future if needed, please provide the most precise and up-to-date data possible.',
                          AppTheme.colors.black,
                          6,
                          TextAlign.center),

                      LS72(),

                      NeonActiveButton('Continue', () {
//save onto the firebase database
                        addConfirmedProfile();
                        // navigation to next screen
                      })
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

//the function saving the values to firebaseDB

  void addConfirmedProfile() {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('userConfirmedDetails');

    var data = {
      'userName': correctName,
      'userDoB': userDoB,
      'userLocation': userLocation,
      'userMotive': userMotive,
    };

    ref.add(data);
  }
}
