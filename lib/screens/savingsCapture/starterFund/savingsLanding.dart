import 'package:astute_components/astute_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String? userLocation;
  double? totalIncome = 0;
  double? calculatedMonths;
  int? months = 3; // for testing purposes defaulted
  DateTime? endDate;
  double? targetAmount;
  //userLocation extraction
  CollectionReference userDetails = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('userConfirmedDetails');

  CollectionReference userIncome = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('userIncomeDetails');

// the income extraction
  Future<void> getIncomeDetails() async {
    try {
      QuerySnapshot querySnapshot = await userIncome.get();
      if (querySnapshot.size > 0) {
        // Assuming you want to read the value from the first document
        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

        // Access the desired field value
        dynamic income = documentSnapshot.get('totalIncome');

        // Do something with the value

        setState(() {
          totalIncome = income;
          if (userLocation == 'South Africa') {
            calculatedMonths = (20000 / (totalIncome! * 0.1));
            print('calculated values $calculatedMonths');
            months = calculatedMonths!.ceil();
            targetAmount = 20000;
            print('months $months');
            endDate = DateTime.now().add(Duration(days: 30 * months!));
          } else {
            calculatedMonths = (1000 / (totalIncome! * 0.1)).ceilToDouble();
            months = calculatedMonths!.ceil();
            targetAmount = 1000;
            print('calculated values $calculatedMonths');
            print('months $months');
            endDate = DateTime.now().add(Duration(days: 30 * months!));
          }
          print('total $totalIncome');
        });
      } else {
        print('No documents found in the collection');
      }
    } catch (error) {
      print('Error reading user details: $error');
    }
  }

  Future<void> getUserDetails() async {
    try {
      QuerySnapshot querySnapshot = await userDetails.get();
      if (querySnapshot.size > 0) {
        // Assuming you want to read the value from the first document
        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

        // Access the desired field value
        dynamic fieldValue = documentSnapshot.get('userLocation');

        // Do something with the value
        print('Field Value: $fieldValue');
        setState(() {
          userLocation = fieldValue;
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
    getUserDetails();
    getIncomeDetails();

// an extraction of the user's location
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * 1.0,
        height: MediaQuery.of(context).size.height * 1.0,
        color: AppTheme.colors.background,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
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
//need to calculate the potential endDate

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => StarterFundDetails(
                                          userLocation: userLocation,
                                          totalIncome: totalIncome,
                                          savingStatus: savingStatus,
                                          months: months,
                                          endDate: endDate,
                                          //targetAmount: targetAmount;
                                        )));
                              })
                            : DisabledRoundButton('Next', () {})
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
