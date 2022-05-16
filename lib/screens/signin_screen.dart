import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:xpert_autism/reusable_widgets/reusable_widget.dart';
import 'package:xpert_autism/screens/listenfant_screen.dart';
import 'package:xpert_autism/screens/signup_screen.dart';
import 'package:xpert_autism/utils/color_utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringTocolor("0000FF"),
              hexStringTocolor("0000CD"),
              hexStringTocolor("00008B")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.blue,
              boxShadow: const [
                BoxShadow(color: Colors.white, blurRadius: 20.0),
              ],
            ),
            child: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.2, 20, 0),
              child: Column(
                children: <Widget>[
                  logoWidget("assets/images/logo.png", 240, 240),
                  const SizedBox(
                    height: 30,
                  ),
                  reusableTextField("Entrer votre e mail", Icons.person, false,
                      _emailTextController),
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Entrer votre mot de passe",
                      Icons.lock_outline, true, _passwordTextController),
                  const SizedBox(
                    height: 20,
                  ),
                  signInSignUpButton(context, true, () {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text)
                        .then((value) async {
                      var monTypeUtilisateur = await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser?.email)
                          .get()
                          .then((value) {
                        return value.data()!['typeUtilisateur'];
                      });

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyAppEnf(
                                  typeUtilisateur: monTypeUtilisateur)));
                    }).onError((error, stackTrace) {
                      print("error ${error.toString()}");
                    });
                  }),
                  signUpOption()
                ],
              ),
            )),
          )),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("vous n'avez pas un compte?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " s'inscrire",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
