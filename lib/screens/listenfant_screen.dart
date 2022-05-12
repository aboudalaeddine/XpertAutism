import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:morpheus/morpheus.dart';
import 'package:xpert_autism/main.dart';
import 'package:xpert_autism/screens/ajouter_enfant.dart';
import 'package:xpert_autism/screens/first_home_screen.dart';
import 'package:xpert_autism/screens/listetudiant_screen.dart';

import '../reusable_widgets/reusable_widget.dart';
import 'signin_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

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
  final Stream<QuerySnapshot> parentStream = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser?.email)
      .collection('Enfants')
      .snapshots();
  final Stream<QuerySnapshot> directeurStream =
      FirebaseFirestore.instance.collectionGroup('Enfants').snapshots();
  final Stream<QuerySnapshot> inspecteurStream =
      FirebaseFirestore.instance.collectionGroup('Enfants').snapshots();

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
                  PopupMenuDivider(),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children: const [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text('Se déconnecter'),
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
            stream: widget.typeUtilisateur == "directeur"
                ? directeurStream
                : widget.typeUtilisateur == "inspecteur"
                    ? inspecteurStream
                    : parentStream,
            builder: (
              BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot,
            ) {
              if (snapshot.hasError) {
                return Text("Quelque chose s'est mal passé");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Chargement...');
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
                      trailing: Text(
                        data.docs[index]['etat'].toString(),
                        style: TextStyle(
                            color: data.docs[index]['etat'] == "accepté"
                                ? Colors.green
                                : data.docs[index]['etat'] == "refuse"
                                    ? Colors.red
                                    : Colors.grey),
                      ),
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
        floatingActionButton: widget.typeUtilisateur == 'parent'
            ? FloatingActionButton.extended(
                label: const Text("Ajouter enfant"),
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AjouterEnfant()));
                })
            : null,
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
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 73),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Mon\nProfile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      Container(
                        height: _height * 0.43,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double innerHeight = constraints.maxHeight;
                            double innerWidth = constraints.maxWidth;
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: innerHeight * 0.72,
                                    width: innerWidth,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black,
                                            blurRadius: 20.0),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 80,
                                        ),
                                        Text(
                                          "${myData.docs[myIndex]['nomEnfant']} ${myData.docs[myIndex]['prenomEnfant']}",
                                          style: const TextStyle(
                                            color:
                                                Color.fromRGBO(39, 105, 171, 1),
                                            fontFamily: 'Nunito',
                                            fontSize: 37,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  'etat',
                                                  style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontFamily: 'Nunito',
                                                    fontSize: 25,
                                                  ),
                                                ),
                                                Text(
                                                  myData.docs[myIndex]['etat']
                                                      .toString(),
                                                  style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        39, 105, 171, 1),
                                                    fontFamily: 'Nunito',
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 25,
                                                vertical: 8,
                                              ),
                                              child: Container(
                                                height: 50,
                                                width: 3,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  'age',
                                                  style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontFamily: 'Nunito',
                                                    fontSize: 25,
                                                  ),
                                                ),
                                                Text(
                                                  (DateTime.now()
                                                              .difference(myData
                                                                  .docs[myIndex]
                                                                      [
                                                                      'dateNaissance']
                                                                  .toDate())
                                                              .inDays ~/
                                                          365)
                                                      .toString(),
                                                  style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        39, 105, 171, 1),
                                                    fontFamily: 'Nunito',
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Container(
                                      child:
                                          myData.docs[myIndex]['sexe'] == "Male"
                                              ? Image.asset(
                                                  "assets/images/male.png")
                                              : Image.asset(
                                                  "assets/images/femelle.png"),
                                      width: innerWidth * 0.45,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: widget.typeUtilisateur == 'directeur'
                              ? [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.green),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc()
                                          .collection("Enfants")
                                          .doc(myData.docs[myIndex]
                                              ['prenomEnfant'])
                                          .update({
                                        'etat':
                                            etatEnfant.accepte.name.toString()
                                      });
                                    },
                                    child: Text("Accepter"),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.red),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc()
                                          .collection("Enfants")
                                          .doc(myData.docs[myIndex]
                                              ['prenomEnfant'])
                                          .update({
                                        'etat':
                                            etatEnfant.refuse.name.toString()
                                      });
                                    },
                                    child: Text("Refuser"),
                                  ),
                                ]
                              : [])
                    ],
                  ),
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
