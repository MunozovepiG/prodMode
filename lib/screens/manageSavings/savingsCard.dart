import 'package:astute_components/astute_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SavingsCard extends StatefulWidget {
  final DocumentReference paymentRef;
  final int paymentIndex;

  SavingsCard({required this.paymentRef, required this.paymentIndex});

  @override
  State<SavingsCard> createState() => _SavingsCardState();
}

class _SavingsCardState extends State<SavingsCard> {
  List<String> notifications = [];
  double? paymentAmount;
  double balanceAmount = 0.0;
  double? balance;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
    calculateBalance();
  }

  void fetchNotifications() {
    widget.paymentRef.get().then((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          notifications = (data['notifications'] ?? [])?.cast<String>() ?? [];
        }
      }
      setState(() {});
    }).catchError((error) {
      print('Failed to fetch notifications: $error');
    });
  }

  void calculateBalance() {
    widget.paymentRef.get().then((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('payments')) {
          List<dynamic> payments = data['payments'];
          double totalAmount = 0.0;
          for (var payment in payments) {
            totalAmount += payment['amount'];
          }
          balanceAmount = totalAmount;
        }
      }
      setState(() {
        balance = balanceAmount;
      });
    }).catchError((error) {
      print('Failed to calculate balance: $error');
    });
  }

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
                CBButton(),
                Text('balance amount: $balance'),
                Text('insert graphs'),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(children: [Text('Examp;e')]),
                ),
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

                    if (data == null || !data.containsKey('saveCat')) {
                      return Text('Goal not found');
                    }

                    String goal = data['saveCat'];
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
                            double amount = payment['amount'];
                            Timestamp date = payment['date'];
                            return ListTile(
                              title: Text('Amount: $amount'),
                              subtitle: Text('Date: $date'),
                            );
                          },
                        ),
                        SizedBox(height: 20),
                        Text('Notifications:'),
                        Column(
                          children: notifications.map((notification) {
                            DateTime currentDate = DateTime.now();
                            return ListTile(
                              title: Text(notification),
                              subtitle: Text('Date: ${currentDate.toString()}'),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  deleteNotification(notification);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            openPaymentAmountDialog();
                          },
                          child: Text('Add Payment'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            openWithdrawalAmountDialog();
                          },
                          child: Text('Add Withdrawl'),
                        ),
                        TextButton(
                            onPressed: () {
                              deleteRecord(context);
                            },
                            child: Text('Delete'))
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void openPaymentAmountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Payment Amount'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                paymentAmount = double.tryParse(value);
              });
            },
            decoration: InputDecoration(
              hintText: 'Enter amount',
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
              child: Text('Add'),
              onPressed: () {
                if (paymentAmount != null) {
                  addPayment(paymentAmount!);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void addPayment(double amount) {
    widget.paymentRef.get().then((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('payments')) {
          List<dynamic> updatedPayments = data['payments'];

          updatedPayments.add({
            'amount': amount,
            'date': DateTime.now(),
          });

          List<String> updatedNotifications = [];
          updatedNotifications.addAll(notifications);
          updatedNotifications
              .add('You have added \$${amount.toStringAsFixed(2)}');

          widget.paymentRef.update({
            'payments': updatedPayments,
            'notifications': updatedNotifications,
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

  void addWithdrawal(double withdrawlAmount) {
    widget.paymentRef.get().then((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('payments')) {
          List<dynamic> updatedPayments = data['payments'];

          updatedPayments
              .add({'amount': -withdrawlAmount, 'date': DateTime.now()});

          List<String> updatedNotifications = [];
          updatedNotifications.addAll(notifications);
          updatedNotifications.add(
              'You have withdrawn \$${withdrawlAmount.toStringAsFixed(2)}');

          widget.paymentRef.update({
            'payments': updatedPayments,
            'notifications': updatedNotifications,
          }).then((_) {
            print('Withdrawal added successfully');
            setState(() {
              notifications = updatedNotifications;
            });
          }).catchError((error) {
            print('Failed to add withdrawal: $error');
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

  void openWithdrawalAmountDialog() {
    double? withdrawalAmount;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Withdrawal Amount'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                withdrawalAmount = double.tryParse(value);
              });
            },
            decoration: InputDecoration(
              hintText: 'Enter amount',
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
              child: Text('Add'),
              onPressed: () {
                if (withdrawalAmount != null) {
                  addWithdrawal(withdrawalAmount!);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void deleteNotification(String notification) {
    List<String> updatedNotifications = [];
    updatedNotifications.addAll(notifications);
    updatedNotifications.remove(notification);

    widget.paymentRef.update({'notifications': updatedNotifications}).then((_) {
      print('Notification deleted successfully');
      setState(() {
        notifications = updatedNotifications;
      });
    }).catchError((error) {
      print('Failed to delete notification: $error');
    });
  }

  void deleteRecord(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this record?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                widget.paymentRef.delete().then((_) {
                  print('Record deleted successfully');
                  Navigator.of(context).pop(); // Close the confirmation dialog
                  Navigator.of(context).pop(); // Go back to the previous page
                }).catchError((error) {
                  print('Failed to delete record: $error');
                });
              },
            ),
          ],
        );
      },
    );
  }
}
