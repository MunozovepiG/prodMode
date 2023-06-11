import 'package:astute_components/astute_components.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DebtDetails extends StatefulWidget {
  String? debtStatus;
  int? debtCount;

  DebtDetails({this.debtStatus, this.debtCount});

  @override
  State<DebtDetails> createState() => _DebtDetailsState(debtStatus, debtCount);
}

class _DebtDetailsState extends State<DebtDetails> {
  String? debtStatus;
  int? debtCount;
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _debtAmountController = TextEditingController();
  String? debtCat = 'Personal loan';
  double? debtAmount;
  String? debtAmountInput = '0';
  String? debtDescription;

  _DebtDetailsState(this.debtStatus, this.debtCount);
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
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(children: [
                  BHCTSh(
                      true,
                      'Keep',
                      'Debt-free is the way to be',
                      AppTheme.colors.orange500,
                      AppTheme.colors.orange500,
                      false,
                      false,
                      false,
                      false,
                      false,
                      false,
                      true,
                      'Let’s track and finish it'),

                  MS24(),
                  //description
                  BBRM14(
                      "We will help you with tracking your debts and paying the off as soon as possible.",
                      AppTheme.colors.black,
                      6,
                      TextAlign.center),

                  SS36(),
                  Row(
                    children: [
                      SH12('Debt (${debtCount})', AppTheme.colors.black, 1),
                    ],
                  ),

                  SS16(),
                  MyDropdown(
                      values: [
                        'Student loan',
                        'Car loan',
                        'Student / Education loan',
                        'Mortgage / House loan',
                        'Credit card',
                        'Personal loan',
                        'Credit facility',
                        'Other'
                      ],
                      preselectedValue: 'Personal loan',
                      onChanged: (value) {
                        setState(() {
                          debtCat = value;
                        });
                      },
                      iconColor: AppTheme.colors.orange500,
                      borderColor: AppTheme.colors.orange500,
                      labelText:
                          'Please provide which category the debt falls in:'),

                  MS24(),

                  //the description text form field
                  MyCustomTextField(
                    inputLabelText: 'Brief description of the $debtCat:',
                    controller: _descriptionController,
                    backgroundColor: AppTheme.colors.orange200,
                    hintText: 'personal loan from ABC bank',
                    labelText: '$debtCat description',
                    onChanged: (value) {
                      debtDescription = value;
                    },
                  ),

                  MS24(),
// the amount text field
                  MyCustomTextField(
                    inputLabelText: 'Please provide the $debtCat amount',
                    controller: _debtAmountController,
                    backgroundColor: AppTheme.colors.orange200,
                    hintText: 'income',
                    labelText: 'income',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        debtAmountInput = value;
                        debtAmount = double.parse(debtAmountInput!);
                      });
                    },
                  ),

                  SS36(),
                  (debtAmount! > 0 && debtDescription != null)
                      ? NeonActiveButton('Next', () {})
                      : DisabledRoundButton('Next', () {})
                ]),
              )
            ],
          ),
        )),
      ),
    );
  }
}
