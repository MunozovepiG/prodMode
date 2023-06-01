import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:prod_mode/screens/landing.dart';
import 'package:prod_mode/screens/nameConfirmation.dart';

GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;
CollectionReference users = FirebaseFirestore.instance.collection('users');
var error = '';
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

void signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      final UserCredential authResult =
          await auth.signInWithCredential(credential);

      final User? user = authResult.user;

      var userData = {
        'name': googleSignInAccount.displayName,
        'provider': 'google',
        'photoUrl': googleSignInAccount.photoUrl,
        'email': googleSignInAccount.email,
      };

      users.doc(user?.uid).get().then((doc) {
        if (doc.exists) {
          // existing user
          doc.reference.update(userData);

          //the navogation is noe managed by getdocs flow

          // Navigator.of(context).pushReplacement(
          // MaterialPageRoute(
          // builder: (context) => NameConfirmation(),
          //  ),
          // );
        } else {
          // new user

          users.doc(user?.uid).set(userData);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => NameConfirmation(),
            ),
          );
        }
      });
    }
  } catch (PlatformException) {
    print(' this is the error $PlatformException.message');
    error = '$PlatformException.message';

    // better show an alert here
  }
}

void signOutGoogle(BuildContext context) async {
  await googleSignIn.signOut();
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => LandingScreen(),
    ),
  );
  print("User Sign Out");
}

getProfileImage() {
  if (auth.currentUser?.photoURL != null) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(auth.currentUser!.photoURL.toString()),
        ),
        shape: BoxShape.circle,
      ),
    );
  } else
    Text('We had a problem loading your profile picture');
}

getUserName() {
  if (auth.currentUser?.displayName != null) {
    return Text(auth.currentUser!.displayName.toString(),
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ));
  } else
    Text('We had a problem loading your profile picture');
}
