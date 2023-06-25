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
  List<String> notifications = [];

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
            future: widget.paymentRef.get(),
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
              notifications = (data['notifications'] ?? [])?.cast<String>();

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
                ],
              );
            },
          ),
          ElevatedButton(
            onPressed: () {
              // Perform the update operation on Firebase
              widget.paymentRef.update({
                'payments.${widget.paymentIndex}.amount': 1000,
                'payments.${widget.paymentIndex}.date':
                    DateTime.now().toString(),
              }).then((_) {
                print('Payment updated successfully');
              }).catchError((error) {
                print('Failed to update payment: $error');
              });
            },
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

          List<String> updatedNotifications = [];
          updatedNotifications.addAll(notifications);
          updatedNotifications.add('You have added a payment');

          widget.paymentRef.update({
            'payments': updatedPayments,
            'notifications': updatedNotifications
          }).then((_) {
            print('Payment added successfully');
            setState(() {
              notifications = updatedNotifications;
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
}
