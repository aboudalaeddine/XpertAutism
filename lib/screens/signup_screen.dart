import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpert_autism/screens/listenfant_screen.dart';

import '../reusable_widgets/reusable_widget.dart';
import '../utils/color_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _nomParentTextController = TextEditingController();
  TextEditingController _prenomParentTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "S'inscrire",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
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
                          reusableTextField("Entrer votre nom", Icons.person,
                              false, _nomParentTextController),
                          const SizedBox(
                            height: 20,
                          ),
                          reusableTextField("Entrer votre prenom", Icons.person,
                              false, _prenomParentTextController),
                          const SizedBox(
                            height: 20,
                          ),
                          reusableTextField("Entrer votre e mail", Icons.person,
                              false, _emailTextController),
                          const SizedBox(
                            height: 20,
                          ),
                          reusableTextField(
                              "Entrer votre mot de passe",
                              Icons.lock_outline,
                              true,
                              _passwordTextController),
                          const SizedBox(
                            height: 20,
                          ),
                          signInSignUpButton(context, false, () {
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: _emailTextController.text,
                                    password: _passwordTextController.text)
                                .then((value) {
                              FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(value.user!.email)
                                  .set({
                                'nomParent': _nomParentTextController.text,
                                'prenomParent':
                                    _prenomParentTextController.text,
                                'typeUtilisateur': "parent"
                              });
                              print("Le compte d'utilisateur est crée");

                              Navigator.push(
                                  context,
                                  // ignore: prefer_const_constructors
                                  MaterialPageRoute(
                                      builder: ((context) => const MyAppEnf(
                                            typeUtilisateur: 'parent',
                                          ))));
                            }).onError((error, stackTrace) {
                              print("error ${error.toString()}");
                            });
                          }),
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
}
