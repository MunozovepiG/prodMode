import 'package:astute_components/astute_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:prod_mode/screens/incomeCapture/incomeFour.dart';
import 'package:prod_mode/screens/incomeCapture/incomeFreq.dart';
import 'package:intl/intl.dart';
import 'package:prod_mode/screens/incomeCapture/incomeOverview.dart';
import 'package:prod_mode/screens/incomeCapture/incomeThree.dart';
import 'package:prod_mode/screens/savingsCapture/starterFund/savingsLanding.dart';

class IncomeOverview extends StatefulWidget {
  double? userIncomeOne;
  String? incomeFrequency;

  double? userIncomeTwo;
  double? userIncomeThree;
  double? userIncomeFour;
  String? formattedFrequencyOne;
  DateTime? selectedDateOne;
  String? formattedFrequencyTwo;
  DateTime? selectedDateTwo;
  String? formattedFrequencyThree;
  DateTime? selectedDateThree;
  String? formattedFrequencyFour;
  DateTime? selectedDateFour;

  IncomeOverview({
    this.userIncomeOne,
    this.incomeFrequency,
    this.userIncomeTwo,
    this.userIncomeThree,
    this.userIncomeFour,
    this.formattedFrequencyOne,
    this.selectedDateOne,
    this.formattedFrequencyTwo,
    this.selectedDateTwo,
    this.formattedFrequencyThree,
    this.selectedDateThree,
    this.formattedFrequencyFour,
    this.selectedDateFour,
  });

  @override
  State<IncomeOverview> createState() => _IncomeOverviewState(
        userIncomeOne,
        incomeFrequency,
        userIncomeTwo,
        userIncomeThree,
        userIncomeFour,
        formattedFrequencyOne,
        selectedDateOne,
        formattedFrequencyTwo,
        selectedDateTwo,
        formattedFrequencyThree,
        selectedDateThree,
        formattedFrequencyFour,
        selectedDateFour,
      );
}

class _IncomeOverviewState extends State<IncomeOverview> {
  double? userIncomeOne;
  String? incomeFrequency;
  double? userIncomeTwo;
  double? userIncomeThree;
  double? userIncomeFour;
  bool? dateSelected = false;
  String? formattedFrequencyOne;
  DateTime? selectedDateOne;
  String? formattedFrequencyTwo;
  DateTime? selectedDateTwo;
  String? formattedFrequencyThree;
  DateTime? selectedDateThree;
  String? formattedFrequencyFour;
  DateTime? selectedDateFour;

  _IncomeOverviewState(
      this.userIncomeOne,
      this.incomeFrequency,
      this.userIncomeTwo,
      this.userIncomeThree,
      this.userIncomeFour,
      this.formattedFrequencyOne,
      this.selectedDateOne,
      this.formattedFrequencyTwo,
      this.selectedDateTwo,
      this.formattedFrequencyThree,
      this.selectedDateThree,
      this.formattedFrequencyFour,
      this.selectedDateFour);

  String? incomeInput;
  TextEditingController _incomeController = TextEditingController();
  DateFormat format = DateFormat('E, MMM dd, yyyy');
  String? formattedDate;
  DateTime? selectedDate;
  double? totalIncome;

  @override
  Widget build(BuildContext context) {
    if (incomeFrequency == "Weekly") {
      totalIncome = (userIncomeOne ?? 0) +
          (userIncomeTwo ?? 0) +
          (userIncomeThree ?? 0) +
          (userIncomeFour ?? 0);
    } else if (incomeFrequency == "Bi-weekly") {
      totalIncome = (userIncomeOne ?? 0) + (userIncomeTwo ?? 0);
    } else if (incomeFrequency == "Monthly") {
      totalIncome = userIncomeOne;
    }
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
                        BHCTSh(
                            true,
                            'Make',
                            'Make more money',
                            AppTheme.colors.lavender750,
                            AppTheme.colors.lavender750,
                            false,
                            false,
                            false,
                            true,
                            false,
                            false,
                            false,
                            'Here is your total income'),
                        MS24(),
                        MS24(),
// monthly
                        if (incomeFrequency == "Weekly")
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //income 1
                                  BBRS12("Weekly income (1)",
                                      AppTheme.colors.black, 1, TextAlign.left),

                                  BBLM14('$userIncomeOne',
                                      AppTheme.colors.black, 1)
                                ],
                              ),
                              SS16(),
                              //income 2
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //income 1
                                  BBRS12("Weekly income (2)",
                                      AppTheme.colors.black, 1, TextAlign.left),

                                  BBLM14('$userIncomeTwo',
                                      AppTheme.colors.black, 1)
                                ],
                              ),

                              SS16(),
                              //income 3
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //income 1
                                  BBRS12("Weekly income (3)",
                                      AppTheme.colors.black, 1, TextAlign.left),

                                  BBLM14('$userIncomeThree',
                                      AppTheme.colors.black, 1)
                                ],
                              ),
                              //income 4

                              SS16(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //income 1
                                  BBRS12("Weekly income (4)",
                                      AppTheme.colors.black, 1, TextAlign.left),

                                  BBLM14('$userIncomeFour',
                                      AppTheme.colors.black, 1)
                                ],
                              ),

                              SS16(),

                              Divider(
                                color: AppTheme.colors.lavender750,
                                thickness: 1.0,
                              ),
                              SS16(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //income 1
                                  BBRS12("Total income:", AppTheme.colors.black,
                                      1, TextAlign.left),

                                  BBLM14(
                                      '$totalIncome', AppTheme.colors.black, 1)
                                ],
                              ),

                              LS72(),

                              NeonActiveButton("Save", () {
                                // saving to firebase collection
                              }),
                              SS8(),
                              BasicPlainTextButton(
                                  color: AppTheme.colors.green800,
                                  text: "Edit",
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                IncomeFrequency()));
                                  },
                                  textColor: AppTheme.colors.green800)
                            ],
                          ),
