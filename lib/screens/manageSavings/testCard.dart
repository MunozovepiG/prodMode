import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditPaymentScreen extends StatelessWidget {
  final DocumentReference paymentRef;
  final int paymentIndex;

  EditPaymentScreen({required this.paymentRef, required this.paymentIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Payment'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: paymentRef.get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return Text('No data available');
              }
              Map<String, dynamic>? data =
                  snapshot.data!.data() as Map<String, dynamic>?;

              if (data == null || !data.containsKey('goal')) {
                return Text('Goal not found');
              }

              String goal = data['goal'];
              List<dynamic> payments = data['payments'];

              return Column(
                children: [
                  Text('Goal: $goal'),
                  SizedBox(height: 20),
                  Text('Payments:'),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: payments.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> payment = payments[index];
                      int amount = payment['amount'];
                      String date = payment['date'];
                      return ListTile(
                        title: Text('Amount: $amount'),
                        subtitle: Text('Date: $date'),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          ElevatedButton(
            onPressed: () {
              // Perform the update operation on Firebase
              paymentRef.update({
                'payments.$paymentIndex.amount': 1000,
                'payments.$paymentIndex.date': DateTime.now().toString(),
              }).then((_) {
                print('Payment updated successfully');
              }).catchError((error) {
                print('Failed to update payment: $error');
              });
            },
            child: Text('Update Payment'),
          ),
        ],
      ),
    );
  }
}
