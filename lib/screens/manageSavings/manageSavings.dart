import 'package:astute_components/astute_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ManageSavings extends StatefulWidget {
  const ManageSavings({super.key});

  @override
  State<ManageSavings> createState() => _ManageSavingsState();
}

class _ManageSavingsState extends State<ManageSavings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [CBButton(), Text('example')]),
    );
  }
}
