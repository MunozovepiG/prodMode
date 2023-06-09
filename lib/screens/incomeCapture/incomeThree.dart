import 'package:astute_components/astute_components.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:prod_mode/screens/incomeCapture/incomeFour.dart';
import 'package:prod_mode/screens/incomeCapture/incomeFreq.dart';
import 'package:intl/intl.dart';
import 'package:prod_mode/screens/incomeCapture/incomeOverview.dart';
import 'package:prod_mode/screens/incomeCapture/incomeThree.dart';

class IncomeThree extends StatefulWidget {
  double? userIncomeOne;
  String? incomeFrequency;

  double? userIncomeTwo;
  double? income3;
  double? income4;
  String? formattedFrequencyOne;
  DateTime? selectedDateOne;
  String? formattedFrequencyTwo;
  DateTime? selectedDateTwo;
  IncomeThree(
      {this.userIncomeOne,
      this.incomeFrequency,
      this.userIncomeTwo,
      this.income3,
      this.income4,
      this.formattedFrequencyOne,
      this.selectedDateOne,
      this.formattedFrequencyTwo,
      this.selectedDateTwo});

  @override
  State<IncomeThree> createState() => _IncomeThreeState(
      userIncomeOne,
      incomeFrequency,
      userIncomeTwo,
      income3,
      income4,
      formattedFrequencyOne,
      selectedDateOne,
      formattedFrequencyTwo,
      selectedDateTwo);
}

class _IncomeThreeState extends State<IncomeThree> {
  double? userIncomeOne;
  String? incomeFrequency;
  double? userIncomeTwo;
  double? income3;
  double? income4;
  bool? dateSelected = false;
  String? formattedFrequencyOne;
  DateTime? selectedDateOne;
  String? formattedFrequencyTwo;
  DateTime? selectedDateTwo;

  _IncomeThreeState(
      this.userIncomeOne,
      this.incomeFrequency,
      this.userIncomeTwo,
      this.income3,
      this.income4,
      this.formattedFrequencyOne,
      this.selectedDateOne,
      this.formattedFrequencyTwo,
      this.selectedDateTwo);

  String? incomeInput;
  TextEditingController _incomeController = TextEditingController();
  DateFormat format = DateFormat('E, MMM dd, yyyy');
  String? formattedDate;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * 1.0,
        height: MediaQuery.of(context).size.height * 1.0,
        color: AppTheme.colors.background,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SafeArea(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BHCTSh(
                            true,
                            'Make',
                            'Make more money',
                            AppTheme.colors.lavender750,
                            AppTheme.colors.lavender750,
                            false,
                            false,
                            false,
                            true,
                            false,
                            false,
                            false,
                            'Staying accountable'),

                        MS24(),

                        //description
                        BBRM14(
                            'We will start building your tailored financial plan based on your income details.',
                            AppTheme.colors.black,
                            6,
                            TextAlign.center),

                        SS36(),

                        //the input heading
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SH12('${incomeFrequency} income (3)',
                                AppTheme.colors.black, 1),
                          ],
                        ),
                        SS16(),
                        //the calendar picker
                        Row(
                          children: [
                            MonthlyCalendar(
                              primaryColor: AppTheme.colors.lavender750,
                              onDateSelected: (value) {
                                setState(() {
                                  dateSelected = true;
                                  print(dateSelected);
                                  formattedDate = value;
                                  selectedDate = format.parse(formattedDate!);
                                });
                              },
                              iconColor: AppTheme.colors.lavender750,
                              labelText:
                                  'Please select your third income date:',
                              colorscheme: ColorScheme.light(
                                  primary: AppTheme.colors.lavender500),
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          ],
                        ),
                        // the input field
                        MS24(),
                        MyCustomTextField(
                          inputLabelText: 'Please provide your income',
                          controller: _incomeController,
                          backgroundColor: AppTheme.colors.lavendar350,
                          hintText: 'income',
                          labelText: 'income',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                          onChanged: (value) {
                            incomeInput = value;
                            setState(() {
                              income3 = double.parse(incomeInput!);
                              print(incomeInput);
                            });
                          },
                        ),

                        LS72(),
                        //
                        (dateSelected! && income3 != 0)
                            ? NeonActiveButton('Next', () {
                                //based on the frequency we determine where to redirect them

                                //monthly

                                (incomeFrequency != 'Weekly')
                                    ? Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                IncomeOverview(
                                                  userIncomeOne: userIncomeOne,
                                                  incomeFrequency:
                                                      incomeFrequency,
                                                  userIncomeTwo: userIncomeTwo,
                                                  userIncomeFour: income4,
                                                  userIncomeThree: income3,
                                                )))
                                    : Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => IncomeFour(
                                                  userIncomeOne: userIncomeOne,
                                                  userIncomeTwo: userIncomeTwo,
                                                  incomeFrequency:
                                                      incomeFrequency,
                                                  selectedDateOne:
                                                      selectedDateOne,
                                                  selectedDateTwo: selectedDate,
                                                  formattedFrequencyOne:
                                                      formattedFrequencyOne,
                                                  formattedFrequencyTwo:
                                                      formattedDate,
                                                  formattedFrequencyThree:
                                                      formattedDate,
                                                  selectedDateThree:
                                                      selectedDate,
                                                  userIncomeThree: income3,
                                                  income4: income4,
                                                )));

                                //the rest
                              })
                            : DisabledRoundButton('Next', () {})
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
