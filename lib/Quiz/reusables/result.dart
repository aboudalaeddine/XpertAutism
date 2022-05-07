import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:xpert_autism/Quiz/reusables/question.dart';
import '../../screens/listenfant_screen.dart';
import 'package:hexcolor/hexcolor.dart';

class Result extends StatelessWidget {
  final double resultScore;
  final VoidCallback resetHandler;

  Result(this.resultScore, this.resetHandler);

  String get resultPhrase {
    String resultText;
    final score = num.parse(resultScore.toStringAsFixed(2));
    if (score <= 10.00) {
      resultText =
          'You tried it and scored $score points 🤎! \n Want to try again?';
    } else if (score > 15.00 && score <= 25.00) {
      resultText =
          'You did it and scored $score points 🤎! \n Want to try again?';
    } else if (score > 25.00 && score <= 40.00) {
      resultText =
          'You got it and scored $score points 🤎! \n Want to try again?';
    } else {
      resultText =
          'You nailed it and scored $score points 🤎! \n Want to try again?';
    }

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
                            MaterialStateProperty.all(HexColor("#915C53"))),
                    onPressed: () {
                      /*FirebaseFirestore.instance
                        .collection('Users')
                        .doc(FirebaseAuth.instance.currentUser!.email)
                        .collection('Enfants')
                        .doc(prenomEnfant)
                        .set({'score': resultScore});*/
                      Navigator.push(
                          context,
                          // ignore: prefer_const_constructors
                          MaterialPageRoute(
                              builder: ((context) => const MyAppEnf(
                                    typeUtilisateur: 'parent',
                                  ))));
                    })
              ],
            )));
  }
}
