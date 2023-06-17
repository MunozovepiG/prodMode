import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DebtTest extends StatefulWidget {
  final Map? debtDetails;
  final String? documentID;

  DebtTest({required this.debtDetails, this.documentID});

  @override
  State<DebtTest> createState() => _DebtTestState();
}

class _DebtTestState extends State<DebtTest> {
  String? debtCat;

  @override
  void initState() {
    super.initState();
    // Set the initial value of debtCat using the debtDetails map
    debtCat = widget.debtDetails?['debtCat'];
  }

  void updateDebtCat(String newDebtCat) {
    setState(() {
      debtCat = newDebtCat;
    });

    // Update the debt category in Firestore
    String? documentID = widget.documentID;
    if (documentID != null) {
      FirebaseFirestore.instance
          .collection('debts')
          .doc(documentID)
          .update({'debtCat': newDebtCat});
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newDebtCat = '';
        return AlertDialog(
          title: Text('Update Debt Category'),
          content: TextField(
            onChanged: (value) {
              newDebtCat = value;
            },
            decoration: InputDecoration(
              labelText: 'New Debt Category',
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () {
                // Call the updateDebtCat function with the new category
                updateDebtCat(newDebtCat);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.debtDetails == null) {
      // Handle the case where debtDetails is null
      return Scaffold(
        appBar: AppBar(
          title: Text('Debt Details'),
        ),
        body: Center(
          child: Text('No debt details available.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Debt Details'),
      ),
      body: Container(
        // Display the details of the selected debt
        child: Column(
          children: [
            Text('$debtCat'),
            TextButton(
              child: Text('Update Debt Category'),
              onPressed: _showUpdateDialog,
            )
          ],
        ),
      ),
    );
  }
}
