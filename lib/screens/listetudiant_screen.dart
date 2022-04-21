import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xpert_autism/screens/first_home_screen.dart';

import 'ajouter_enfant.dart';

class MyAppEtud extends StatefulWidget {
  const MyAppEtud({Key? key}) : super(key: key);

  @override
  State<MyAppEtud> createState() => _MyAppEtudState();
}

class _MyAppEtudState extends State<MyAppEtud> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Liste des étudiants"),
          centerTitle: true,
          actions: [
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.white),
                textTheme: TextTheme().apply(bodyColor: Colors.white),
              ),
              child: PopupMenuButton<int>(
                color: Colors.indigo,
                onSelected: (item) => onSelected(context, item),
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text('inscrire un enfant'),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        const SizedBox(width: 8),
                        Text('Sign Out'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AjouterEnfant()),
        );
        break;
      case 1:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => FirstHomeScreen()),
          (route) => false,
        );
    }
  }
}
