import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prod_mode/screens/manageSavings/testCard.dart';

class Test extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> data = [
    {
      'goal': 'Goal 1',
      'payments': [
        {'amount': 500, 'date': 'June 8, 2023'},
        {'amount': 900, 'date': 'June 19, 2023'},
      ],
    },
    {
      'goal': 'Goal 2',
      'payments': [
        {'amount': 800, 'date': 'June 8, 2023'},
        {'amount': 900, 'date': 'June 19, 2023'},
        {'amount': 700, 'date': 'May 30, 2023'},
      ],
    },
    {
      'goal': 'Goal 3',
      'payments': [
        {'amount': 800, 'date': 'March 3, 2023'},
        {'amount': 0, 'date': null},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grouped Payments'),
      ),
      body: Center(
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
                      var payments = data!['payments'];

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
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .collection('testData')
                                    .doc(documents[index].id)
                                    .update({'payments': payments})
                                    .then((_) =>
                                        print('Payment added successfully'))
                                    .catchError((error) =>
                                        print('Failed to add payment: $error'));
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
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
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
            ElevatedButton(
              onPressed: () {
                groupPaymentsByMonth(data);
              },
              child: Text('Group Payments'),
            ),
          ],
        ),
      ),
    );
  }

  void groupPaymentsByMonth(List<Map<String, dynamic>> data) {
    Map<String, List<Map<String, dynamic>>> groupedPayments = {};

    DateFormat dateFormatter = DateFormat('MMMM d, y');

    for (var item in data) {
      for (var payment in item['payments']) {
        final paymentAmount = payment['amount'];
        final paymentDate = payment['date'];

        if (paymentDate != null) {
          final parsedDate = dateFormatter.parse(paymentDate);
          final month = parsedDate.month;
          final monthKey = 'Month $month';

          if (groupedPayments.containsKey(monthKey)) {
            groupedPayments[monthKey]!.add({
              'Payment Amount': paymentAmount,
              'Payment Date': parsedDate,
            });
          } else {
            groupedPayments[monthKey] = [
              {
                'Payment Amount': paymentAmount,
                'Payment Date': parsedDate,
              }
            ];
          }
        }
      }
    }

    // Print the grouped payments
    groupedPayments.forEach((monthKey, payments) {
      print('Month: $monthKey');
      payments.forEach((payment) {
        final paymentAmount = payment['Payment Amount'];
        final paymentDate = payment['Payment Date'];
        print('Payment Amount: $paymentAmount, Date: $paymentDate');
      });
      print('\n');
    });
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
}
