import 'package:astute_components/astute_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prod_mode/homeFlow/testUpdate.dart';
import 'package:prod_mode/internalComponents.dart';
import 'package:intl/intl.dart';
import 'package:prod_mode/services/authServices.dart';

//the logic how to track the savings
//if status is started -> Not started
// time period = currentDate - startDate
// expectedContributions = timePeriod * Contributions
// amount saved = expectedContributions -> on track
//amount saved > expectedtContributions -> ahead
//amount saved < expectedContributions -> behind

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//income data
  CollectionReference userIncome = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('userIncomeDetails');

//savings data

  CollectionReference userSave = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('userSaveDetails');

//debt data
  CollectionReference userDebt = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('userDebtDetails');

  CollectionReference userLocation = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('userConfirmedDetails');

  String imageURl = auth.currentUser!.photoURL.toString();
  String? status = 'started';
  int? timePeriod = 0;
  double? priorityInstallment = 0;
  double? expectedAmount = 0;
  double? amountSaved = 0;
  double? totalamountSaved =
      0; //when scale up need to include the priroity debt alternative
  String? trackStatus = 'calculating';
  double totalIncome = 0;
  double totalDebtAmount = 0;
  double totalDebtInstallment = 0;
  double totalTargetAmounts = 0;
  double? priorityTarget = 0;
  String? endDateText = '';
  DateTime? startDate;
  Duration? duration;
  String? currency;
  String? location;
  String? formattedInstallment;
  double? disposableIncome;
  String? disposableIncomeformatted;

  @override
  void initState() {
    super.initState();
    getPriorityPlan();

    calculateTotalDebtAmount();
    calculateTotalDebtInstallmentAmount();
    calculateTotalTargetAmounts();
    getUserLocation();
    getIncomeDetails();
  }

// this will be updated to have a conditional statement the extraction will be based on the priority
  Future<void> getPriorityPlan() async {
    try {
      QuerySnapshot querySnapshot = await userSave.get();
      if (querySnapshot.size > 0) {
        // Assuming you want to read the value from the first document
        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

        // Access the desired field value
        dynamic targetValue = documentSnapshot.get('targetAmount');
        dynamic endValue = documentSnapshot.get('formattedEndDate');
        dynamic installmentValue = documentSnapshot.get('contributions');
        dynamic startValue = documentSnapshot.get('startDate').toDate();

        // Do something with the value

        setState(() {
          priorityTarget = targetValue;
          endDateText = endValue;
          priorityInstallment = installmentValue;
          startDate = startValue;
          formattedInstallment = priorityInstallment!.toStringAsFixed(2);
          print('this is the $startDate');

          if (status == 'started') {
            duration = startDate!.difference(DateTime.now());
            timePeriod = (duration!.inDays! / 30).ceil().toInt();
            expectedAmount = timePeriod! * priorityInstallment!;

            if (expectedAmount == amountSaved) {
              setState(() {
                trackStatus = 'on track';
                print('expected amount $expectedAmount');
                print('time period: $timePeriod');
                print('amount saved: $amountSaved');
              });
            } else {
              if (expectedAmount! > amountSaved!) {
                setState(() {
                  trackStatus = 'ahead of schedule';
                  print('expected amount $expectedAmount');
                  print('time period: $timePeriod');
                  print('amount saved: $amountSaved');
                });
              } else {
                setState(() {
                  trackStatus = 'behind';
                  print('expected amount $expectedAmount');
                  print('time period: $timePeriod');
                  print('amount saved: $amountSaved');
                });
              }
            }
          }
        });
      } else {
        print('No documents found in the collection');
      }
    } catch (error) {
      print('Error reading user details: $error');
    }
  }

  Future<void> calculateTotalDebtAmount() async {
    QuerySnapshot querySnapshot = await userDebt.get();
    double sum = 0;
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('debtAmount')) {
        sum += data['debtAmount'];
      }
    }
    setState(() {
      totalDebtAmount = sum;
    });
  }

  Future<void> calculateTotalDebtInstallmentAmount() async {
    QuerySnapshot querySnapshot = await userDebt.get();
    double sum = 0;
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('installment')) {
        sum += data['installment'];
      }
    }
    setState(() {
      totalDebtInstallment = sum;
    });
  }

  Future<void> calculateTotalTargetAmounts() async {
    QuerySnapshot querySnapshot = await userSave.get();
    double sum = 0;
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('targetAmount')) {
        sum += data['targetAmount'];
      }
    }
    setState(() {
      totalTargetAmounts = sum;
    });
  }

  //extraction of the currency

  Future<void> getUserLocation() async {
    try {
      QuerySnapshot querySnapshot = await userLocation.get();
      if (querySnapshot.size > 0) {
        // Assuming you want to read the value from the first document
        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

        // Access the desired field value
        dynamic fieldValue = documentSnapshot.get('userLocation');

        // Do something with the value
        print('Field Value: $fieldValue');
        setState(() {
          location = fieldValue;
          if (location == 'South Africa') {
            currency = 'ZAR';
            print(currency);
          } else {
            currency = 'USD';

            print(currency);
          }
        });
      } else {
        print('No documents found in the collection');
      }
    } catch (error) {
      print('Error reading user details: $error');
    }
  }

