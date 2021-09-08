


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Verify extends StatefulWidget {
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Shyam E-Shopee',
              style: GoogleFonts.aBeeZee(),
            ),
            centerTitle: true,
            backgroundColor: Colors.indigo[900],
          ),
          body: Center(
            child: Column(
              children: [
                Container(
                  child: Text(
                    'A verification email has sent to you on registered Email-Id',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SizedBox(height: 30.0,),
                Container(
                  child: Text(
                    'Thank You 😊',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 20.0,
                    ),
                  ),
                ),
                ],
              ),
            ),
          ),
        );
  }
}