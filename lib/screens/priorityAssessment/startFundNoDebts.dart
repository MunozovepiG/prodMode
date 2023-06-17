import 'package:astute_components/astute_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:prod_mode/screens/priorityAssessment/planStartFundNoDebt.dart';
import 'package:prod_mode/services/authServices.dart';

class PriorityAssessment extends StatefulWidget {
  String? name;

  PriorityAssessment({this.name});
//will need to make sure that the persisted data does note get lost

  @override
  State<PriorityAssessment> createState() => _PriorityAssessmentState(name);
}

class _PriorityAssessmentState extends State<PriorityAssessment> {
  String? name;

  _PriorityAssessmentState(this.name);

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
                      'Focus on your priority', true),

                  MS24(),

                  //description
                  BBRM14(
                      "Hi ${name}, we have done an assessment of your finances based on the information provided. Based on our analysis it is best that you focus on building your emergency fund.",
                      AppTheme.colors.black,
                      6,
                      TextAlign.center),

                  LS72(),
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
