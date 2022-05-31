import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:morpheus/morpheus.dart';
import 'package:xpert_autism/main.dart';
import 'package:xpert_autism/screens/ajouter_enfant.dart';
import 'package:xpert_autism/screens/first_home_screen.dart';

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
  final Stream<QuerySnapshot> inspecteurStream = FirebaseFirestore.instance
      .collectionGroup('Enfants')
      .where("etat", isNotEqualTo: etatEnfant.attendant.name)
      .orderBy('etat')
      .orderBy('nomEnfant')
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
                iconTheme: const IconThemeData(color: Colors.white),
                textTheme: const TextTheme().apply(bodyColor: Colors.white),
              ),
              child: PopupMenuButton<int>(
                color: Colors.indigo,
                onSelected: (item) => onSelectedAction(context, item),
                itemBuilder: (context) => [
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
                return Text(snapshot.error.toString());
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Chargement...');
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
                            fontWeight: FontWeight.bold,
                            color: data.docs[index]['etat'] ==
                                    etatEnfant.accepte.name
                                ? Colors.green
                                : data.docs[index]['etat'] ==
                                        etatEnfant.refuse.name
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
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Mon Profil',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.pacifico(
                                fontSize: 30, color: Colors.black),
                          ),
                          const SizedBox(
                            width: 70,
                          ),
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
                        height: 15,
                      ),
                      Container(
                        height: _height * 0.7,
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
                                            fontSize: 37,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 25,
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
                                                      fontSize: 25,
                                                    ),
                                                  ),
                                                  Text(
                                                    myData.docs[myIndex]['etat']
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          39, 105, 171, 1),
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
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'age: ',
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 25,
                                                    ),
                                                  ),
                                                  Text(
                                                    (DateTime.now()
                                                                .difference(myData
                                                                    .docs[
                                                                        myIndex]
                                                                        [
                                                                        'dateNaissance']
                                                                    .toDate())
                                                                .inDays ~/
                                                            365)
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          39, 105, 171, 1),
                                                      fontSize: 25,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]),
                                        Column(
                                          children: [
                                            Text(
                                              'email',
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 25,
                                              ),
                                            ),
                                            Text(
                                              myData.docs[myIndex]
                                                      ['emailDuParent']
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    39, 105, 171, 1),
                                                fontSize: 25,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 25,
                                            ),
                                          ],
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: widget.typeUtilisateur ==
                                                    'directeur'
                                                ? [
                                                    Text(
                                                      'score: ',
                                                      style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontSize: 25,
                                                      ),
                                                    ),
                                                    Text(
                                                      myData.docs[myIndex]
                                                              ['score']
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Color.fromRGBO(
                                                            39, 105, 171, 1),
                                                        fontSize: 25,
                                                      ),
                                                    ),
                                                  ]
                                                : []),
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
                                      myData.docs[myIndex].reference.update(
                                          {'etat': etatEnfant.accepte.name});
                                    },
                                    child: const Text("Accepter"),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.red),
                                    onPressed: () {
                                      myData.docs[myIndex].reference.update(
                                          {'etat': etatEnfant.refuse.name});
                                    },
                                    child: const Text("Refuser"),
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
    return ["En attente", "Accepté", "Pris en charge"][index];
  }
}
