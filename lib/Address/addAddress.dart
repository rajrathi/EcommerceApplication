import 'package:google_fonts/google_fonts.dart';
import 'package:shyamshopee/Config/config.dart';
import 'package:shyamshopee/Store/storehome.dart';
import 'package:shyamshopee/Widgets/customAppBar.dart';
import 'package:shyamshopee/Models/address.dart';
import 'package:flutter/material.dart';

class AddAddress extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhone = TextEditingController();
  final cHomeNumber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            if(formKey.currentState.validate()) {
              final model = AddressModel(
                name: cName.text.trim(),
                phoneNumber: cPhone.text.trim(),
                flatNumber: cHomeNumber.text.trim(),
                city: cCity.text.trim(),
                state: cState.text.trim(),
                pincode: cPinCode.text.trim(),
              ).toJson();
              
              ECommerce.firestore.collection(ECommerce.collectionUser)
                .document(ECommerce.sharedPreferences.getString(ECommerce.userUID))
                .collection(ECommerce.subCollectionAddress)
                .document(DateTime.now().millisecondsSinceEpoch.toString())
                .setData(model)
                .then((value) {
                  final snack = SnackBar(content: Text("New address added successfully"));
                  scaffoldKey.currentState.showSnackBar(snack);
                  FocusScope.of(context).requestFocus(FocusNode());
                  formKey.currentState.reset();
                });
              Route route = MaterialPageRoute(builder: (c) => StoreHome());
              Navigator.pushReplacement(context, route);
            }
          },
          label: Text("Done"),
          backgroundColor: Colors.purple,
          icon: Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Add New Address",
                    style: GoogleFonts.aBeeZee(textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0)),
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hint: "Name",
                      controller: cName,
                    ),
                    MyTextField(
                      hint: "Phone",
                      controller: cPhone,
                    ),
                    MyTextField(
                      hint: "Flat or House NUmber",
                      controller: cHomeNumber,
                    ),
                    MyTextField(
                      hint: "City",
                      controller: cCity,
                    ),
                    MyTextField(
                      hint: "State",
                      controller: cState,
                    ),
                    MyTextField(
                      hint: "Pin Code",
                      controller: cPinCode,
                    ),
                  ],
                )
              )
            ],
          )
        )
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  MyTextField({Key key, this.hint, this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val) => val.isEmpty ? "Field can not be empty": null,
      ),
    );
  }
}
