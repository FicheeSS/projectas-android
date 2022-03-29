import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:testiut/main.dart';

class LoginScreen extends StatefulWidget {
  late User _user;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _userLoginFormKey = GlobalKey();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isSignIn = false;
  bool google = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:150 ,
      width: MediaQuery.of(context).size.width/ 3 ,
      child: InkWell(
        child: Center(
            child: Container(
                width : MediaQuery.of(context).size.width/ 3,
                height: 150,
                margin: const EdgeInsets.only(top: 25),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 30.0,
                      width: 30.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/google.png'),
                            fit: BoxFit.cover),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Text(
                      'Sign in with Google',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ))),
        onTap: () async {
          signInWithGoogle()
              .then((e) => {print("yeah")})
              .catchError((error) => {print(error)});
        },
      ),
    );
  }

  Future<User> signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    var authResult = await _auth.signInWithCredential(credential);

    widget._user = authResult.user!;

    assert(!widget._user.isAnonymous);

    assert(await widget._user.getIdToken() != null);

    User currentUser = await _auth.currentUser!;

    assert(widget._user.uid == currentUser.uid);

    print("User Name: ${widget._user.displayName}");
    print("User Email ${widget._user.email}");
    print("User uid ${widget._user.uid}");
    return currentUser;
  }
}