//the bi-weekly option
                        if (incomeFrequency == "Bi-weekly")
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //income 1
                                  BBRS12("Bi-weekly income (1)",
                                      AppTheme.colors.black, 1, TextAlign.left),

                                  BBLM14('$userIncomeOne',
                                      AppTheme.colors.black, 1)
                                ],
                              ),
                              SS16(),
                              //income 2
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //income 1
                                  BBRS12("Bi-weekly income (2)",
                                      AppTheme.colors.black, 1, TextAlign.left),

                                  BBLM14('$userIncomeTwo',
                                      AppTheme.colors.black, 1)
                                ],
                              ),
                              SS16(),

                              Divider(
                                color: AppTheme.colors.lavender750,
                                thickness: 1.0,
                              ),
                              SS16(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //income 1
                                  BBRS12("Total income:", AppTheme.colors.black,
                                      1, TextAlign.left),

                                  BBLM14(
                                      '$totalIncome', AppTheme.colors.black, 1)
                                ],
                              ),

                              LS72(),

                              NeonActiveButton("Save", () {
                                // saving to firebase collection
                              }),
                              SS8(),
                              BasicPlainTextButton(
                                  color: AppTheme.colors.green800,
                                  text: "Edit",
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                IncomeFrequency()));
                                  },
                                  textColor: AppTheme.colors.green800)
                            ],
                          ),
//the monthly option
                        if (incomeFrequency == "Monthly")
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //income 1
                                  BBRS12("Monthly income (1)",
                                      AppTheme.colors.black, 1, TextAlign.left),

                                  BBLM14('$userIncomeOne',
                                      AppTheme.colors.black, 1)
                                ],
                              ),
                              SS16(),
                              Divider(
                                color: AppTheme.colors.lavender750,
                                thickness: 1.0,
                              ),
                              SS16(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //income 1
                                  BBRS12("Total income:", AppTheme.colors.black,
                                      1, TextAlign.left),

                                  BBLM14(
                                      '$totalIncome', AppTheme.colors.black, 1)
                                ],
                              ),
                              LS72(),
                              NeonActiveButton("Save", () {
                                // saving to firebase collection
                                addIncomeDetails();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SavingsLanding()));
                              }),
                              SS8(),
                              BasicPlainTextButton(
                                  color: AppTheme.colors.green800,
                                  text: "Edit",
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                IncomeFrequency()));
                                  },
                                  textColor: AppTheme.colors.green800)
                            ],
                          ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //the function saving the values to firebaseDB

  void addIncomeDetails() {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('userIncomeDetails');

    var data = {
      'incomeFrequency': incomeFrequency,
      'userIncomeOne': userIncomeOne,
      'formattedFrequencyOne': formattedFrequencyOne,
      'selectedDateOne': selectedDateOne,
      'userIncomeTwo': userIncomeTwo,
      'formattedFrequencyTwo': formattedFrequencyTwo,
      'selectedDateTwo': selectedDateTwo,
      'userIncomeThree': userIncomeThree,
      'formattedFrequencyThree': formattedFrequencyThree,
      'selectedDateThree': selectedDateThree,
      'userIncomeFour': userIncomeFour,
      'formattedFrequencyFour': formattedFrequencyFour,
      'selectedDateFour': selectedDateFour,
    };

    ref.add(data);
  }
}
