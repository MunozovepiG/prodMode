import 'package:astute_components/astute_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prod_mode/screens/manageSavings/barChartData/chartModel.dart';
import 'package:prod_mode/screens/manageSavings/barchart.dart';
import 'package:prod_mode/screens/manageSavings/savingsCard.dart';
import 'package:prod_mode/screens/manageSavings/testCard.dart';

class ManageSavings extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<SavingDataModel> exData = [];

//calculation of payments
  double calculateTotal(List<Map<String, dynamic>> payments) {
    double total = 0;
    for (var payment in payments) {
      double amount = payment['amount'];
      total += amount;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      width: MediaQuery.of(context).size.width * 1.0,
      height: MediaQuery.of(context).size.height * 1.0,
      color: AppTheme.colors.background,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(children: [
              //the heading
              SS36(),

              TrackingHeading(
                  AppTheme.colors.orange500,
                  'Keep',
                  'Here you can protect your money by managing your savings.',
                  TextAlign.left),

              MS24(),
              TextButton(
                  onPressed: () {
                    addTestData();
                  },
                  child: Text('to delete button')),
              Text('graph to be inserted'),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SmallView(Icons.add, 'add new', () {
                    Navigator.pushNamed(context, '/page2');
                  }),
                ],
              ),

              // BarChartWidget(data: chartData),

              Container(
                height: 450,
                // color: Colors.orange,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection('userSaveDetails')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData) {
                      return Text('No data available');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    List<DocumentSnapshot> documents = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data =
                            documents[index].data() as Map<String, dynamic>;
                        String saveCat = data?['saveCat'];
                        double contributions = data?['contributions'];
                        int months = data?['months'];

                        List<Map<String, dynamic>> payments = [];

                        if (data?['payments'] is List<dynamic>) {
                          payments = (data?['payments'] as List<dynamic>)
                              .cast<Map<String, dynamic>>();
                        }

                        double totalAmount = calculateTotal(payments);

                        return InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: Container(
                              decoration: ShapeDecoration(
                                color: Color(0xFFFF9958),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4.0,
                                      right: 4.0,
                                      top: 8.0,
                                      bottom: 4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      BBRM14(
                                          '$contributions monthly',
                                          AppTheme.colors.white,
                                          1,
                                          TextAlign.left),
                                      ArrowIButton(() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SavingsCard(
                                                      paymentRef: FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser
                                                              ?.uid)
                                                          .collection(
                                                              'userSaveDetails')
                                                          .doc(documents[index]
                                                              .id),
                                                      paymentIndex: index,
                                                    )));
                                      })
                                    ],
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4.0, right: 4.0, bottom: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BBLM14(
                                        '$saveCat',
                                        AppTheme.colors.white,
                                        1,
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      BBBS12(
                                          'Amount saved: $totalAmount ',
                                          AppTheme.colors.white,
                                          1,
                                          TextAlign.left),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      BBRS12(
                                          '$months months to get there',
                                          AppTheme.colors.white,
                                          1,
                                          TextAlign.left),
                                      ...payments.map<Widget>((payment) {
                                        double amount = payment['amount'];
                                        Timestamp date = payment['date'];

                                        return Column(
                                          children: [],
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SavingsCard(
                                          paymentRef: FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser?.uid)
                                              .collection('userSaveDetails')
                                              .doc(documents[index].id),
                                          paymentIndex: index,
                                        )));
                          },
                        );
                      },
                    );
                  },
                ),
              ),

              TextButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection('userSaveDetails')
                      .get()
                      .then((querySnapshot) {
                    List<Map<String, dynamic>> data = [];
                    for (var documentSnapshot in querySnapshot.docs) {
                      Map<String, dynamic>? documentData =
                          documentSnapshot.data() as Map<String, dynamic>?;
                      if (documentData != null) {
                        data.add(documentData);
                      }
                    }
                    List<SavingDataModel> chartData =
                        groupPaymentsByMonth(data);
                    exData = chartData;
                    print(chartData); // Use the chart data as needed
                  }).catchError((error) {
                    print('Error fetching data: $error');
                  });
                },
                child: Text('Testdata'),
              ),
            ]),
          ),
        ],
      ),
    )));
  }

  List<SavingDataModel> groupPaymentsByMonth(List<Map<String, dynamic>> data) {
    List<SavingDataModel> _list = [];

    Map<String, num> monthlyTotals = {};
    DateFormat dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS');

    // Initialize monthly totals for all months to 0
    for (int month = 1; month <= 12; month++) {
      final monthName = DateFormat.MMMM().format(DateTime(2000, month));
      monthlyTotals[monthName] = 0;
    }

    for (var item in data) {
      for (var payment in item['payments']) {
        final paymentAmount = payment['amount'];
        final paymentDate = payment['date'];

        if (paymentDate != null && paymentDate is Timestamp) {
          final parsedDate = (paymentDate as Timestamp).toDate();
          final monthName = DateFormat.MMMM().format(parsedDate);
          monthlyTotals[monthName] =
              (monthlyTotals[monthName] ?? 0) + paymentAmount;
        }
      }
    }

    // Print the monthly totals
    for (int month = 1; month <= 12; month++) {
      final monthName = DateFormat.MMMM().format(DateTime(2000, month));
      final total = monthlyTotals[monthName] ?? 0;
      print('Month: $monthName, Total Amount: $total');

      SavingDataModel dataModel =
          SavingDataModel(key: monthName, value: total.toString());
      _list.add(dataModel);
    }

    // Return the chart data
    return _list;
  }

  void readDataFromFirebase() async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('userSaveDetails');

    try {
      QuerySnapshot querySnapshot = await ref.get();
      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          Map<String, dynamic>? data =
              documentSnapshot.data() as Map<String, dynamic>?;
          // Access the fields of the document
          String goal = data?['saveCat'];
          List<dynamic> payments = data?['payments'];

          // Print the data
          print('Goal: $goal');
          for (var payment in payments) {
            int amount = payment['amount'];
            String date = payment['date'];
            print('Payment - Amount: $amount, Date: $date');
          }
        }
      } else {
        print('No documents found.');
      }
    } catch (e) {
      print('Error reading data: $e');
    }
  }

  void readTestData() async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('userSaveDetails');

    try {
      QuerySnapshot querySnapshot = await ref.get();
      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          Map<String, dynamic>? data =
              documentSnapshot.data() as Map<String, dynamic>?;
          // Access the fields of the document
          String goal = data?['saveCat'];
          List<dynamic> payments = data?['payments'];

          // Print the data
          print('Goal: $goal');
          for (var payment in payments) {
            int amount = payment['amount'];
            String date = payment['date'];
            print('Payment - Amount: $amount, Date: $date');
          }
        }
      } else {
        print('No documents found.');
      }
    } catch (e) {
      print('Error reading data: $e');
    }
  }

  void addTestData() {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('userSaveDetails');
    DateFormat formatter = DateFormat('E, dd, MM, yyyy');
    DateTime endDate = DateTime(2024, 7, 6);
    DateTime startDate = DateTime(2023, 6, 18);
    double contributions = 500;
    double amount1 = 100;
    double amount2 = 400;

    Map<String, dynamic> data = {
      'startDate': startDate,
      'endDate': endDate,
      'saveCat': 'Example Savings 2',
      'months': 2,
      'description': 'test data',
      //'savingStatus': savingStatus, this is inferred
      'targetAmount': 10000,
      'formattedEndDate': formatter.format(endDate),
      'formattedStartDate': formatter.format(DateTime.now()),
      'contributions': contributions,
      // 'status': status, this will be a dynamic value
      'amountSaved': 0, //change back to amountSaved
      'payments': [
        {'amount': amount1, 'date': startDate},
        {'amount': amount2, 'date': DateTime.now()}
      ]

      // this system to be developed 'goalStatus': ,
    };

    ref.add(data);
  }
}
