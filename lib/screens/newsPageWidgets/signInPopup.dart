import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../service/database.dart';
import '../../service/auth.dart';

class SignInPopup extends StatefulWidget {
  String title;
  SignInPopup({required this.title});

  @override
  _SignInPopupState createState() => _SignInPopupState();
}

class _SignInPopupState extends State<SignInPopup> {
  bool _isSigningIn = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _isSigningIn
                ? Center(
                    child: SpinKitCircle(
                    color: Colors.black,
                    size: 50.0,
                  ))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'You need to Sign In before '+ widget.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        height: 50,
                        child: OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              _isSigningIn = true;
                            });
                            User? user = await AuthServices.signInWithGoogle(
                                context: context);

                            if (this.mounted) {
                              setState(() {
                                _isSigningIn = false;
                              });
                            }

                            if (user != null) {
                              // Navigator.of(context).pushReplacement(
                              //   MaterialPageRoute(
                              //     builder: (context) => UserInfoScreen(
                              //       user: user,
                              //     ),
                              //   ),
                              // );
                            }
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image(
                                  image: AssetImage("assets/google_logo.png"),
                                  height: 35.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Sign in with Google',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          )),
    );
  }
}
