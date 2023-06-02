import 'package:astute_components/astute_components.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

class NameConfirmation extends StatelessWidget {
  const NameConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BHCTSh(
                true,
                'Make',
                'secondary text',
                AppTheme.colors.orange800,
                AppTheme.colors.orange500,
                false,
                false,
                false,
                true,
                false,
                false,
                false),
            Text('Very slowly does a hot load ')
          ]),
    );
  }
}
