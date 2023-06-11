import 'package:astute_components/astute_components.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

class PriorityAssessment extends StatefulWidget {
  const PriorityAssessment({super.key});

  @override
  State<PriorityAssessment> createState() => _PriorityAssessmentState();
}

class _PriorityAssessmentState extends State<PriorityAssessment> {
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
                  CBButton(),
                ]),
              )
            ],
          ),
        )),
      ),
    );
  }
}
