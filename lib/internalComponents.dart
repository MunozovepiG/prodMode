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

class TwoColumnLabel extends StatelessWidget {
  String description;
  String content;
  CrossAxisAlignment cross;

  TwoColumnLabel(this.description, this.content, this.cross);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: cross,
      children: [
        BBRS12(description, AppTheme.colors.black, 1, TextAlign.left),
        SS8(),
        BBLM14(content, AppTheme.colors.black, 1)
      ],
    );
  }
}

//the bottom navigation

class CustomNavigation extends StatefulWidget {
  bool? isHome;

  CustomNavigation({this.isHome});

  @override
  State<CustomNavigation> createState() => _CustomNavigationState(isHome);
}

class _CustomNavigationState extends State<CustomNavigation> {
  bool? isHome;

  _CustomNavigationState(this.isHome);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        child: Container(
          height: 44,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
              color: Colors.white,
              // Color.fromRGBO(255, 255, 255, 0.85),
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.white, width: 1.0)),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8.0, left: 10, right: 10, bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    (isHome!)
                        ? Icon(
                            Icons.home,
                            color: AppTheme.colors.blue500,
                          )
                        : Icon(
                            Icons.home_outlined,
                            color: AppTheme.colors.blue500,
                          ),
                    SizedBox(
                      width: 4,
                    ),
                    BBBS12('Home', AppTheme.colors.blue500, 1, TextAlign.left),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

//modified to specifiy route
class MCBButton extends StatelessWidget {
  final VoidCallback onPressed;

  MCBButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: [
          Icon(
            Icons.arrow_back,
            size: 14,
          ),
          SizedBox(
            width: 4,
          ),
          PLS10('Back', Colors.black, 1)
        ],
      ),
      onTap: onPressed,
    );
  }
}

//the new tracking heading

class UPTrackingHeading extends StatelessWidget {
  final Color color;
  final String heading;
  final String description;
  final VoidCallback onPressed;

  UPTrackingHeading(this.color, this.heading, this.description, this.onPressed);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SS36(),
        MCBButton(onPressed: onPressed),
        SS16(),
        BBLM14(heading, color, 1),
        BB10(description, color, 1, TextAlign.left),
      ]),
    );
  }
}
