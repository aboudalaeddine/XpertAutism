import "package:flutter/material.dart";
import "package:hexcolor/hexcolor.dart";
import 'package:xpert_autism/Quiz/reusables/result.dart';
import './quiz.dart';

class MyAppY extends StatefulWidget {
  final String prenomEnfant;
  const MyAppY({Key? key, required this.prenomEnfant}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyAppY> {
  static const _data = [
    {
      'questionText': 'Votre enfant possède-t-il des habitudes inappropriées?',
      'answers': [
        {'text': 'Jamais', 'score': 1.00},
        {'text': 'Parfois', 'score': 2.00},
        {'text': 'Souvent', 'score': 3.00},
        {'text': 'Très souvent', 'score': 4.00},
      ]
    },
    {
      'questionText': "Votre enfant joue-t-il avec d'autres enfants?",
      'answers': [
        {'text': 'Jamais', 'score': 1.00},
        {'text': 'Parfois', 'score': 2.00},
        {'text': 'Souvent', 'score': 3.00},
        {'text': 'Très souvent', 'score': 4.00},
      ]
    },
    {
      'questionText':
          'Votre enfant répète plusieurs mots ou gestes dans une boucle?',
      'answers': [
        {'text': 'Jamais', 'score': 1.00},
        {'text': 'Parfois', 'score': 2.00},
        {'text': 'Souvent', 'score': 3.00},
        {'text': 'Très souvent', 'score': 4.00}
      ]
    },
    {
      'questionText': 'Votre enfant refuse certains aliments ?',
      'answers': [
        {'text': 'Jamais', 'score': 1.00},
        {'text': 'Parfois', 'score': 2.00},
        {'text': 'Souvent', 'score': 3.00},
        {'text': 'Très souvent', 'score': 4.00}
      ]
    },
    {
      'questionText': 'Votre enfant refuse certains couleurs ?',
      'answers': [
        {'text': 'Jamais', 'score': 1.00},
        {'text': 'Parfois', 'score': 2.00},
        {'text': 'Souvent', 'score': 3.00},
        {'text': 'Très souvent', 'score': 4.00}
      ]
    },
    {
      'questionText':
          "Votre enfant éprouve-t-il une grande angoisse face à l'imprévu ou à tout ce qui en découle?",
      'answers': [
        {'text': 'Jamais', 'score': 1.00},
        {'text': 'Parfois', 'score': 2.00},
        {'text': 'Souvent', 'score': 3.00},
        {'text': 'Très souvent', 'score': 4.00}
      ]
    }
  ];

  var _indexQuestion = 0;
  double _totalScore = 0.00;
  void _answerQuestion(double score) {
    _totalScore += score;

    setState(() {
      _indexQuestion += 1;
    });
  }

  void _ok() {
    setState(() {
      _indexQuestion = 0;
      _totalScore = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: HexColor("#FFFFFF"),
          appBar: AppBar(
            title: Align(
              alignment: Alignment.center,
              child: Text(
                "Les questions",
                style: TextStyle(
                  color: HexColor("#F5FFF0"),
                ),
              ),
            ),
            backgroundColor: HexColor("#FF2196F3"),
          ),
          body: Align(
              alignment: Alignment.center,
              child: (_indexQuestion <= 5 && _indexQuestion >= 0)
                  ? Quiz(
                      answerQuestion: _answerQuestion,
                      indexQuestion: _indexQuestion,
                      data: _data)
                  : Result(_totalScore, widget.prenomEnfant, _ok))),
    );
  }
}
