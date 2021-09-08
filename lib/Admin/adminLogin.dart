import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shyamshopee/Admin/uploadItems.dart';
import 'package:shyamshopee/Authentication/authenication.dart';
import 'package:shyamshopee/Authentication/login.dart';
import 'package:shyamshopee/Widgets/customTextField.dart';
import 'package:shyamshopee/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shyamshopee/Widgets/roundedButton.dart';




class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.deepPurple[900],
        title: Text(
          "Shyam Shopee",
          style: GoogleFonts.aBeeZee(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}


class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{
  final TextEditingController _adminIdText = TextEditingController();
  final TextEditingController  _passwordText = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;
    return  SafeArea(
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
                  "Admin Login",
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
                    controller: _adminIdText,
                    data: Icons.person,
                    hintText: "Id",
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
                      _adminIdText.text.isNotEmpty &&
                          _passwordText.text.isNotEmpty
                          ? loginAdmin()
                          : showDialog(
                          context: context,
                          builder: (c) {
                            return ErrorAlertDialog(message: "Please provide email and password",);
                          }
                      );
                    },
                  ),
                  SizedBox(
                    height: 80.0,
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
                    onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Login())),
                    icon: Icon(Icons.nature_people_sharp, color: Colors.greenAccent[400], size: 30.0),
                    label: Text(
                      "I'm not  Admin",
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
  loginAdmin() {
    Firestore.instance.collection("admins").getDocuments().then((snapshot){
      snapshot.documents.forEach((element) {
        if(element.data["id"] != _adminIdText.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Please enter correct ID")));
        }
        else if(element.data["password"] != _passwordText.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Please enter correct password")));
        }
        else {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Welcome dear"+ element.data["name"])));

          setState(() {
            _adminIdText.text = "";
            _passwordText.text = "";
          });
          Route route = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
  
}
