import 'dart:html';

import 'package:astute_components/astute_components.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

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
      this.months});

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
      months);
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
  );

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
                          TwoItemLabel('Monthly contributions:',
                              AppTheme.colors.grey650, '$debtDescription'),

                          SS16(),
                          // TwoItemLabel - installment
                          TwoItemLabel(
                              (biWeekly!)
                                  ? 'Bi-weekly installments:'
                                  : 'Monthly installments',
                              AppTheme.colors.grey650,
                              '$installment'),

                          SS16(),
                          // TwoItemLabel - amount owed
                          TwoItemLabel('Amount owed:', AppTheme.colors.grey650,
                              '$debtAmount'),
                        ],
                      ),
                    ],
                  )
                ]),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
