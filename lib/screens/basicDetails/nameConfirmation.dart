import 'package:astute_components/astute_components.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:prod_mode/services/authServices.dart';

class NameConfirmation extends StatefulWidget {
  @override
  State<NameConfirmation> createState() => _NameConfirmationState();
}

class _NameConfirmationState extends State<NameConfirmation> {
  final userName = auth.currentUser?.displayName.toString();
  bool trueName = false;
  TextEditingController nameController = TextEditingController();
  String updatedName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BAHTSh(
                'https://picsum.photos/seed/picsum/200/300',
                true,
                false,
                false,
                'Let’s get started',
                'Can we call you ${userName} ?',
                false),
            SS16(),
            SS8(),
            //the CTAs
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MediumMainButton(text: 'Yes', onPressed: () {}),
                SizedBox(
                  width: 24,
                ),
                MediumMainButton(
                    text: 'No',
                    onPressed: () {
                      setState(() {
                        trueName = true;
                        print(trueName);
                      });
                    }),
              ],
            ),

            //the text editor

            if (trueName)
              Column(
                children: [
                  SS36(),
                  MyCustomTextField(
                    controller: nameController,
                    backgroundColor: AppTheme.colors.blue200,
                    inputLabelText:
                        'We want to get to know you better, what is your preferred name?',
                    hintText: 'Name and Surname',
                    onChanged: (value) {
                      setState(() {
                        updatedName = value;
                        print(updatedName);
                      });
                    },
                  ),
                  LS72(),
                  //the active buttion

                  (updatedName.length > 3)
                      ? NeonActiveButton('Save', () {})
                      : DisabledRoundButton('Save', () {})
                ],
              )
          ]),
    );
  }
}
