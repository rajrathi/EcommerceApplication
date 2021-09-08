import 'package:flutter/material.dart';


circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 10.0),
    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.lightBlue),),
  );
}

linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 10.0),
    child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.amber),),
    width: 50.0,
    height: 5.0,
  );
}
