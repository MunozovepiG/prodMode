import 'package:astute_components/astute_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final TextEditingController _userNameController = TextEditingController();
  bool isEditing = false;

  final CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('userConfirmedDetails');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppTheme.colors.background,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    children: [
                      CBButton(),
                      Text('The profile page'),
                    ],
                  ),
                ),
                Container(
                  child: FutureBuilder<QuerySnapshot>(
                    future: ref.get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      final List<Map<dynamic, dynamic>> debtDetails = [];
                      if (snapshot.hasData) {
                        snapshot.data!.docs.forEach((document) {
                          Map<dynamic, dynamic> a =
                              document.data() as Map<dynamic, dynamic>;
                          a['id'] = document.id;
                          debtDetails.add(a);
                        });
                      }

                      if (debtDetails.isNotEmpty) {
                        final Map<dynamic, dynamic> data = debtDetails.first;
                        _userNameController.text = data['userName'];

                        return Column(
                          children: [
                            TextField(
                              controller: _userNameController,
                              enabled: isEditing,
                              decoration: InputDecoration(
                                labelText: 'User Name',
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (isEditing) {
                                    ref.doc(data['id']).update({
                                      'userName': 'Muno',
                                    });
                                  }
                                  isEditing = !isEditing;
                                });
                              },
                              child: Text(isEditing ? 'Save' : 'Edit'),
                            ),
                          ],
                        );
                      } else {
                        return Text('No data found.');
                      }
                    },
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
