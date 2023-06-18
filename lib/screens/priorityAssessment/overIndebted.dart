import 'package:astute_components/astute_components.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:prod_mode/screens/priorityAssessment/planSF.dart';
import 'package:prod_mode/services/authServices.dart';

class OverIndebtedChecklist extends StatefulWidget {
  @override
  State<OverIndebtedChecklist> createState() => _OverIndebtedChecklistState();
}

class _OverIndebtedChecklistState extends State<OverIndebtedChecklist> {
  String imageURl = auth.currentUser!.photoURL.toString();
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
                  BAHTSh(imageURl, false, false, true, 'Here is your focus',
                      'What you stand to gain?', true),

                  MS24(),

                  //description
                  BBRM14(
                      "Before proceeding with your financial priority, we are advising taking the following steps. These steps will be saved for your future reference.",
                      AppTheme.colors.black,
                      6,
                      TextAlign.center),
                  MS24(),

                  Divider(
                    color: AppTheme.colors.blue500,
                    height: 20,
                    thickness: 2,
                  ),

                  MS24(),

                  Row(
                    children: [
                      BBRS12('Here are the steps we recommend:',
                          AppTheme.colors.grey800, 1, TextAlign.left),
                    ],
                  ),

                  SS16(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BBRS12("1.", AppTheme.colors.black, 6, TextAlign.left),
                      SizedBox(width: 4),
                      Expanded(
                        child: BBRS12(
                          "Call all your creditors and ask for a rescheduling of the repayment of the loan over a longer period to reduce the installments.",
                          AppTheme.colors.black,
                          6,
                          TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  SS16(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BBRS12("2.", AppTheme.colors.black, 6, TextAlign.left),
                      SizedBox(width: 4),
                      Expanded(
                        child: BBRS12(
                            "Where you have suceesfully increased the term of your loan and reduced your debt installment make sure to update your debt details",
                            AppTheme.colors.black,
                            6,
                            TextAlign.left),
                      ),
                    ],
                  ),

                  LS56(),

                  NeonActiveButton('Next', () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PlanSFNoDebts()));
                  })
                ]),
              )
            ],
          ),
        )),
      ),
    );
  }
}
