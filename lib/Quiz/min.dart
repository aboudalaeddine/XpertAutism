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
      'questionText': 'Votre enfant est isolé ?',
      'answers': [
        {'text': 'Jamais', 'score': 1.00},
        {'text': 'Parfois', 'score': 2.00},
        {'text': 'Souvent', 'score': 3.00},
        {'text': 'Très souvent', 'score': 4.00}
      ]
    },
    {
      'questionText':
          "enfant trouve-t-il difficile d'exprimer ce qu'il ressent?",
      'answers': [
        {'text': 'Jamais', 'score': 1.00},
        {'text': 'Parfois', 'score': 2.00},
        {'text': 'Souvent', 'score': 3.00},
        {'text': 'Très souvent', 'score': 4.00}
      ]
    },
    {
      'questionText': "Votre enfant répond-il à son nom lorsqu’il est appelé?",
      'answers': [
        {'text': 'Jamais', 'score': 1.00},
        {'text': 'Parfois', 'score': 2.00},
        {'text': 'Souvent', 'score': 3.00},
        {'text': 'Très souvent', 'score': 4.00}
      ]
    },
    {
      'questionText':
          "Votre enfant maintient-il un contact visuel lorsqu’on lui parle?",
      'answers': [
        {'text': 'Jamais', 'score': 1.00},
        {'text': 'Parfois', 'score': 2.00},
        {'text': 'Souvent', 'score': 3.00},
        {'text': 'Très souvent', 'score': 4.00}
      ]
    },
    {
      'questionText':
          "Votre enfant partage-t-il ses intérêts avec vous et imite-t-il vos intérêts?",
      'answers': [
        {'text': 'Jamais', 'score': 1.00},
        {'text': 'Parfois', 'score': 2.00},
        {'text': 'Souvent', 'score': 3.00},
        {'text': 'Très souvent', 'score': 4.00}
      ]
    },
    {
      'questionText':
          "Votre enfant fait-il semblant de jouer ou utilise-t-il son imagination?",
      'answers': [
        {'text': 'Jamais', 'score': 1.00},
        {'text': 'Parfois', 'score': 2.00},
        {'text': 'Souvent', 'score': 3.00},
        {'text': 'Très souvent', 'score': 4.00}
      ]
    },
    {
      'questionText':
          "Votre enfant vous regarde lorsque vous appelez son nom ?",
      'answers': [
        {'text': 'Jamais', 'score': 1.00},
        {'text': 'Parfois', 'score': 2.00},
        {'text': 'Souvent', 'score': 3.00},
        {'text': 'Très souvent', 'score': 4.00}
      ]
    },
    {
      'questionText':
          "Lorsque vous conversez, est-il facile de maintenir un contact visuel avec votre enfant?",
      'answers': [
        {'text': 'Jamais', 'score': 1.00},
        {'text': 'Parfois', 'score': 2.00},
        {'text': 'Souvent', 'score': 3.00},
        {'text': 'Très souvent', 'score': 4.00}
      ]
    },
    {
      'questionText':
          "Lorsque votre enfant est confronté à une situation inconnue, vous regarde-t-il spontanément?",
      'answers': [
        {'text': 'Jamais', 'score': 1.00},
        {'text': 'Parfois', 'score': 2.00},
        {'text': 'Souvent', 'score': 3.00},
        {'text': 'Très souvent', 'score': 4.00}
      ]
    },
    {
      'questionText':
          "Les autres peuvent-ils comprendre ce que votre enfant essaie de dire?",
      'answers': [
        {'text': 'Jamais', 'score': 1.00},
        {'text': 'Parfois', 'score': 2.00},
        {'text': 'Souvent', 'score': 3.00},
        {'text': 'Très souvent', 'score': 4.00}
      ]
    },
    {
      'questionText':
          "Trouvez-vous votre enfant en train de lécher ou de renifler des objets inhabituels?",
      'answers': [
        {'text': 'Jamais', 'score': 1.00},
        {'text': 'Parfois', 'score': 2.00},
        {'text': 'Souvent', 'score': 3.00},
        {'text': 'Très souvent', 'score': 4.00}
      ]
    },
    {
      'questionText':
          "Votre enfant demande-t-il de l’aide lorsqu’il veut essayer quelque chose de nouveau?",
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
              child: (_indexQuestion <= 14 && _indexQuestion >= 0)
                  ? Quiz(
                      answerQuestion: _answerQuestion,
                      indexQuestion: _indexQuestion,
                      data: _data)
                  : Result(_totalScore, widget.prenomEnfant, _ok))),
    );
  }
}
