import 'package:astute_components/astute_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:prod_mode/screens/savingsCapture/starterFund/starterFund.dart';
import 'package:prod_mode/screens/savingsCapture/starterFund/starterFundInfo.dart';

class StarterFundConfirm extends StatefulWidget {
  String? userLocation;
  String? savingStatus;
  double? totalIncome;
  DateTime? startDate;
  DateTime? endDate;
  String? saveCat;
  int? months;
  String? status;

  StarterFundConfirm(
      {this.userLocation,
      this.savingStatus,
      this.totalIncome,
      this.startDate,
      this.endDate,
      this.saveCat,
      this.months,
      this.status});

  @override
  State<StarterFundConfirm> createState() => _StarterFundConfirmState(
      userLocation,
      savingStatus,
      totalIncome,
      startDate,
      endDate,
      saveCat,
      months,
      status);
}

class _StarterFundConfirmState extends State<StarterFundConfirm> {
  DateFormat formatter = DateFormat('E, dd, MM, yyyy');
  String? userLocation;
  String? savingStatus;
  double? totalIncome;
  DateTime? startDate;
  DateTime? endDate;
  String? saveCat;
  String? currency;
  double? installment;
  int? months;
  double? formattedMonths;
  double? targetAmount;
  String? status;
  double? amountSaved = 0;

  _StarterFundConfirmState(
      this.userLocation,
      this.savingStatus,
      this.totalIncome,
      this.startDate,
      this.endDate,
      this.saveCat,
      this.months,
      this.status);

  //the currency identification

  @override
  void initState() {
    formattedMonths = months!.toDouble();
    print(formattedMonths);
  }

  Widget build(BuildContext context) {
    if (userLocation == 'South Africa') {
      currency = 'ZAR';
      installment = (20000 / formattedMonths!);
      targetAmount = 20000.00;
    } else {
      currency = 'USD';
      installment = (20000 / formattedMonths!);
      targetAmount = 1000.00;
    }

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
                      'Save first, spend after'),
                  MS24(),

                  //description
                  BBRM14(
                      "After conducting a thorough analysis of your current income, we have developed a personalized plan to help you establish a starter fund. This fund will serve as the foundation towards establishing an emergency fund.",
                      AppTheme.colors.black,
                      6,
                      TextAlign.center),

                  SS36(),
                  Divider(
                    color: AppTheme.colors.orange500,
                    height: 20,
                    thickness: 1,
                  ),

                  MS24(),

                  // this needs to be dynamic in the future as now it is fixed:
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 17.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BBRS12('Category: $saveCat',
                                AppTheme.colors.orange500, 1, TextAlign.start),

                            SS16(),
                            // TwoItemLabel

                            TwoItemLabel(
                                'Monthly contributions:',
                                AppTheme.colors.grey650,
                                '$currency $installment'),

                            SS16(),

                            TwoItemLabel('Target amount:',
                                AppTheme.colors.grey650, '$targetAmount'),

                            SS16(),

                            TwoItemLabel('End date:', AppTheme.colors.grey650,
                                '${formatter.format(endDate!)}'),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // the next button

                  LS56(),

                  NeonActiveButton('Save', () {
                    addSaveDetails();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => StarterFundInfo()));
                  }),
                  SS8(),
                  BasicPlainTextButton(
                      color: AppTheme.colors.green800,
                      text: 'Edit',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      textColor: AppTheme.colors.green800)
                ]),
              )
            ],
          ),
        )),
      ),
    );
  }

  void addSaveDetails() {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('userSaveDetails');
    DateFormat formatter = DateFormat('E, dd, MM, yyyy');

    var data = {
      'startDate': startDate,
      'endDate': endDate,
      'saveCat': saveCat,
      'months': months,
      'savingStatus': savingStatus,
      'targetAmount': targetAmount,
      'formattedEndDate': formatter.format(endDate!),
      'formattedStartDate': formatter.format(startDate!),
      'contributions': installment,
      'status': status,
      'amountSaved': amountSaved,

      // this system to be developed 'goalStatus': ,
    };

    ref.add(data);
  }
}
