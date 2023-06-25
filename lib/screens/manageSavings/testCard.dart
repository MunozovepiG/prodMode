import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditPaymentScreen extends StatefulWidget {
  final DocumentReference paymentRef;
  final int paymentIndex;

  EditPaymentScreen({required this.paymentRef, required this.paymentIndex});

  @override
  _EditPaymentScreenState createState() => _EditPaymentScreenState();
}

class _EditPaymentScreenState extends State<EditPaymentScreen> {
  String goal = '';
  List<dynamic> payments = [];
  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    fetchPaymentData();
  }

  void fetchPaymentData() async {
    try {
      DocumentSnapshot snapshot = await widget.paymentRef.get();
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          setState(() {
            goal = data['goal'] ?? '';
            payments = data['payments'] ?? [];
            notifications = data['notifications'] ?? [];
          });
        }
      }
    } catch (error) {
      print('Failed to fetch payment data: $error');
    }
  }

  void updatePayment() {
    widget.paymentRef.update({
      'payments.${widget.paymentIndex}.amount': 1000,
      'payments.${widget.paymentIndex}.date': DateTime.now().toString(),
    }).then((_) {
      print('Payment updated successfully');
    }).catchError((error) {
      print('Failed to update payment: $error');
    });
  }

  void addPayment() {
    widget.paymentRef.get().then((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('payments')) {
          List<dynamic> updatedPayments = data['payments'];

          updatedPayments.add({
            'amount': 900,
            'date': DateTime.now().toString(),
          });

          widget.paymentRef.update({'payments': updatedPayments}).then((_) {
            print('Payment added successfully');
            setState(() {
              notifications.add('You have added a payment');
            });
          }).catchError((error) {
            print('Failed to add payment: $error');
          });
        } else {
          print('Payments data not found');
        }
      } else {
        print('Document does not exist');
      }
    }).catchError((error) {
      print('Failed to get document: $error');
    });
  }

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
          Column(
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
          ),
          SizedBox(height: 20),
          Text('Notifications:'),
          ListView.builder(
            shrinkWrap: true,
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              String notification = notifications[index];
              return ListTile(
                title: Text(notification),
              );
            },
          ),
          ElevatedButton(
            onPressed: updatePayment,
            child: Text('Update Payment'),
          ),
          ElevatedButton(
            onPressed: addPayment,
            child: Text('Add Payment'),
          ),
        ],
      ),
    );
  }
}
