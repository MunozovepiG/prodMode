import 'package:flutter/material.dart';
import 'package:prod_mode/screens/debtCapture/debtOverview.dart';

class UpdateDebtCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? value = 'New Cat Test';
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Debt Category'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DebtOverview(
                          example: value,
                        )));
              },
              child: Text('Update Category'),
            ),
          ],
        ),
      ),
    );
  }
}
