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
  double? debtAmount = 0;
  String? debtAmountInput = '0';
  String? debtDescription;
  bool? biWeekly = false;
  String firstPaymentText = '';
  String secondPaymentText = '';
  DateFormat formatter = DateFormat('E, MMM dd, yyyy');
  DateTime? secondPaymentDate;
  DateTime? firstPaymentDate;
  DateTime? endDate;
  String? endDateText = 'dd/mm/yyyy';

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
                  MS24(),
                  //checkbox

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ILM12('Please tick if you repay this loan bi-weekly:',
                          AppTheme.colors.grey800, 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                              value: biWeekly,
                              activeColor: AppTheme.colors.orange500,
                              onChanged: (bool? value) {
                                setState(() {
                                  biWeekly = value;
                                });
                              }),
                          Text('Repayment is done bi-weekly'),
                        ],
                      ),

                      MS24(),

                      //the payments options

                      (biWeekly!)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //payment one
                                MonthlyCalendar(
                                    primaryColor: AppTheme.colors.orange500,
                                    onDateSelected: (value) {
                                      firstPaymentText = value;
                                      firstPaymentDate =
                                          formatter.parse(firstPaymentText);
                                    },
                                    colorscheme: ColorScheme.light(
                                        primary: AppTheme.colors.orange500),
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    iconColor: AppTheme.colors.orange500,
                                    labelText:
                                        'Please select your first repayment date'),

                                MS24(),
                                MonthlyCalendar(
                                    primaryColor: AppTheme.colors.orange500,
                                    onDateSelected: (value) {
                                      secondPaymentText = value;
                                      print(secondPaymentText);
                                      secondPaymentDate =
                                          formatter.parse(secondPaymentText);
                                    },
                                    colorscheme: ColorScheme.light(
                                        primary: AppTheme.colors.orange500),
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    iconColor: AppTheme.colors.orange500,
                                    labelText:
                                        'Please select your second repayment date')
                              ],
                            )
                          : Column(
                              children: [
                                MonthlyCalendar(
                                    primaryColor: AppTheme.colors.orange500,
                                    onDateSelected: (value) {
                                      setState(() {
                                        firstPaymentText = value;
                                        firstPaymentDate =
                                            formatter.parse(firstPaymentText);

                                        print(value);
                                      });
                                    },
                                    colorscheme: ColorScheme.light(
                                        primary: AppTheme.colors.orange500),
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    iconColor: AppTheme.colors.orange500,
                                    labelText:
                                        'Please select your repayment date'),
                              ],
                            ),
                    ],
                  ),

                  //end payment date
                  MS24(),
                  Row(
                    children: [
                      //bespoke calendar given the calculations that need to be completed
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ILM12('Please select the due date',
                              AppTheme.colors.grey650, 1),
                          IconTextButton(
                              icon: Icons.calendar_month_outlined,
                              color: AppTheme.colors.orange500,
                              text: '${endDateText}',
                              textColor: AppTheme.colors.black,
                              onPressed: () {
                                setState(() {
                                  _endDatePicker();
                                });
                              }),
                        ],
                      ),
                    ],
                  ),

                  SS36(),

                  (biWeekly!)
                      ? Column(
                          children: [
                            (debtAmount! > 0 &&
                                    firstPaymentText != '' &&
                                    secondPaymentText != '' &&
                                    endDateText != '')
                                ? Text('valid')
                                : Text('invalid')
                          ],
                        )
                      : Column(
                          children: [
                            (debtAmount! > 0 &&
                                    firstPaymentText != '' &&
                                    endDateText != '')
                                ? Text('valid')
                                : Text('invalid')
                          ],
                        )
                ]),
              )
            ],
          ),
        )),
      ),
    );
  }

  // the end datePicker
  Future<void> _endDatePicker() async {
    DateTime? currentDate = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      //this needs to be calculated
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate: currentDate.add(Duration(days: 365 * 30)),
    );

    if (pickedDate != null) {
      setState(() {
        endDate = pickedDate;
        endDateText = formatter.format(endDate!);
      });
    }
  }
}
