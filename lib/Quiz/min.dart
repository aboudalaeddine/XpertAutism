import "package:flutter/material.dart";
import "package:hexcolor/hexcolor.dart";
import 'package:xpert_autism/Quiz/reusables/result.dart';
import './quiz.dart';

class MyAppY extends StatefulWidget {
  const MyAppY({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

void main() {
  runApp(const MyAppY());
}

class _MyAppState extends State<MyAppY> {
  static const _data = [
    {
      'questionText': 'Votre enfant possède-t-il des habitudes inappropriées?',
      'answers': [
        {'text': 'Jamais', 'score': 9.73},
        {'text': 'Parfois', 'score': 4.61},
        {'text': 'Souvent', 'score': 1.95},
        {'text': 'Très souvent', 'score': 0.00},
      ]
    },
    {
      'questionText': "Votre enfant joue-t-il avec d'autres enfants?",
      'answers': [
        {'text': 'Jamais', 'score': 2.3},
        {'text': 'Parfois', 'score': 0.32},
        {'text': 'Souvent', 'score': 3.00},
        {'text': 'Très souvent', 'score': 9.98},
      ]
    },
    {
      'questionText':
          'Votre enfant répète plusieurs mots ou gestes dans une boucle?',
      'answers': [
        {'text': 'Jamais', 'score': 0.64},
        {'text': 'Parfois', 'score': 10.00},
        {'text': 'Souvent', 'score': 3.28},
        {'text': 'Très souvent', 'score': 1.02}
      ]
    },
    {
      'questionText': 'Votre enfant refuse certains aliments ?',
      'answers': [
        {'text': 'Jamais', 'score': 0.12},
        {'text': 'Parfois', 'score': 2.13},
        {'text': 'Souvent', 'score': 6.42},
        {'text': 'Très souvent', 'score': 9.99}
      ]
    },
    {
      'questionText': 'Votre enfant refuse certains couleurs ?',
      'answers': [
        {'text': 'Jamais', 'score': 5.53},
        {'text': 'Parfois', 'score': 10.00},
        {'text': 'Souvent', 'score': 2.47},
        {'text': 'Très souvent', 'score': 2.35}
      ]
    },
    {
      'questionText':
          "Votre enfant éprouve-t-il une grande angoisse face à l'imprévu ou à tout ce qui en découle?",
      'answers': [
        {'text': 'Jamais', 'score': 5.53},
        {'text': 'Parfois', 'score': 10.00},
        {'text': 'Souvent', 'score': 2.47},
        {'text': 'Très souvent', 'score': 2.35}
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
          backgroundColor: HexColor("#C9B3AF"),
          appBar: AppBar(
            title: Align(
              alignment: Alignment.center,
              child: Text(
                "Fluttery",
                style: TextStyle(
                  color: HexColor("#F5FFF0"),
                ),
              ),
            ),
            backgroundColor: HexColor("#6B443D"),
          ),
          body: Align(
              alignment: Alignment.center,
              child: (_indexQuestion <= 5 && _indexQuestion >= 0)
                  ? Quiz(
                      answerQuestion: _answerQuestion,
                      indexQuestion: _indexQuestion,
                      data: _data)
                  : Result(_totalScore, _ok))),
    );
  }
}
