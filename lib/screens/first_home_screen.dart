import 'package:flutter/material.dart';
import 'package:xpert_autism/screens/signin_screen.dart';

import '../reusable_widgets/reusable_widget.dart';

class FirstHomeScreen extends StatefulWidget {
  const FirstHomeScreen({Key? key}) : super(key: key);

  @override
  State<FirstHomeScreen> createState() => _FirstHomeScreenState();
}

class _FirstHomeScreenState extends State<FirstHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/backgroundtt.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        20, MediaQuery.of(context).size.height * 0.45, 20, 0),
                    child: Column(children: <Widget>[
                      UserTypeButton(context, "MON ESPACE", () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()));
                      }),
                    ])))));
  }
}
