import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shyamshopee/Widgets/customTextField.dart';
import 'package:shyamshopee/DialogBox/errorDialog.dart';
import 'package:shyamshopee/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:shyamshopee/Config/config.dart';
import 'package:shyamshopee/Widgets/roundedButton.dart';
import 'package:shyamshopee/Authentication/verify.dart';



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}



class _RegisterState extends State<Register>
{
  final TextEditingController _nameText = TextEditingController();
  final TextEditingController _emailText = TextEditingController();
  final TextEditingController _phoneText = TextEditingController();
  final TextEditingController  _passwordText = TextEditingController();
  final TextEditingController _cPasswordText = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.pinkAccent[900],
        body: ListView(
          padding: EdgeInsets.all(10.0),
          shrinkWrap: true,
          children: [
            SizedBox(height: 10.0,),
            InkWell(
              onTap: () => _selectProfilePicture(),
              child: CircleAvatar(
                backgroundColor: Colors.redAccent[400],
                radius: _screenWidth * 0.158,
                child: CircleAvatar(
                  radius: _screenWidth * 0.15,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _imageFile == null ? null : FileImage(_imageFile),
                  child: _imageFile == null
                          ? Icon(Icons.add_photo_alternate, size: _screenWidth * 0.15, color: Colors.black45)
                          : null,
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameText,
                    data: Icons.person,
                    hintText: "Name",
                    isObsecure: false,
                    colorData: Colors.redAccent[400],
                  ),
                  CustomTextField(
                    controller: _emailText,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                    colorData: Colors.redAccent[400],
                  ),
                  CustomTextField(
                    controller: _phoneText,
                    data: Icons.phone,
                    hintText: "Phone",
                    isObsecure: false,
                    colorData: Colors.redAccent[400],
                  ),
                  CustomTextField(
                    controller: _passwordText,
                    data: Icons.keyboard,
                    hintText: "Password",
                    isObsecure: true,
                    colorData: Colors.redAccent[400],
                  ),
                  CustomTextField(
                    controller: _cPasswordText,
                    data: Icons.keyboard,
                    hintText: "Confirm Passowrd",
                    isObsecure: true,
                    colorData: Colors.redAccent[400],
                  ),
                ],
              ),
            ),
            RoundedButton(
              title: 'Register',
              colour: Colors.redAccent[400],
              onPressed:(){
                uploadImage();
              },
            ),
          ],
        )
      ),
    );
  }

  Future<void> _selectProfilePicture() async {
    _imageFile =  await ImagePicker.pickImage(source: ImageSource.gallery);
  }
  Future<void> uploadImage() async {
    if(_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(message: "Please select an image file",);
          }
      );
    }
    else {
      _passwordText.text == _cPasswordText.text
      ? _emailText.text.isNotEmpty &&
          _passwordText.text.isNotEmpty &&
          _cPasswordText.text.isNotEmpty &&
          _nameText.text.isNotEmpty
          ? uploadToStorage()
          : displayDialog(Text("Please fill all the details"))
          : displayDialog(Text("Passwords do not match"));
    }
    
  }
  displayDialog(Text message) {
    return SnackBar(
        content: message,
        backgroundColor: Colors.grey[50],
    );
  }
  uploadToStorage() async{
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(message:"Sit back and Relax, We are setting your profile.");
        }
    );
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference = FirebaseStorage.instance.ref().child(imageFileName);
    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    await taskSnapshot.ref.getDownloadURL().then((urlImage){
      userImageUrl = urlImage as String;
      _registerUser();
    });
  }
  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    FirebaseUser user;
    await _auth.createUserWithEmailAndPassword(
        email: _emailText.text.trim(),
        password: _passwordText.text.trim(),
    ).then((auth) => {
      user = auth.user
    }).catchError((onError){
      Navigator.pop(context);
      showDialog(context: context,
          builder:(c) {
            return ErrorAlertDialog(message: onError.message.toString(),);
          });
    });
    if(user != null) {
          saveUserInfo(user).then((value) async {
            if (!user.isEmailVerified) {
              await user.sendEmailVerification();
              Navigator.pop(context);
              Route route = MaterialPageRoute(builder: (c) => Verify());
              Navigator.pushReplacement(context, route);
            }
            else {
              Navigator.pop(context);
              Route route = MaterialPageRoute(builder: (c) => StoreHome());
              Navigator.pushReplacement(context, route);
            }
        });
    }
  }
  Future saveUserInfo(FirebaseUser fUser) async {
    Firestore.instance.collection("users").document(fUser.uid).setData({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": _nameText.text.trim(),
      "url": userImageUrl,
      "phone": _phoneText.text.trim(),
      ECommerce.userCartList: ["garbageValue"]
    });

    await ECommerce.sharedPreferences.setString("uid", fUser.uid);
    await ECommerce.sharedPreferences.setString(ECommerce.userEmail, fUser.email);
    await ECommerce.sharedPreferences.setString(ECommerce.userName, _nameText.text.trim());
    await ECommerce.sharedPreferences.setString(ECommerce.userPhone, _phoneText.text.trim());
    await ECommerce.sharedPreferences.setString(ECommerce.userAvatarUrl, userImageUrl);
    await ECommerce.sharedPreferences.setStringList(ECommerce.userCartList, ["garbageValue"]);
  }
}

