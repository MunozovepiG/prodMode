import 'package:astute_components/astute_components.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:prod_mode/screens/basicDetails/dOBConfirmation.dart';
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BAHTSh(imageURl, true, false, false, 'Let’s get started',
                      'Can we call you ${userName} ?', false),
                  SS16(),
                  SS8(),
                  //the CTAs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MediumMainButton(
                          text: 'Yes',
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    DOBConfirmation(correctName: userName)));
                          }),
                      SizedBox(
                        width: 24,
                      ),
                      MediumMainButton(
                          text: 'No',
                          onPressed: () {
                            setState(() {
                              trueName = true;
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
                            ? NeonActiveButton('Save', () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DOBConfirmation(
                                        correctName: updatedName)));
                              })
                            : DisabledRoundButton('Save', () {})
                      ],
                    )
                ]),
          ),
        ),
      ),
    );
  }
}
