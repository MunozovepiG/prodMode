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

  @override
  void initState() {
    super.initState();
    fetchPaymentData();
  }

  void fetchPaymentData() async {
    try {
      final snapshot = await widget.paymentRef.get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('goal')) {
          setState(() {
            goal = data['goal'];
            payments = List<dynamic>.from(data['payments']);
          });
        }
      }
    } catch (error) {
      print('Failed to fetch payment data: $error');
    }
  }

  void addPayment() async {
    try {
      final newPayment = {
        'amount': 900,
        'date': DateTime.now().toString(),
      };
      setState(() {
        payments.add(newPayment);
      });
      await widget.paymentRef.update({'payments': payments});
      print('Payment added successfully');
    } catch (error) {
      print('Failed to add payment: $error');
    }
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
          ElevatedButton(
            onPressed: () {
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
}
