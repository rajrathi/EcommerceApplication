import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shyamshopee/Admin/adminLogin.dart';
import 'package:shyamshopee/Widgets/customTextField.dart';
import 'package:shyamshopee/DialogBox/errorDialog.dart';
import 'package:shyamshopee/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:shyamshopee/Widgets/roundedButton.dart';
import 'package:shyamshopee/Config/config.dart';
import 'package:shyamshopee/Authentication/verify.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}


class _LoginState extends State<Login>
{
  final TextEditingController _emailText = TextEditingController();
  final TextEditingController  _passwordText = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(10.0),
          shrinkWrap: true,
          children: [
            Center(
              child: Container(
                child: Image.asset(
                  'images/Login.png',
                  height: 240.0,
                  width: 240.0,
                ),
              ),
            ),
            Center(
              child: Padding(padding:
              EdgeInsets.all(8.0),
              child: Text(
                "Login to your Account",
                style: GoogleFonts.aBeeZee(
                  color: Colors.black,
                  fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _emailText,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                    colorData: Colors.indigo[900],
                  ),
                  CustomTextField(
                    controller: _passwordText,
                    data: Icons.keyboard,
                    hintText: "Password",
                    isObsecure: true,
                    colorData: Colors.indigo[900],
                  ),
                  RoundedButton(
                    title: 'Login',
                    colour: Colors.indigo[900],
                    onPressed:(){
                      _emailText.text.isNotEmpty &&
                      _passwordText.text.isNotEmpty 
                          ? loginUser()
                          : showDialog(
                          context: context,
                          builder: (c) {
                            return ErrorAlertDialog(message: "Please provide email and password",);
                          }
                      );
                    },
                  ),
                  SizedBox(
                    height: 100.0,
                  ),
                  Container(
                    height: 4.0,
                    width: _screenWidth * 0.8,
                    color: Colors.indigo[900],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  FlatButton.icon(
                    onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminSignInPage())),
                    icon: Icon(Icons.nature_people_sharp, color: Colors.greenAccent[400], size: 30.0),
                    label: Text(
                        "I'm Admin",
                        style: GoogleFonts.aBeeZee(
                            color:Colors.greenAccent[400],
                            fontWeight: FontWeight.bold,
                        ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async{
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(message: "Logging you in",);
        });
    FirebaseUser user;
    await _auth.signInWithEmailAndPassword(
        email: _emailText.text.trim(),
        password: _passwordText.text.trim()
    ).then((authUser) {
        user = authUser.user;
    }).catchError((onError){
      Navigator.pop(context);
      showDialog(context: context,
          builder:(c) {
            return ErrorAlertDialog(message: onError.message.toString(),);
          });
    });
    if(user != null) {
      readData(user).then((value){
        Navigator.pop(context);
        if(user.isEmailVerified) {
          Route route = MaterialPageRoute(builder: (c) => StoreHome());
          Navigator.pushReplacement(context, route);
        }
        else {
          Route route = MaterialPageRoute(builder: (c) => Verify());
          Navigator.pushReplacement(context, route);
        }
      });
    }
  }
  Future readData(FirebaseUser fUser) async{
    Firestore.instance.collection("users").document(fUser.uid).get().then((dataSnapshot)
    async {
      await ECommerce.sharedPreferences.setString("uid", dataSnapshot.data[ECommerce.userUID]);
      await ECommerce.sharedPreferences.setString(ECommerce.userEmail, dataSnapshot.data[ECommerce.userEmail]);
      await ECommerce.sharedPreferences.setString(ECommerce.userName,dataSnapshot.data[ECommerce.userName]);
      await ECommerce.sharedPreferences.setString(ECommerce.userPhone, dataSnapshot.data[ECommerce.userPhone]);
      await ECommerce.sharedPreferences.setString(ECommerce.userAvatarUrl,dataSnapshot.data[ECommerce.userAvatarUrl]);
      List<String> cartList = dataSnapshot.data[ECommerce.userCartList].cast<String>();
      await ECommerce.sharedPreferences.setStringList(ECommerce.userCartList, cartList);
    });
  }
}
