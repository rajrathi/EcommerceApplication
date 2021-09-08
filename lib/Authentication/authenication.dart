import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'package:shyamshopee/Widgets/roundedButton.dart';
import 'package:shyamshopee/Config/config.dart';
import 'package:google_fonts/google_fonts.dart';


class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SafeArea(
              child: Row(
                children: <Widget>[
                  Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                  Text(
                    'Shyam E-Shop',
                     style: GoogleFonts.aBeeZee(
                        textStyle: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        )
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: 'Login',
              colour: Colors.indigo[900],
              onPressed:(){
                Route route = MaterialPageRoute(builder: (_) => Login());
                Navigator.push(context, route);
              },
            ),
            RoundedButton(
              title: 'Register',
              colour: Colors.redAccent[400],
              onPressed:(){
                Route route = MaterialPageRoute(builder: (_) => Register());
                Navigator.push(context, route);
              },
            ),
          ],
        ),
      ),
    );
  }
}