// the income extraction
  Future<void> getIncomeDetails() async {
    try {
      QuerySnapshot querySnapshot = await userIncome.get();
      if (querySnapshot.size > 0) {
        // Assuming you want to read the value from the first document
        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

        // Access the desired field value
        dynamic income = documentSnapshot.get('totalIncome');

        // Do something with the value

        setState(() {
          totalIncome = income;
          print('total $totalIncome');
        });
      } else {
        print('No documents found in the collection');
      }
    } catch (error) {
      print('Error reading user details: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    disposableIncome = totalIncome - priorityInstallment! - totalDebtAmount;
    //disposableIncomeformatted = disposableIncome!.toStringAsFixed(2);
    final disposableIncomeformatted =
        NumberFormat('#,##0.00').format(disposableIncome);
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CBButton(),
                      MS24(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          getCircleImage(imageURl),
                        ],
                      ),
                      MS24(),
                      BBLM14(
                        'Your focus: Building Starter savings fund',
                        AppTheme.colors.blue500,
                        1,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            color: AppTheme.colors.blue200,
                            child: Icon(
                              Icons.arrow_upward,
                              size: 12,
                              color: AppTheme.colors.green800,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'On track: 7 months to go',
                            style: GoogleFonts.montserrat(
                                fontStyle: FontStyle.italic,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.colors.blue500),
                          ),
                        ],
                      ),

                      MS24(),

                      // The saved amount v the target amount
                      TwoColumnLabel(
                        'Amount saved / Target amount',
                        '$currency $amountSaved / $currency $priorityTarget',
                        CrossAxisAlignment.start,
                      ),

                      SS16(),

                      // The information
                      TwoColumnLabel(
                        'Monthly savings',
                        '$currency $formattedInstallment',
                        CrossAxisAlignment.start,
                      ),

                      SS16(),
                      //the end date
                      TwoColumnLabel(
                        'Monthly savings',
                        '$endDateText', // this will be pulled and updated from the firebaseDb
                        CrossAxisAlignment.start,
                      ),

                      SS16(),

                      Divider(
                        color: AppTheme.colors.blue500,
                        height: 20,
                        thickness: 2,
                      ),

                      SS8(),

                      Container(
                        height: MediaQuery.of(context).size.height * 0.46,
                        child: Stack(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      BBLM14(
                                        'Your personal finances',
                                        AppTheme.colors.black,
                                        1,
                                      ),
                                    ],
                                  ),

                                  SS16(),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 1.0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 16.0,
                                        bottom: 16,
                                        left: 12.0,
                                        right: 12.00,
                                      ),
                                      child: Column(children: [
                                        BBBS12(
                                            '$currency $disposableIncomeformatted',
                                            AppTheme.colors.black,
                                            1,
                                            TextAlign.left),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        BBRS12(
                                            'what’s left after you pay yourself and your creditors.',
                                            AppTheme.colors.black,
                                            1,
                                            TextAlign.center)
                                      ]),
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.colors.blue200,
                                      border: Border.all(
                                        color: AppTheme.colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),

                                  //manage the savings
                                  SS16(),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 1.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppTheme.colors.blue500,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12.0,
                                          right: 12.00,
                                          top: 4,
                                          bottom: 22),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                SmallView(Icons.arrow_forward,
                                                    'manage savings', () {}),
                                              ],
                                            ),
                                            BBBS12(
                                                'Total saved amount: $currency $amountSaved',
                                                AppTheme.colors.black,
                                                1,
                                                TextAlign.left),
                                            SS8(),
                                            BBBS12(
                                                'Total target amount: $currency $totalTargetAmounts',
                                                AppTheme.colors.black,
                                                1,
                                                TextAlign.left),
                                          ]),
                                    ),
                                  ),
                                  //manage the debts
                                  SS16(),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 1.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppTheme.colors.blue500,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12.0,
                                          right: 12.00,
                                          top: 4,
                                          bottom: 22),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                SmallView(Icons.arrow_forward,
                                                    'manage debts', () {}),
                                              ],
                                            ),
                                            BBBS12(
                                                //need to update with correct value
                                                'Total paid off ZAR $currency $amountSaved',
                                                AppTheme.colors.black,
                                                1,
                                                TextAlign.left),
                                            SS8(),
                                            BBBS12(
                                                'Total debts: $currency $totalDebtAmount',
                                                AppTheme.colors.black,
                                                1,
                                                TextAlign.left),
                                          ]),
                                    ),
                                  ),
                                  //
                                  SS36(),
                                ],
                              ),
                            ),

                            //the navigation bar
                            CustomNavigation(isHome: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
