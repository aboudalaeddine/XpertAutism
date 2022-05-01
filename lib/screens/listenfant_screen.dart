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
  final typeUtilisateur;
  const MyAppEnf({Key? key, @required this.typeUtilisateur}) : super(key: key);

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
                          : logoWidget("assets/images/femelle.png", 40, 40),
                      title: Text(
                        "${data.docs[index]['nomEnfant']} ${data.docs[index]['prenomEnfant']}",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 174, 2, 204)),
                      ),
                      subtitle: Text((DateTime.now()
                                  .difference(data.docs[index]['dateNaissance']
                                      .toDate())
                                  .inDays ~/
                              365)
                          .toString()),
                      trailing: Text(data.docs[index]['etat'].toString()),
                      onTap: () {
                        onClickEnfant(
                            context,
                            data,
                            index,
                            MediaQuery.of(context).size.height,
                            MediaQuery.of(context).size.width);
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

  void onClickEnfant(BuildContext myContext, QuerySnapshot<Object?> myData,
      int myIndex, double _height, double _width) {
    Navigator.of(myContext).push(MorpheusPageRoute(
        builder: ((myContext) => Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: const Text(
                  "profil enfant",
                  style: TextStyle(color: Color.fromARGB(255, 205, 197, 206)),
                ),
              ),
              body: Container(
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: _height / 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: myData.docs[myIndex]['sexe'] ==
                                      "Male"
                                  ? const AssetImage('assets/images/male.png')
                                  : const AssetImage(
                                      'assets/images/femelle.png'),
                              radius: _height / 10,
                            ),
                            SizedBox(
                              height: _height / 30,
                            ),
                            Container(
                              decoration: const BoxDecoration(boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(255, 154, 154, 154),
                                    blurRadius: 5)
                              ]),
                              child: Container(
                                height: MediaQuery.of(context).size.height / 3,
                                width:
                                    2 * MediaQuery.of(context).size.width / 3,
                                child: Card(
                                  color: Colors.white,
                                  child: Text(
                                    "${myData.docs[myIndex]['nomEnfant']} ${myData.docs[myIndex]['prenomEnfant']}",
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))));
  }
}

class $ {}

enum etatEnfant { attendant, accepte, refuse }

extension EtatEnfantExtension on etatEnfant {
  String get name {
    return ["En attente", "Accepté", "Transféré"][index];
  }
}
