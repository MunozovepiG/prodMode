import 'package:astute_components/astute_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:prod_mode/screens/basicDetails/userLocation.dart';
import 'package:prod_mode/services/authServices.dart';
import 'package:intl/intl.dart';

class DOBConfirmation extends StatefulWidget {
  String? correctName;

  DOBConfirmation({required this.correctName});

  @override
  State<DOBConfirmation> createState() => _DOBConfirmationState(correctName);
}

class _DOBConfirmationState extends State<DOBConfirmation> {
  String? correctName;
  String imageURl = auth.currentUser!.photoURL.toString();
  String? selectedDate = '';
  DateFormat format = DateFormat('E, MMM dd, yyyy');
  DateTime currentDate = DateTime.now();

  _DOBConfirmationState(this.correctName);

  @override
  Widget build(BuildContext context) {
    DateTime convertedDate;

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * 1.0,
        height: MediaQuery.of(context).size.height * 1.0,
        color: AppTheme.colors.background,
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
                      // the heading
                      BAHTSh(imageURl, true, false, false, 'Hi ${correctName}',
                          'It is great to be on a first name basis.', true),
                      MS24(),

//description
                      BBRM14(
                          'We value your relationship with us and want to make sure we keep you informed and up-to-date on the things that matter most to you - from reaching your financial goals to celebrating your birthday.',
                          AppTheme.colors.black,
                          6,
                          TextAlign.center),

                      MS24(),

                      //the calendar CTA

                      SH12('What day is your birthday?', AppTheme.colors.black,
                          1),

                      SS16(),

                      CustomDatePicker(
                          intialDate: currentDate
                              .subtract(const Duration(days: 14 * 365)),
                          maxDate: currentDate
                              .subtract(const Duration(days: 14 * 365)),
                          minDate: currentDate
                              .subtract(const Duration(days: 90 * 365)),
                          primaryColor: AppTheme.colors.blue500,
                          onDateSelected: (date) {
                            setState(() {
                              selectedDate = date;
                              print(date);

                              convertedDate = format.parse(selectedDate!);
                              print(convertedDate);
                            });
                          },
                          colorscheme: ColorScheme.light(
                              primary: AppTheme.colors.blue500),
                          iconColor: AppTheme.colors.blue500,
                          labelText: 'Please selct a date'),

                      LS72(),
                      //the next button

                      selectedDate!.isNotEmpty
                          ? NeonActiveButton('Next', () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LocationConfirmation(
                                        correctName,
                                        selectedDate,
                                      )));
                            })
                          : DisabledRoundButton('Next', () {})
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
