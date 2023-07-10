import 'package:astute_components/astute_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prod_mode/homeFlow/homePage.dart';
import 'package:prod_mode/internalComponents.dart';
import 'package:prod_mode/screens/manageSavings/savingsCard.dart';
import 'package:fl_chart/fl_chart.dart';

class ManageSavings extends StatefulWidget {
  @override
  _ManageSavingsState createState() => _ManageSavingsState();
}

class _ManageSavingsState extends State<ManageSavings> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  double totalAmount = 0.0;

//total Savings
  Future<double> calculateTotalAmount() async {
    double totalAmount = 0;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('userSaveDetails')
        .get();

    List<DocumentSnapshot> documents = querySnapshot.docs;

    for (var document in documents) {
      List<dynamic> payments = document['payments'];
      for (var payment in payments) {
        double amount = payment['amount'];
        totalAmount += amount;
      }
    }

    return totalAmount;
  }

  // Calculation of payments
  double calculateTotal(List<dynamic> payments) {
    double total = 0;
    for (var payment in payments) {
      double amount = payment['amount'] as double;
      total += amount;
    }
    return total;
  }

  Future<Map<int, double>> calculateTotalAmountsPerMonth(int year) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userSaveDetailsRef = firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('userSaveDetails');

    final querySnapshot = await userSaveDetailsRef.get();

    final Map<int, double> amountsPerMonth = {};

    for (final document in querySnapshot.docs) {
      final payments = document.data()['payments'] as List<dynamic>;

      for (final payment in payments) {
        final amount = payment['amount'] as double;
        final date = payment['date'] as Timestamp;

        final paymentYear = date.toDate().year;
        final paymentMonth = date.toDate().month;

        if (paymentYear == year) {
          if (amountsPerMonth.containsKey(paymentMonth)) {
            final currentAmount = amountsPerMonth[paymentMonth] ?? 0;
            amountsPerMonth[paymentMonth] = (currentAmount + amount);
          } else {
            amountsPerMonth[paymentMonth] = amount;
          }
        }
      }

      totalAmount += calculateTotal(payments);
      totalAmount = calculateTotal(payments); // Assign total amount

      // Add to total amount
    }

    // Calculate total amounts per month
    final int totalMonths = 12;
    for (int month = 1; month <= totalMonths; month++) {
      amountsPerMonth[month] ??= 0;
    }

    return amountsPerMonth;
  }

  @override
  void initState() {
    super.initState();
    initPage();
    // calculateTotalAmount();
  }

  void initPage() async {
    final year = 2023;
    final amountsPerMonth = await calculateTotalAmountsPerMonth(year);

    // Print the total amounts per month
    amountsPerMonth.forEach((month, totalAmount) {
      print('Month: $month, Total Amount: $totalAmount');
    });

    updateTotalAmount(); // Call the function here to update the total amount
  }

  void updateTotalAmount() async {
    double total = await calculateTotalAmount();
    setState(() {
      totalAmount = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 1.0,
          height: MediaQuery.of(context).size.height * 1.0,
          color: AppTheme.colors.background,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    children: [
                      SS36(),
                      UPTrackingHeading(AppTheme.colors.orange500, 'Keep',
                          'Here you can protect your money by managing your savings.',
                          () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      }),
                      MS24(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 400,
                            width: MediaQuery.of(context).size.width * 0.90,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.55),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x19000000),
                                  blurRadius: 7.58,
                                  offset: Offset(0, 1.52),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //the chart facts
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: BR10('Total savings', Colors.black,
                                          1, TextAlign.left),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: BBLM14(
                                        '${totalAmount}',
                                        Colors.black,
                                        1,
                                      ),
                                    ),

                                    MS24(),
                                    Container(
                                      height: 300,
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      child: FutureBuilder<Map<int, double>>(
                                        future:
                                            calculateTotalAmountsPerMonth(2023),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else if (!snapshot.hasData) {
                                            return Text('No data available');
                                          }

                                          return buildBarChart(snapshot.data!);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SmallView(Icons.add, 'add new', () {
                            Navigator.pushNamed(context, '/page2');
                          }),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 450,
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

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }

                                List<DocumentSnapshot> documents =
                                    snapshot.data!.docs;

                                return ListView.builder(
                                  itemCount: documents.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> data = documents[index]
                                        .data() as Map<String, dynamic>;
                                    String saveCat = data?['saveCat'];
                                    double contributions =
                                        data?['contributions'];
                                    int months = data?['months'];

                                    List<Map<String, dynamic>> payments = [];

                                    if (data?['payments'] is List<dynamic>) {
                                      payments =
                                          (data?['payments'] as List<dynamic>)
                                              .cast<Map<String, dynamic>>();
                                    }

                                    double totalAmount =
                                        calculateTotal(payments);

                                    return InkWell(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 24.0),
                                        child: Container(
                                          decoration: ShapeDecoration(
                                            color: Color(0xFFFF9958),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: ListTile(
                                            title: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 4.0,
                                                right: 4.0,
                                                top: 8.0,
                                                bottom: 4.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  BBRM14(
                                                    '$contributions monthly',
                                                    AppTheme.colors.white,
                                                    1,
                                                    TextAlign.left,
                                                  ),
                                                  ArrowIButton(() {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SavingsCard(
                                                          paymentRef: FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  ?.uid)
                                                              .collection(
                                                                  'userSaveDetails')
                                                              .doc(documents[
                                                                      index]
                                                                  .id),
                                                          paymentIndex: index,
                                                          onUpdateTotalAmount:
                                                              updateTotalAmount,
                                                          //onUpdateTotalAmount:
                                                          // updateTotalAmount, // Pass the callback function here
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                ],
                                              ),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 4.0,
                                                right: 4.0,
                                                bottom: 8.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  BBLM14(
                                                    '$saveCat',
                                                    AppTheme.colors.white,
                                                    1,
                                                  ),
                                                  SizedBox(height: 4),
                                                  BBBS12(
                                                    'Amount saved: $totalAmount',
                                                    AppTheme.colors.white,
                                                    1,
                                                    TextAlign.left,
                                                  ),
                                                  SizedBox(height: 4),
                                                  BBRS12(
                                                    '$months months to get there',
                                                    AppTheme.colors.white,
                                                    1,
                                                    TextAlign.left,
                                                  ),
                                                  ...payments
                                                      .map<Widget>((payment) {
                                                    double amount =
                                                        payment['amount'];
                                                    Timestamp date =
                                                        payment['date'];

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
                                              paymentRef: FirebaseFirestore
                                                  .instance
                                                  .collection('users')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser?.uid)
                                                  .collection('userSaveDetails')
                                                  .doc(documents[index].id),
                                              paymentIndex: index,
                                              //onUpdateTotalAmount:
                                              //  updateTotalAmount, // Pass the callback function here
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      CustomNavigation(
                        isHome: false,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addTestData() {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('userSaveDetails');
    DateFormat formatter = DateFormat('E, dd, MM, yyyy');
    DateTime endDate = DateTime(2024, 7, 6);
    DateTime startDate = DateTime(2023, 6, 18);
    double contributions = 500.00;
    double amount1 = 300.00;
    double amount2 = 200.00;

    Map<String, dynamic> data = {
      'startDate': startDate,
      'endDate': endDate,
      'saveCat': 'Example Savings 2',
      'months': 2,
      'description': 'test data',
      'targetamount': 10000,
      'formattedEndDate': formatter.format(endDate),
      'formattedStartDate': formatter.format(DateTime.now()),
      'contributions': contributions,
      'amountSaved': 0,
      'payments': [
        {'amount': amount1, 'date': DateTime(2023, 2, 11)},
        {'amount': amount2, 'date': DateTime(2023, 4, 18)}
      ]
    };

    ref.add(data);
  }
}

Widget buildBarChart(Map<int, double> amountsPerMonth) {
  final monthNames = [
    '', // Empty string as a placeholder for index 0
    'J', 'F', 'M', 'A', 'M', 'J',
    'J', 'A', 'S', 'O', 'N', 'D'
  ];

  // Calculate the minimum and maximum values
  double minAmount = double.infinity;
  double maxAmount = double.negativeInfinity;
  for (final amount in amountsPerMonth.values) {
    if (amount < minAmount) {
      minAmount = amount;
    }
    if (amount > maxAmount) {
      maxAmount = amount;
    }
  }

  final maxY = (maxAmount ~/ 100 + 1) * 100;
  final minY = (minAmount ~/ 100 - 1) * 100;

  return Container(
    height: 300,
    child: BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceEvenly,
        maxY: maxY.toDouble(),
        minY: minY.toDouble(),
        barGroups: List.generate(12, (index) {
          final month = index + 1;
          final amount = amountsPerMonth[month] ?? 0.0;
          return BarChartGroupData(
            x: month,
            barRods: [
              BarChartRodData(
                y: amount,
                colors: [Color(0xFFFE6E04)],
              ),
            ],
          );
        }),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => TextStyle(color: Colors.black),
            margin: 8,
            getTitles: (double value) {
              final monthIndex = value.toInt();
              if (monthIndex > 0 && monthIndex <= 12) {
                return monthNames[monthIndex];
              }
              return '';
            },
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => TextStyle(color: Colors.black),
            margin: 8,
            reservedSize: 40,
            interval: 100,
            getTitles: (double value) {
              if (value % 100 == 0) {
                return value.toInt().toString();
              }
              return '';
            },
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey),
        ),
      ),
    ),
  );
}
