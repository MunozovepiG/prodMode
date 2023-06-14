import 'package:astute_components/astute_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class DebtOverview extends StatefulWidget {
  @override
  State<DebtOverview> createState() => _DebtOverviewState();
}

class _DebtOverviewState extends State<DebtOverview> {
  // pulling from the debt database
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('userDebtDetails');

  double? totalDebts;
  String? formattedTotalDebts;

  //the varriables for the totals

  double? totalCreditCards;
  String? totalCreditCardtext;
  double? totalStudentLoans;
  String? totalStudentLoantext;
  double? totalPersonalLoans;
  String? totalPersonalLoanstext;
  double? totalcreditFacility;
  String? totalcreditFacilitytext;
  double? totalCarLoans;
  String? totalCarloanstext;
  double? totalOther;
  String? totalOthertext;
  double? totalMortgage;
  String? totalMortgagetext;

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

                            totalDebts = debtTotal.sum;
                            formattedTotalDebts =
                                (totalDebts!).toStringAsFixed(2);

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

                            if (debts[i]['debtCat'] == 'Car Loan') {
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
                            totalCreditCards = carLoanTotal.sum;
                            totalCarloanstext =
                                totalCreditCards!.toStringAsFixed(2);
                          } else {
                            totalCreditCards = 0;
                            totalCarloanstext =
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
                        }

                        return Column(
                          children: [
                            CBButton(),
                            Text('$totalPersonalLoanstext'),

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
                                        height: 250,
                                        child: ListView.builder(
                                          itemCount: snapshot.data?.docs.length,
                                          itemBuilder: (((context, index) {
                                            Map? data = snapshot
                                                .data?.docs[index]
                                                .data() as Map?;

                                            return Container(
                                              child: Row(
                                                children: [
                                                  Text(
                                                      '${data?['debtAmount']}'),
                                                  TextButton(
                                                      onPressed: () async {
                                                        await snapshot
                                                            .data
                                                            ?.docs[index]
                                                            .reference
                                                            .delete();

                                                        Navigator.of(context)
                                                            .push(MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        DebtOverview()))
                                                            .then((value) =>
                                                                setState(
                                                                  () {},
                                                                ));
                                                      },
                                                      child: Text('Delete'))
                                                ],
                                              ),
                                            );
                                          })),
                                        ),
                                      )
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
