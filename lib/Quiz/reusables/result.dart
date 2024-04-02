import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpert_autism/Quiz/reusables/question.dart';
import '../../screens/listenfant_screen.dart';
import 'package:hexcolor/hexcolor.dart';

class Result extends StatelessWidget {
  final double resultScore;
  final String prenomEnfant;
  final VoidCallback resetHandler;

  const Result(this.resultScore, this.prenomEnfant, this.resetHandler, {Key? key}) : super(key: key);

  String get resultPhrase {
    String resultText;

    final score = num.parse(resultScore.toStringAsFixed(2));

    resultText =
        'Votre demande a été envoyée avec succès. \nUne décision vous sera communiquée par email.';

    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: SizedBox(
                      width: 360,
                      child: Question(
                        resultPhrase,
                      ),
                    )),
                ElevatedButton(
                    child: SizedBox(
                      width: 200,
                      child: Text(
                        'OK',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: HexColor("#FEFEFE"),
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(HexColor("#FF03A9F4"))),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser!.email)
                          .collection('Enfants')
                          .doc(prenomEnfant)
                          .update({'score': resultScore});
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const MyAppEnf(
                                    typeUtilisateur: 'parent',
                                  ))));
                    })
              ],
            )));
  }
}
