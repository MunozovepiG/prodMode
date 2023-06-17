import 'package:astute_components/astute_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:prod_mode/internalComponents.dart';
import 'package:prod_mode/services/authServices.dart';

class PlanSFNoDebts extends StatefulWidget {
  @override
  State<PlanSFNoDebts> createState() => _PlanSFNoDebtsState();
}

class _PlanSFNoDebtsState extends State<PlanSFNoDebts> {
  String imageURl = auth.currentUser!.photoURL.toString();
  String? endDate;
  String? startDate;
  Duration? duration;
  double? targetAmount;
  int? months;

  //userLocation extraction
  CollectionReference starterFundDetails = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('userSaveDetails');

  // the income extraction
  Future<void> getStarterFundDetails() async {
    try {
      QuerySnapshot querySnapshot = await starterFundDetails.get();
      if (querySnapshot.size > 0) {
        // Assuming you want to read the value from the first document
        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

        // Access the desired field value
        dynamic extractedEndDate = documentSnapshot.get('formattedEndDate');
        dynamic extractedStartDate = documentSnapshot.get('formattedStartDate');
        dynamic extractedTargetAmount = documentSnapshot.get('targetAmount');
        dynamic extractedMonths = documentSnapshot.get('months');
        // Do something with the value

        setState(() {
          endDate = extractedEndDate;

          startDate = extractedStartDate;
          targetAmount = extractedTargetAmount;
          months = extractedMonths;

          //  print(endDate);
          //print(startDate);
          print(targetAmount);
          print(extractedStartDate);
        });
      } else {
        print('No documents found in the collection');
      }
    } catch (error) {
      print('Error reading user details: $error');
    }
  }

  @override
  void initState() {
    super.initState();

    getStarterFundDetails();
// an extraction of the user's location
  }

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
                  BAHTSh(imageURl, false, false, true, 'Here is your focus',
                      'Perfectly according to plan', true),

                  MS24(),
                  //description
                  BBRM14(
                      "Right now, your primary focus should be on your savings plan. We've provided a clear plan of action to help you build your emergency fund with ease.",
                      AppTheme.colors.black,
                      6,
                      TextAlign.center),

                  MS24(),

                  //divider

                  Divider(
                    color: AppTheme.colors.blue500,
                    height: 20,
                    thickness: 1,
                  ),

                  MS24(),

                  //the heading
                  BBLM14(
                    'Focus: Building Starter savings fund',
                    AppTheme.colors.blue500,
                    1,
                  ),

                  MS24(),
                  TwoColumnLabel('Target amount', '${targetAmount}'),
                  SS16(),
                  TwoColumnLabel('end date', '${endDate}'),
                  SS16(),
                  TwoColumnLabel('start date', '${startDate}'),

                  MS32(),
                  BBBS12('${months} months', AppTheme.colors.green800, 1,
                      TextAlign.center),
                  SS8(),
                  NeonActiveButton('Continue', () {})
                ]),
              )
            ],
          ),
        )),
      ),
    );
  }
}
