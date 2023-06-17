import 'package:astute_components/astute_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:prod_mode/screens/debtCapture/debtDetails.dart';
import 'package:prod_mode/screens/priorityAssessment/startFundNoDebts.dart';

class DebtsLanding extends StatefulWidget {
  @override
  State<DebtsLanding> createState() => _DebtsLandingState();
}

class _DebtsLandingState extends State<DebtsLanding> {
  String? debtStatus;
  int? debtCount = 0;
  String? name;

  CollectionReference userName = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('userConfirmedDetails');

  Future<void> getName() async {
    try {
      QuerySnapshot querySnapshot = await userName.get();
      if (querySnapshot.size > 0) {
        // Assuming you want to read the value from the first document
        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

        // Access the desired field value
        dynamic fieldValue = documentSnapshot.get('userName');

        // Do something with the value
        print('Field Value: $fieldValue');
        setState(() {
          name = fieldValue;
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

    getName(); // an extraction of the user's location
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
                                  builder: (context) =>
                                      PriorityAssessment(name: name)))
                              : Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DebtDetails(
                                      debtStatus: debtStatus,
                                      debtCount: debtCount,
                                      name: name)));
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
