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
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/backgroundtt.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(children: <Widget>[
        Center(
          child: Container(
            width: 8 * MediaQuery.of(context).size.width / 10,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 20.0,
                ),
              ],
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.02,
                      MediaQuery.of(context).size.height * 0.02,
                      MediaQuery.of(context).size.width * 0.02,
                      MediaQuery.of(context).size.height * 0.02),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Entrer votre e mail", Icons.person,
                          false, _emailTextController),
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
                          var monTypeUtilisateur = await FirebaseFirestore
                              .instance
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
                ),
              ),
            ),
          ),
        )
      ]),
    ));
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "vous n'avez pas un compte?",
          style: TextStyle(color: Color.fromARGB(255, 80, 80, 80)),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " s'inscrire",
            style: TextStyle(
                color: Color.fromARGB(255, 80, 80, 80),
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
