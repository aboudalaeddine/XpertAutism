import 'package:flutter/material.dart';
import "package:hexcolor/hexcolor.dart";

@immutable
class Question extends StatelessWidget {
  final String textQuestion;

  const Question(this.textQuestion, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: SizedBox(
            width: 360,
            child: Text(textQuestion,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.black,
                ))));
  }
}
