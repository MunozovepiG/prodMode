import 'package:astute_components/astute_components.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prod_mode/screens/incomeCapture/incomeOverview.dart';
import 'package:prod_mode/screens/incomeCapture/incomeTwo.dart';

class IncomeOne extends StatefulWidget {
  String? incomeFrequency;

  IncomeOne({this.incomeFrequency});
  @override
  State<IncomeOne> createState() => _IncomeOneState(incomeFrequency);
}

class _IncomeOneState extends State<IncomeOne> {
  String? incomeFrequency;

  TextEditingController _incomeController = TextEditingController();

  String? incomeInput;
  double? income1 = 0;
  double? income2 = 0;
  double? income3 = 0;
  double? income4 = 0;
  _IncomeOneState(this.incomeFrequency);
  DateTime currentDate = DateTime.now();
  DateFormat format = DateFormat('E, MMM dd, yyyy');
  String? formattedDate;
  DateTime? selectedDate;
  bool dateSelected = false;
  @override
  Widget build(BuildContext context) {
    DateTime? firstDate = DateTime(currentDate.year, currentDate.month);
    DateTime? lastDate = DateTime(currentDate.year, currentDate.month + 1, 0);

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
                        //heading
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
                            SH12('${incomeFrequency} income (1)',
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
                                });
                              },
                              iconColor: AppTheme.colors.lavender750,
                              labelText:
                                  'Please select your first income date:',
                              colorscheme: ColorScheme.light(
                                  primary: AppTheme.colors.lavender500),
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          ],
                        ),
                        // the input field
                        MS24(),
                        MyCustomTextField(
                          inputLabelText: 'Please provide your email',
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
                              income1 = double.parse(incomeInput!);
                              print(incomeInput);
                            });
                          },
                        ),

                        LS72(),
                        //
                        (dateSelected && income1! > 0 && income1! != null)
                            ? NeonActiveButton('Next', () {
                                //based on the frequency we determine where to redirect them

                                //monthly

                                (incomeFrequency == 'Monthly')
                                    ? Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                IncomeOverview(
                                                  userIncomeOne: income1,
                                                  userIncomeTwo: income2,
                                                  userIncomeThree: income3,
                                                  userIncomeFour: income4,
                                                  incomeFrequency:
                                                      incomeFrequency,
                                                )))
                                    : Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => IncomeTwo(
                                                  userIncomeOne: income1,
                                                  income2: income2,
                                                  income3: income3,
                                                  income4: income4,
                                                  incomeFrequency:
                                                      incomeFrequency,
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
