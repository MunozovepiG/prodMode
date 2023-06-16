import 'package:astute_components/astute_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class OverviewReviewed extends StatefulWidget {
  const OverviewReviewed({super.key});

  @override
  State<OverviewReviewed> createState() => _OverviewReviewedState();
}

class _OverviewReviewedState extends State<OverviewReviewed> {
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('userDebtDetails');

  double? totalDebts = 0;

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
                  Container(
                      child: FutureBuilder<QuerySnapshot>(
                          future: ref.get(),
                          builder: ((context, snapshot) {
                            final List debts = [];
                            snapshot.data?.docs
                                .map((DocumentSnapshot document) {
                              Map a = document.data() as Map<dynamic, dynamic>;
                              debts.add(a);
                              a['id'] = document.id;
                            }).toList();

                            List<double> debtTotal = [];
                            if (debts.isNotEmpty) {
                              for (int i = 0; i < debts.length; i++) {
                                debtTotal.add(debts[i]['installment']);

                                totalDebts = debtTotal.sum;
                              }
                            }

                            return Column(
                              children: [
                                CBButton(), Text('$totalDebts'),

                                //the cards

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

                                          return Container(
                                              height: 300,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: snapshot
                                                      .data?.docs.length,
                                                  itemBuilder:
                                                      (((context, index) {
                                                    Map? data = snapshot
                                                        .data?.docs[index]
                                                        .data() as Map?;

                                                    String?
                                                        formattedInstallment =
                                                        data?['installment']
                                                            .toStringAsFixed(2);
                                                    return Text(
                                                        '${data?['installment'].toStringAsFixed(2)}');
                                                  }))));
                                        }))
                              ],
                            );
                          })))
                ]),
              )
            ],
          ),
        )),
      ),
    );
  }
}
