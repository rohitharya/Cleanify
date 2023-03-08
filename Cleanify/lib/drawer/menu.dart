import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sortapp/inner/dispoer1.dart';
import 'package:sortapp/inner/overall.dart';
import 'package:sortapp/main.dart';
import 'package:transition/transition.dart';

class MenuBar extends StatefulWidget {
  String email;
  Color c1;
  MenuBar({required this.email, required this.c1});
  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [widget.c1, Colors.white])),
        child: ListView(
          padding: EdgeInsets.all(25),
          children: <Widget>[
            ProfileTile(),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    Transition(
                        child: Displayer(email: widget.email),
                        transitionEffect: TransitionEffect.FADE));
              },
              child: ButtonTile(
                icon: Icons.home,
                text: 'Home',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    Transition(
                        child: Overall(email: widget.email),
                        transitionEffect: TransitionEffect.FADE));
              },
              child: ButtonTile(
                icon: Icons.star_outline,
                text: 'ANALYTICS',
              ),
            ),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut().then((val) {
                  Navigator.pushReplacement(
                      context,
                      Transition(
                          child: StartPage(),
                          transitionEffect: TransitionEffect.FADE));
                });
              },
              child: ButtonTile(
                icon: Icons.logout,
                text: 'LOG-OUT',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ButtonTile({@required icon, @required text}) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Text(
            text.toString().toUpperCase(),
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Rakkas'),
          ),
          trailing: Icon(
            icon,
            color: Colors.black,
          ),
        ),
        Divider(
          height: 2,
          thickness: 2,
        ),
      ],
    );
  }

  Widget ProfileTile() {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 20)),
          Text('D-CLEANIFY',
              style: GoogleFonts.rakkas(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 23)),
          Padding(padding: EdgeInsets.only(top: 20)),
          Divider(
            height: 2,
            thickness: 3,
          )
        ],
      ),
    );
  }
}
