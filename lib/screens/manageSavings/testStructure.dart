import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prod_mode/screens/manageSavings/testCard.dart';

class Test extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grouped Payments'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                    saveDataToFirebase();
                  },
                  child: Text('test')),
              Container(
                height: 450,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection('testData')
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
                        String goal = data?['goal'];
                        List<dynamic> payments = [];

                        if (data?['payments'] is List<dynamic>) {
                          payments = List.from(data?['payments']);
                        }

                        return InkWell(
                          child: Card(
                            child: ListTile(
                              title: Text('Goal: $goal'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: payments.map<Widget>((payment) {
                                  int amount = payment['amount'];
                                  String date = payment['date'];
                                  return Text(
                                      'Payment - Amount: $amount, Date: $date');
                                }).toList(),
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  // Add the new payment to the payments list
                                  payments.add({
                                    'amount': 900,
                                    'date': DateTime.now().toString(),
                                  });

                                  // Update the payments field in Firestore
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.uid)
                                      .collection('testData')
                                      .doc(documents[index].id)
                                      .update({'payments': payments})
                                      .then((_) =>
                                          print('Payment added successfully'))
                                      .catchError((error) => print(
                                          'Failed to add payment: $error'));
                                },
                                child: Text('Add Payment'),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPaymentScreen(
                                  paymentRef: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.uid)
                                      .collection('testData')
                                      .doc(documents[index].id),
                                  paymentIndex: index,
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
              SizedBox(
                height: 55,
              ),
              ElevatedButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection('testData')
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
                    groupPaymentsByMonth(data);
                  }).catchError((error) {
                    print('Error fetching data: $error');
                  });
                },
                child: Text('Group Payments'),
              ),
              TextButton(
                  onPressed: () {
                    readTestData();
                  },
                  child: Text('date'))
            ],
          ),
        ),
      ),
    );
  }

  //grouping data

  List<Map<String, dynamic>> groupPaymentsByMonth(
      List<Map<String, dynamic>> data) {
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

        if (paymentDate != null) {
          final parsedDate = dateFormatter.parse(paymentDate);
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
    }

    // Prepare data for plotting
    List<Map<String, dynamic>> chartData = [];
    for (int month = 1; month <= 12; month++) {
      final monthName = DateFormat.MMMM().format(DateTime(2000, month));
      final total = monthlyTotals[monthName] ?? 0;
      chartData.add({
        'month': monthName,
        'total': total,
      });
    }

    // Return the chart data
    return chartData;
  }
}

void saveDataToFirebase() async {
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('testData');

  Map<String, dynamic> data = {
    'goal': 'Goal 1',
    'payments': [
      {'amount': 500, 'date': 'June 8, 2023'},
      {'amount': 900, 'date': 'June 19, 2023'},
    ],
  };

  try {
    await ref.add(data);
    print('Data saved successfully!');
  } catch (e) {
    print('Error saving data: $e');
  }
}

void readDataFromFirebase() async {
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('testData');

  try {
    QuerySnapshot querySnapshot = await ref.get();
    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;
        // Access the fields of the document
        String goal = data?['goal'];
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
      .collection('testData');

  try {
    QuerySnapshot querySnapshot = await ref.get();
    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;
        // Access the fields of the document
        String goal = data?['goal'];
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
