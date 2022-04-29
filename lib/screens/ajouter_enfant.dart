import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpert_autism/screens/listenfant_screen.dart';

import '../reusable_widgets/reusable_widget.dart';
import '../utils/color_utils.dart';
import 'package:date_field/date_field.dart';

class AjouterEnfant extends StatefulWidget {
  const AjouterEnfant({Key? key}) : super(key: key);

  @override
  State<AjouterEnfant> createState() => _AjouterEnfantState();
}

class _AjouterEnfantState extends State<AjouterEnfant> {
  TextEditingController _nomEnfantTextController = TextEditingController();
  TextEditingController _prenomEnfantTextController = TextEditingController();

  String? _selectedGender;
  DateTime? _dateNaissance;
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
            hexStringTocolor("F7B3C2"),
            hexStringTocolor("F7B3C2"),
            hexStringTocolor("F7B3C2")
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
                  false, _nomEnfantTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Entrer le prénom de l'enfant", Icons.person,
                  false, _prenomEnfantTextController),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Radio<String>(
                  value: 'Male',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                title: const Text('Mâle'),
              ),
              ListTile(
                leading: Radio<String>(
                  value: 'Femelle',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                title: const Text('Femelle'),
              ),
              const SizedBox(
                height: 20,
              ),
              DateTimeFormField(
                firstDate: DateTime.now().subtract(Duration(days: 3650)),
                lastDate: DateTime.now(),
                initialDate: DateTime.now().subtract(Duration(days: 1825)),
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(255, 29, 197, 209),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.black45),
                  errorStyle: TextStyle(color: Colors.redAccent),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.event_note),
                  labelText: 'Date de naissance',
                ),
                mode: DateTimeFieldPickerMode.date,
                autovalidateMode: AutovalidateMode.always,
                validator: (e) =>
                    (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                onDateSelected: (DateTime value) {
                  _dateNaissance = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 50,
              ),
              AddKidButton(context, "Enregistrer Enfant", () {
                if (_dateNaissance == null) {
                  print("gyuuy");
                } else {
                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(FirebaseAuth.instance.currentUser?.email)
                      .collection('Enfants')
                      .doc(_prenomEnfantTextController.text)
                      .set({
                    'nomEnfant': _nomEnfantTextController.text,
                    'prenomEnfant': _prenomEnfantTextController.text,
                    'dateNaissance': _dateNaissance,
                    'sexe': _selectedGender,
                    'etat': etatEnfant.attendant.name.toString()
                  }).then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyAppEnf()));
                  });
                }
              }),
            ]),
          ))),
    );
  }
}
