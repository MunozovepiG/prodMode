import 'package:astute_components/astute_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:prod_mode/internalComponents.dart';
import 'package:prod_mode/screens/debtCapture/debtDetails.dart';
import 'package:prod_mode/screens/debtCapture/test.dart';
import 'dart:math';

import 'package:prod_mode/screens/priorityAssessment/planSF.dart';
import 'package:prod_mode/screens/priorityAssessment/startFundDebts.dart';

class DebtOverview extends StatefulWidget {
  String? name;

  String? example;
  DebtOverview({this.name, this.example});
  @override
  State<DebtOverview> createState() => _DebtOverviewState(name, example);
}

class _DebtOverviewState extends State<DebtOverview> {
  // pulling from the debt database
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('userDebtDetails');

  // extraction of total income -> needed to understand the debt percentage
  CollectionReference userIncome = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('userIncomeDetails');

  double? totalDebtInstallment;
  String? formattedTotalDebts;
  double? totalIncome;
  String? example;

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
          print('total $totalIncome');
        });
      } else {
        print('No documents found in the collection');
      }
    } catch (error) {
      print('Error reading user details: $error');
    }
  }

  //call the data  @override
  void initState() {
    super.initState();
    getIncomeDetails();
  }

  //the varriables for the totals

  double? totalCreditCards = 0;
  String? totalCreditCardtext = '';
  double? totalStudentLoans = 0;
  String? totalStudentLoantext = '';
  double? totalPersonalLoans = 0;
  String? totalPersonalLoanstext = '';
  double? totalcreditFacility = 0;
  String? totalcreditFacilitytext = '';
  double? totalCarLoans = 0;
  String? totalCarloanstext = '';
  double? totalOther = 0;
  String? totalOthertext = '';
  double? totalMortgage = 0;
  String? totalMortgagetext = '';

  String? name;
  _DebtOverviewState(this.name, this.example);

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
                  //calculation of the categories

                  Container(
                    child: FutureBuilder<QuerySnapshot>(
                      future: ref.get(),
                      builder: ((context, snapshot) {
                        final List debts = [];
                        snapshot.data?.docs.map((DocumentSnapshot document) {
                          Map a = document.data() as Map<dynamic, dynamic>;
                          debts.add(a);
                          a['id'] = document.id;
                        }).toList();

                        //the calculations

                        List<double> debtTotal = [];
                        List<double> creditCardTotal = [];
                        List<double> personalLoanTotal = [];
                        List<double> studentLoanTotal = [];
                        List<double> mortgageTotal = [];
                        List<double> carLoanTotal = [];
                        List<double> creditFacilityTotal = [];
                        List<double> otherTotal = [];

                        if (debts.isNotEmpty) {
                          //print(incomeValues);
                          for (int i = 0; i < debts.length; i++) {
                            debtTotal.add(debts[i]['installment']);

                            totalDebtInstallment = debtTotal.sum;
                            formattedTotalDebts =
                                (totalDebtInstallment!).toStringAsFixed(2);

                            if (debts[i]['debtCat'] == 'Credit card') {
                              creditCardTotal.add(debts[i]['installment']);
                            }
                            if (debts[i]['debtCat'] == 'Personal loan') {
                              personalLoanTotal.add(debts[i]['installment']);
                            }
                            if (debts[i]['debtCat'] ==
                                'Student / Education loan') {
                              studentLoanTotal.add(debts[i]['installment']);
                            }

                            if (debts[i]['debtCat'] ==
                                'Mortgage / House loan') {
                              mortgageTotal.add(debts[i]['installment']);
                            }

                            if (debts[i]['debtCat'] == 'Car loan') {
                              carLoanTotal.add(debts[i]['installment']);
                            }
                            if (debts[i]['debtCat'] == 'Credit facility') {
                              creditFacilityTotal.add(debts[i]['installment']);
                            }

                            if (debts[i]['debtCat'] == 'Other') {
                              otherTotal.add(debts[i]['installment']);
                            }
                          }

                          //the total amounts:
//credit cards
                          if (creditCardTotal.isNotEmpty) {
                            totalCreditCards = creditCardTotal.sum;
                            totalCreditCardtext =
                                totalCreditCards!.toStringAsFixed(2);
                          } else {
                            totalCreditCards = 0;
                            totalCreditCardtext =
                                totalCreditCards!.toStringAsFixed(2);
                          }

                          //student loans

                          if (studentLoanTotal.isNotEmpty) {
                            totalStudentLoans = studentLoanTotal.sum;
                            totalStudentLoantext =
                                totalStudentLoans!.toStringAsFixed(2);
                          } else {
                            totalStudentLoans = 0;
                            totalStudentLoantext =
                                totalStudentLoans!.toStringAsFixed(2);
                          }

                          // personal loans

                          if (personalLoanTotal.isNotEmpty) {
                            totalPersonalLoans = personalLoanTotal.sum;
                            totalPersonalLoanstext =
                                totalPersonalLoans!.toStringAsFixed(2);
                          } else {
                            totalPersonalLoans = 0;
                            totalPersonalLoanstext =
                                totalPersonalLoans!.toStringAsFixed(2);
                          }

                          // credit facility

                          if (creditFacilityTotal.isNotEmpty) {
                            totalcreditFacility = creditFacilityTotal.sum;
                            totalcreditFacilitytext =
                                totalcreditFacility!.toStringAsFixed(2);
                          } else {
                            totalcreditFacility = 0;
                            totalcreditFacilitytext =
                                totalcreditFacility!.toStringAsFixed(2);
                          }

                          // car loans
                          if (carLoanTotal.isNotEmpty) {
                            totalCarLoans = carLoanTotal.sum;
                            totalCarloanstext =
                                totalCarLoans!.toStringAsFixed(2);
                          } else {
                            totalCarLoans = 0;
                            totalCarloanstext =
                                totalCarLoans!.toStringAsFixed(2);
                          }

                          //total other
                          if (otherTotal.isNotEmpty) {
                            totalOther = carLoanTotal.sum;
                            totalOthertext = totalOther!.toStringAsFixed(2);
                          } else {
                            totalOther = 0;
                            totalOthertext = totalOther!.toStringAsFixed(2);
                          }

                          //mortgate
                          if (mortgageTotal.isNotEmpty) {
                            totalMortgage = mortgageTotal.sum;
                            totalMortgagetext =
                                totalMortgage!.toStringAsFixed(2);
                          } else {
                            totalMortgage = 0;
                            totalMortgagetext = totalOther!.toStringAsFixed(2);
                          }
                        } else {}

                        return Column(
                          children: [
                            //the header

                            BHCTSh(
                                false,
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
                                'We will be keeping track'),

                            // description

                            MS24(),

                            BBRM14(
                                "We'll monitor your debts and send you notifications when your upcoming payments are due.",
                                AppTheme.colors.black,
                                6,
                                TextAlign.center),

                            SS16(),

                            //Totol monthly installment
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BBLM14('Total monthly debt repayments',
                                    AppTheme.colors.black, 1),
                                BBLM14('$formattedTotalDebts',
                                    AppTheme.colors.black, 1),
                              ],
                            ),
                            SS16(),
                            Row(
                              children: [
                                BBRS12(
                                    'Here is a breakdown of you monthly debt payments:',
                                    AppTheme.colors.black,
                                    1,
                                    TextAlign.left),
                              ],
                            ),
                            SS16(),
//

                            RowLabel('Total credit card debt',
                                '$totalCreditCardtext'),

                            SS8(),
                            RowLabel('Total student loan debt',
                                '$totalStudentLoantext'),
                            SS8(),

                            RowLabel('Total credit facility debt',
                                '$totalcreditFacilitytext'),
                            SS8(),
                            RowLabel('Total personal loan debt',
                                '$totalPersonalLoanstext'),

                            SS8(),
                            RowLabel('Total mortgage  house loans',
                                '$totalMortgagetext'),

                            SS8(),
                            RowLabel(
                                'Total car loan debt', '$totalCarloanstext'),

                            SS8(),
                            RowLabel(
                                'Total other loans debt', '$totalOthertext'),

                            MS24(),

                            Divider(
                              color: AppTheme.colors.grey800,
                              height: 20,
                              thickness: 1,
                            ),

                            //SS8(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SmallView(Icons.add, 'add new', () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DebtDetails(
                                            name: name,
                                          )));
                                }),
                              ],
                            ),

                            // the cards
                            Container(
                              child: FutureBuilder<QuerySnapshot>(
                                  future: ref.get(),
                                  builder: (context, snapshot) {
                                    final List debtDetails = [];
                                    snapshot.data?.docs
                                        .map((DocumentSnapshot document) {
                                      Map a = document.data()
                                          as Map<dynamic, dynamic>;
                                      debtDetails.add(a);
                                      a['id'] = document.id;
                                    }).toList();

                                    return Column(children: [
                                      Container(
                                        height: 400,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: snapshot.data?.docs.length,
                                          itemBuilder: (((context, index) {
                                            Map? data = snapshot
                                                .data?.docs[index]
                                                .data() as Map?;

                                            String? formattedInstallment =
                                                data?['installment']
                                                    .toStringAsFixed(2);
                                            int? monthsRounded =
                                                data?['months'].ceil();

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 24.0),
                                              child: Container(
                                                height: 175,
                                                decoration: BoxDecoration(
                                                    color: Color(0xffbFF9958),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 16.0,
                                                          bottom: 16,
                                                          left: 18,
                                                          right: 18),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          BBRM14(
                                                              '${formattedInstallment} total monthly installment',
                                                              Colors.white,
                                                              1,
                                                              TextAlign.left),

                                                          //the delete button
                                                          IconButton(
                                                              onPressed:
                                                                  () async {
                                                                await snapshot
                                                                    .data
                                                                    ?.docs[
                                                                        index]
                                                                    .reference
                                                                    .delete();

                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                DebtOverview()))
                                                                    .then((value) =>
                                                                        setState(
                                                                          () {},
                                                                        ));
                                                              },
                                                              icon: Icon(
                                                                Icons
                                                                    .delete_outline,
                                                                color: Colors
                                                                    .white,
                                                                size: 18,
                                                              )),
                                                        ],
                                                      ),

                                                      //debtCat
                                                      BBLM14(
                                                          '${data?['debtCat']}',
                                                          Colors.white,
                                                          1),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      //debt description
                                                      BBRM14(
                                                          '${data?['debtDescription']}',
                                                          Colors.white,
                                                          1,
                                                          TextAlign.left),
                                                      SS8(),

                                                      //the outsatanding amount and the months
                                                      BBRM14(
                                                          '${data?['debtAmount']} in ${monthsRounded} months',
                                                          Colors.white,
                                                          1,
                                                          TextAlign.left),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          })),
                                        ),
                                      ),

                                      //the next button
                                      SS8(),
                                      NeonActiveButton('Continue', () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PriorityAsEFDebts(
                                                      totalDebtInstallment:
                                                          totalDebtInstallment,
                                                      totalIncome: totalIncome,
                                                      name: name,
                                                    )));
                                      })
                                    ]);
                                  }),
                            )
                          ],
                        );
                      }),
                    ),

                    // the display of the cards
                  ),
                ]),
              )
            ],
          ),
        )),
      ),
    );
  }
}
