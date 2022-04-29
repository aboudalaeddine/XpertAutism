import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morpheus/morpheus.dart';
import 'package:xpert_autism/main.dart';
import 'package:xpert_autism/screens/ajouter_enfant.dart';
import 'package:xpert_autism/screens/first_home_screen.dart';
import 'package:xpert_autism/screens/listetudiant_screen.dart';

import '../reusable_widgets/reusable_widget.dart';
import 'signin_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyAppEnf extends StatefulWidget {
  const MyAppEnf({Key? key}) : super(key: key);

  @override
  State<MyAppEnf> createState() => _MyAppEnfState();
}

class _MyAppEnfState extends State<MyAppEnf> {
  final Stream<QuerySnapshot> users = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser?.email)
      .collection('Enfants')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Liste des enfants"),
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
                onSelected: (item) => onSelectedAction(context, item),
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: StreamBuilder<QuerySnapshot>(
            stream: users,
            builder: (
              BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot,
            ) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading...');
              }
              final data = snapshot.requireData;
              return ListView.builder(
                itemCount: data.size,
                itemBuilder: (context, index) {
                  final _parentKey = GlobalKey();
                  return Card(
                    child: ListTile(
                      key: _parentKey,
                      leading: data.docs[index]['sexe'] == "Male"
                          ? logoWidget("assets/images/male.png", 40, 40)
                          : logoWidget("assets/images/avatar.png", 40, 40),
                      title: Text(
                        "${data.docs[index]['nomEnfant']} ${data.docs[index]['prenomEnfant']}",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 174, 2, 204)),
                      ),
                      subtitle: Text(data.docs[index]['sexe']),
                      trailing: Text(data.docs[index]['etat'].toString()),
                      onTap: () {
                        onClickEnfant(context, data, index);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            label: const Text("Ajouter enfant"),
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AjouterEnfant()));
            }),
      ),
    );
  }

  void onSelectedAction(BuildContext context, int item) {
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

  void onClickEnfant(
      BuildContext myContext, QuerySnapshot<Object?> myData, int myIndex) {
    Navigator.of(myContext).push(MorpheusPageRoute(
        builder: ((myContext) => Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: const Text(
                "Infos",
                style: TextStyle(color: Color.fromARGB(255, 205, 197, 206)),
              ),
            ),
            body: Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(children: <Widget>[
                  Text(
                    "le nom de l'enfant:${myData.docs[myIndex]['nomEnfant']} le prenom de l'enfant: ${myData.docs[myIndex]['prenomEnfant']}",
                  ),
                  accepter(context, typeUtilisateur.directeur, "adazd", () {})
                ]))))));
  }
}

class $ {}

enum etatEnfant { attendant, accepte, refuse }

extension EtatEnfantExtension on etatEnfant {
  String get name {
    return ["En attente", "Accepté", "Transféré"][index];
  }
}
