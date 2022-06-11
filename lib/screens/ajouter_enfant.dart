import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpert_autism/screens/listenfant_screen.dart';

import '../Quiz/min.dart';
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
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
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
                        reusableTextField("Entrer le nom et de l'enfant",
                            Icons.person, false, _nomEnfantTextController),
                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField("Entrer le prénom de l'enfant",
                            Icons.person, false, _prenomEnfantTextController),
                        const SizedBox(
                          height: 25,
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
                          firstDate:
                              DateTime.now().subtract(Duration(days: 3650)),
                          lastDate: DateTime.now(),
                          initialDate:
                              DateTime.now().subtract(Duration(days: 1825)),
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintStyle: TextStyle(color: Colors.black45),
                            errorStyle: TextStyle(color: Colors.redAccent),
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.event_note),
                            labelText: 'Date de naissance',
                          ),
                          mode: DateTimeFieldPickerMode.date,
                          autovalidateMode: AutovalidateMode.always,
                          validator: (e) => (e?.day ?? 0) == 1
                              ? 'Please not the first day'
                              : null,
                          onDateSelected: (DateTime value) {
                            _dateNaissance = value;
                          },
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        AddKidButton(context, "Enregistrer Enfant", () {
                          if (_dateNaissance == null ||
                              _nomEnfantTextController.text == null ||
                              _prenomEnfantTextController.text == null ||
                              _selectedGender == null) {
                            print("Vous devez remplir tous les champs");
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
                              'etat': etatEnfant.attendant.name.toString(),
                              'emailDuParent':
                                  FirebaseAuth.instance.currentUser?.email
                            }).then((value) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyAppY(
                                          prenomEnfant:
                                              _prenomEnfantTextController
                                                  .text)));
                            });
                          }
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ));
  }
}
