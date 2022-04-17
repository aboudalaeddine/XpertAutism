import 'package:flutter/material.dart';

import '../reusable_widgets/reusable_widget.dart';
import '../utils/color_utils.dart';

class AjouterEnfant extends StatefulWidget {
  const AjouterEnfant({Key? key}) : super(key: key);

  @override
  State<AjouterEnfant> createState() => _AjouterEnfantState();
}

class _AjouterEnfantState extends State<AjouterEnfant> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _ageTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Enregistrer Enfant",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringTocolor("0000FF"),
            hexStringTocolor("0000CD"),
            hexStringTocolor("00008B")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Entrer le nom et de l'enfant", Icons.person,
                  false, _userNameTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Entrer le prénom de l'enfant", Icons.person,
                  false, _userNameTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Entrer la date de naissance de l'enfant",
                  Icons.abc_outlined, false, _ageTextController),
              const SizedBox(
                height: 100,
              ),
              UserTypeButton(context, "Enregistrer Enfant", () {}),
            ]),
          ))),
    );
  }
}
