import 'package:astute_components/astute_components.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prod_mode/internalComponents.dart';
import 'package:prod_mode/screens/manageSavings/manageSavings.dart';
import 'package:fl_chart/fl_chart.dart';

class SavingsCard extends StatefulWidget {
  final DocumentReference paymentRef;
  final int paymentIndex;
  final double? balance;
  final Function? onUpdateTotalAmount; // Callback function

  SavingsCard({
    required this.paymentRef,
    required this.paymentIndex,
    this.balance,
    this.onUpdateTotalAmount,
  });

  @override
  _SavingsCardState createState() => _SavingsCardState();
}

class _SavingsCardState extends State<SavingsCard> {
  List<String> notifications = [];
  double? paymentAmount;
  double? balance;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
    updateBalance();
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

  void updateBalance() {
    widget.paymentRef.get().then((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('payments')) {
          List<dynamic> payments = data['payments'];
          double totalAmount = 0.0;
          for (var payment in payments) {
            totalAmount += payment['amount'];
          }
          setState(() {
            balance = totalAmount;
          });
        }
      }
    }).catchError((error) {
      print('Failed to update balance: $error');
    });
  }

  Future<Map<int, double>> _calculateTotalAmountsPerMonth() async {
    final snapshot = await widget.paymentRef.get();
    final Map<int, double> amountsPerMonth = {};

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('payments')) {
        List<dynamic> payments = data['payments'];

        for (final payment in payments) {
          final amount = payment['amount'] as double;
          final date = payment['date'] as Timestamp;

          final paymentYear = date.toDate().year;
          final paymentMonth = date.toDate().month;

          final now = DateTime.now();
          final currentYear = now.year;

          if (paymentYear == currentYear) {
            if (amountsPerMonth.containsKey(paymentMonth)) {
              final currentAmount = amountsPerMonth[paymentMonth] ?? 0;
              amountsPerMonth[paymentMonth] = (currentAmount + amount);
            } else {
              amountsPerMonth[paymentMonth] = amount;
            }
          }
        }
      }
    }

    double maxAmount = 0;
    double targetAmount = 1000; // Set your target amount here

    if (widget.balance != null) {
      if (widget.balance! > 0) {
        maxAmount = widget.balance!;
      } else {
        maxAmount = targetAmount;
      }
    } else {
      maxAmount = targetAmount;
    }

    final interval = maxAmount / 10;
    final minY = maxAmount >= targetAmount ? 0 : maxAmount;
    final maxY =
        maxAmount >= targetAmount ? targetAmount : maxAmount + interval;

    return amountsPerMonth;
  }

  @override
  Widget build(BuildContext context) {
    // Update balance only if the balance parameter is not null
    if (widget.balance != null && balance != widget.balance) {
      balance = widget.balance;
    }
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * 1.0,
        height: MediaQuery.of(context).size.height * 1.0,
        color: Colors.grey[200],
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CBButton(),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ManageSavings()));
                          },
                          child: Text('fuck')),
                      FutureBuilder<Map<int, double>>(
                        future: _calculateTotalAmountsPerMonth(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData) {
                            return Text('No data available');
                          }

                          return Column(
                            children: [
                              Text('Insert graphs'),
                              SizedBox(height: 20),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 300, // Adjust the height as needed
                                child: buildBarChart(snapshot.data!),
                              ),
                            ],
                          );
                        },
                      ),
                      Text('Balance amount: ${balance ?? 0.0}'),
                      SizedBox(height: 20),
                      Text('Insert graphs'),
                      SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          children: [Text('Example')],
                        ),
                      ),
                      FutureBuilder<DocumentSnapshot>(
                        future: widget.paymentRef.get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                                  Map<String, dynamic> payment =
                                      payments[index];
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
                                    subtitle:
                                        Text('Date: ${currentDate.toString()}'),
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
                                child: Text('Add Withdrawal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  deleteRecord(context);
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),

                //the navigation bar

                CustomNavigation(
                  isHome: false,
                )
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
            updateBalance();
            if (widget.onUpdateTotalAmount != null) {
              widget.onUpdateTotalAmount!();
            }
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

  void addWithdrawal(double withdrawalAmount) {
    widget.paymentRef.get().then((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('payments')) {
          List<dynamic> updatedPayments = data['payments'];

          updatedPayments
              .add({'amount': -withdrawalAmount, 'date': DateTime.now()});

          List<String> updatedNotifications = [];
          updatedNotifications.addAll(notifications);

          updatedNotifications.add(
              'You have withdrawn \$${withdrawalAmount.toStringAsFixed(2)}');

          widget.paymentRef.update({
            'payments': updatedPayments,
            'notifications': updatedNotifications,
          }).then((_) {
            print('Withdrawal added successfully');
            setState(() {
              notifications = updatedNotifications;
            });
            updateBalance();
            if (widget.onUpdateTotalAmount != null) {
              widget.onUpdateTotalAmount!();
            }
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
                  if (widget.onUpdateTotalAmount != null) {
                    widget.onUpdateTotalAmount!();
                  }
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }).catchError((error) {
                  print('Failed to delete record: $error');
                });
              },
            ),
          ],
        );
      },
    );

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

      double targetAmount = 1000; // Set your target amount here
      double balance = widget.balance ?? 0.0;

      double minY;
      double maxY;
      double interval;

      if (balance == 0) {
        minY = 0;
        maxY = targetAmount;
      } else if (balance > 0) {
        minY = 0;
        maxY = balance;
      } else {
        minY = balance;
        maxY = targetAmount;
      }

      double range = maxY - minY;
      interval = range / 10;

      return BarChart(
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
                  colors: [Colors.orange],
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
              interval: interval,
              getTitles: (double value) {
                return value.toInt().toString();
              },
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey),
          ),
        ),
      );
    }
  }
}
