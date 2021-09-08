import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class WideButton extends StatelessWidget {
  final String msg;
  final Function onPressed;
  WideButton({Key key, this.msg, this.onPressed}) : super(key:key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Center(
        child: InkWell(
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.redAccent[400],
            ),
            height: 50.0,
            child: Center(
              child: Text(
                msg,
                style: GoogleFonts.aBeeZee(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
