//can later add these to the astute package

//row label 14 font -
import 'package:astute_components/astute_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class RowLabel extends StatelessWidget {
  String description;
  String amount;

  RowLabel(this.description, this.amount);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BBRM14(description, AppTheme.colors.black, 6, TextAlign.center),
        BBRM14(amount, AppTheme.colors.black, 6, TextAlign.center),
      ],
    );
  }
}
