// the starter fund details

import 'dart:async';

import 'package:astute_components/astute_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prod_mode/screens/savingsCapture/starterFund/starterFundConfirm.dart';

class StarterFundDetails extends StatefulWidget {
  String? userLocation;
  double? totalIncome;
  String? savingStatus;
  int? months;
  DateTime? endDate;

  StarterFundDetails(
      {required this.userLocation,
      this.totalIncome,
      this.savingStatus,
      this.months,
      this.endDate});

  @override
  State<StarterFundDetails> createState() => _StarterFundDetailsState(
      userLocation, totalIncome, savingStatus, months, endDate);
}

class _StarterFundDetailsState extends State<StarterFundDetails> {
  bool? userLocationUS = false;
  double? totalIncome;
  String? userLocation;
  int? months;
  DateTime? endDate;
  DateTime? startDate = DateTime.now();
  DateFormat formatter = DateFormat('E, dd, MM, yyyy');
  final DateTime currentDate = DateTime.now();
  String? formattedEnDate;
  double? calculatedMonths;
  String? startDateText = 'Recommended start date';
  String? endDateText = 'Recommended end date';
  String? savingStatus;

  _StarterFundDetailsState(this.userLocation, this.totalIncome,
      this.savingStatus, this.months, this.endDate);

  @override
  Widget build(BuildContext context) {
    String? selectedStartDate;
    bool test = false;

    String formatedCurrentDate = formatter.format(DateTime.now());
    // Duration duration = endDate.difference(currentDate);
    // String? selectedEndDate = formatter.format(endDate);

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
                          'Do not worry, we have a plan'),

                      MS24(),
                      //description
                      BBRM14(
                          "After conducting a thorough analysis of your current income, we have developed a personalized plan to help you establish a starter fund. This fund will serve as the foundation towards establishing an emergency fund.",
                          AppTheme.colors.black,
                          6,
                          TextAlign.center),
                      SS36(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SH12('Saving goal (1)', AppTheme.colors.black, 1),
                        ],
                      ),
                      SS16(),
                      CustomDropdown(
                          values: [
                            'Starter fund',
                          ],
                          preselectedValue: 'Starter fund',
                          onChanged: (value) {},
                          iconColor: AppTheme.colors.grey650,
                          borderColor: AppTheme.colors.grey400,
                          backgroundColor: AppTheme.colors.grey400,
                          disabled: true,
                          labelText: 'We have selected an category for you'),

                      MS24(),
                      Row(
                        children: [
                          ILM12('Targe amount', AppTheme.colors.grey650, 1),
                        ],
                      ),
                      SS8(),

                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppTheme.colors.grey400,
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, left: 16.0, bottom: 2.0),
                                child: ILM12(
                                  'This amount has already been calculated for you',
                                  AppTheme.colors.grey650,
                                  1,
                                ),
                              ),
                              (userLocation == 'South Africa')
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0, left: 16.0, bottom: 16.0),
                                      child: TBM14(
                                        'ZAR 20 000',
                                        AppTheme.colors.grey650,
                                        1,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0, left: 16.0, bottom: 16.0),
                                      child: TBM14(
                                        'USD 1000',
                                        AppTheme.colors.grey650,
                                        1,
                                      ),
                                    ),
                            ]),
                      ),
                      MS24(),

                      // the start date
                      Row(
                        children: [
                          //bespoke calendar given the calculations that need to be completed
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ILM12(
                                  '$startDateText', AppTheme.colors.grey650, 1),
                              IconTextButton(
                                  icon: Icons.calendar_month_outlined,
                                  color: AppTheme.colors.orange500,
                                  text: '${formatter.format(startDate!)}',
                                  textColor: AppTheme.colors.black,
                                  onPressed: () {
                                    _showDatePicker();
                                  }),
                            ],
                          ),
                        ],
                      ),
                      MS24(),
                      // the end date
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ILM12(
                                  '$endDateText ', AppTheme.colors.grey650, 1),
                              IconTextButton(
                                  icon: Icons.calendar_month_outlined,
                                  color: AppTheme.colors.orange500,
                                  text: '${formatter.format(endDate!)}',
                                  textColor: AppTheme.colors.black,
                                  onPressed: () {
                                    _endShowDatePicker();
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                //Neon active button

                SS36(),
                NeonActiveButton('Next', () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => StarterFundOverview(
                            userLocation: userLocation,
                            savingStatus: savingStatus,
                            totalIncome: totalIncome,
                            startDate: startDate,
                            endDate: endDate,
                            saveCat: 'Starter fund',
                            months: months,
                          )));
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  //the start datePicker
  Future<void> _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate: currentDate.add(Duration(days: 90)),
    );

    if (pickedDate != null) {
      setState(() {
        startDate = pickedDate;
        startDateText = 'Selected start date';
      });
    }
  }

  // the end datePicker
  Future<void> _endShowDatePicker() async {
    DateTime lastDay = currentDate.add(
      Duration(days: months! * 30),
    );

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      //this needs to be calculated
      initialDate: lastDay,
      firstDate: lastDay,
      lastDate: currentDate.add(Duration(days: 30 * 24)),
    );

    if (pickedDate != null) {
      setState(() {
        endDate = pickedDate;
        endDateText = 'Selected end date';
      });
    }
  }
}
