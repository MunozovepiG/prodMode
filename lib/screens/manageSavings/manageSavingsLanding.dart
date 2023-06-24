import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Test extends StatelessWidget {
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
        child: ElevatedButton(
          onPressed: () {
            groupPaymentsByMonth(data);
          },
          child: Text('Group Payments'),
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
}
