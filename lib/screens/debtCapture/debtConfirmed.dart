import 'package:astute_components/astute_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:prod_mode/screens/debtCapture/debtOverview.dart';

class DebtDetailsConfirmation extends StatefulWidget {
  String? debtStatus;
  int? debtCount;
  String? debtCat;
  String? debtDescription;
  double? debtAmount;
  bool? biWeekly;
  String? firstPaymentText;
  String? secondPaymentText;
  String? endDateText;
  DateTime? firstPaymentDate;
  DateTime? secondPaymentDate;
  DateTime? endDate;
  double? installment;
  double? months;
  Duration? duration;

  DebtDetailsConfirmation(
      {this.debtStatus, //this is deduced by the number of debts saved
      this.debtCount,
      this.debtCat,
      this.debtDescription,
      this.debtAmount,
      this.biWeekly,
      this.firstPaymentText,
      this.secondPaymentText,
      this.endDateText,
      this.firstPaymentDate,
      this.secondPaymentDate,
      this.endDate,
      this.installment,
      this.months,
      this.duration});

  @override
  State<DebtDetailsConfirmation> createState() => _DebtDetailsConfirmationState(
      debtStatus,
      debtCount,
      debtCat,
      debtDescription,
      debtAmount,
      biWeekly,
      firstPaymentText,
      secondPaymentText,
      endDateText,
      firstPaymentDate,
      secondPaymentDate,
      endDate,
      installment,
      months,
      duration);
}

class _DebtDetailsConfirmationState extends State<DebtDetailsConfirmation> {
  String? debtStatus;
  int? debtCount;
  String? debtCat;
  String? debtDescription;
  double? debtAmount;
  bool? biWeekly;
  String? firstPaymentText;
  String? secondPaymentText;
  String? endDateText;
  DateTime? firstPaymentDate;
  DateTime? secondPaymentDate;
  DateTime? endDate;
  double? installment;

  double? months;

  Duration? duration;
  _DebtDetailsConfirmationState(
      this.debtStatus,
      this.debtCount,
      this.debtCat,
      this.debtDescription,
      this.debtAmount,
      this.biWeekly,
      this.firstPaymentText,
      this.secondPaymentText,
      this.endDateText,
      this.firstPaymentDate,
      this.secondPaymentDate,
      this.endDate,
      this.installment,
      this.months,
      this.duration);

  @override
  Widget build(BuildContext context) {
    String? formattedInstallment = installment!.toStringAsPrecision(5);
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
                  //header

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
                      'Consider it done '),

                  MS24(),

                  //description
                  BBRM14(
                      "Please confirm the details of your debt first. Once we have reviewed your finances, we will inform you which loans you may be able to pay off earlier than scheduled. Once we identify the loan, we will create an action plan to pay it off as soon as possible",
                      AppTheme.colors.black,
                      6,
                      TextAlign.center),

                  MS24(),
                  Divider(
                    color: AppTheme.colors.orange500,
                    height: 20,
                    thickness: 1,
                  ),
                  MS24(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BBRS12('Category: $debtCat',
                              AppTheme.colors.orange500, 1, TextAlign.start),
                          SS16(),
                          // TwoItemLabel - description
                          (debtDescription != null)
                              ? TwoItemLabel('Monthly contributions:',
                                  AppTheme.colors.grey650, '$debtDescription')
                              : TwoItemLabel(
                                  'Monthly contributions:',
                                  AppTheme.colors.grey650,
                                  'No description provided'),

                          SS16(),
                          // TwoItemLabel - installment
                          TwoItemLabel(
                              (biWeekly!)
                                  ? 'Bi-weekly installments:'
                                  : 'Monthly installments',
                              AppTheme.colors.grey650,
                              '$formattedInstallment'),

                          SS16(),
                          // TwoItemLabel - amount owed
                          TwoItemLabel('Amount owed:', AppTheme.colors.grey650,
                              '$debtAmount'),
                          SS16(),
                          // the end date
                          TwoItemLabel('End date:', AppTheme.colors.grey650,
                              '$endDateText'),
                        ],
                      ),
                    ],
                  ),

                  // the buttons
                  MS24(),
                  NeonActiveButton('Save', () {
                    addDebtDetails(formattedInstallment);
                    // Navigation to the overview

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DebtOverview()));
                  }),
                  BasicPlainTextButton(
                      color: AppTheme.colors.green800,
                      text: 'Edit',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      textColor: AppTheme.colors.green800)
                ]),
              ),
            ],
          ),
        )),
      ),
    );
  }

  void addDebtDetails(formattedInstallment) {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('userDebtDetails');

    var data = {
      'debtCat': debtCat,
      'debtAmount': debtAmount,
      'installment': installment,
      'formattedInstallment': formattedInstallment,
      'endDate': endDate,
      'endDate Text': endDateText,
      'biWeekly staus': biWeekly,
      'first PaymentDate': firstPaymentDate,
      'first PaymentText': firstPaymentText,
      'secondPaymentDate': secondPaymentDate,
      'secondPaymentText': secondPaymentText,
      'duration': duration,
      'debtDescription': debtDescription,
      'debtCount': debtCount
    };

    ref.add(data);
  }
}
