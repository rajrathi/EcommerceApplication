import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shyamshopee/Admin/adminShiftOrders.dart';
import 'package:shyamshopee/Widgets/loadingWidget.dart';
import 'package:shyamshopee/Widgets/roundedButton.dart';
import 'package:shyamshopee/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;


class UploadPage extends StatefulWidget
{
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage>
{
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _description = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _discountPercent = TextEditingController();
  TextEditingController _title = TextEditingController();
  TextEditingController _productType = TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return file == null ? displayAdminHome(): displayUploadForm();
  }
  displayAdminHome() {
    return Scaffold(
      appBar:  AppBar(
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
        leading: IconButton(
          icon: Icon(Icons.border_color, color: Colors.white),
          onPressed: (){
            Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
            Navigator.pushReplacement(context, route);
          },
        ),
        actions: [
          FlatButton(
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => SplashScreen());
                Navigator.pushReplacement(context, route);
              },
              child: Text("Logout",
                  style: GoogleFonts.aBeeZee(
                      textStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)))),
        ],
      ),
      body: getAdminHomeBody() ,
    );
  }
  getAdminHomeBody() {
    return Container(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shop_rounded, color: Colors.deepPurple[900], size: 200,),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: RoundedButton(
                    title: "Add New Items",
                    colour: Colors.pinkAccent,
                    onPressed: () => takeProductImage(context),
                  ),
                ),
              ],
          ),
        ),
    );
   
  }
  takeProductImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "Product Image",
              style: GoogleFonts.aBeeZee(textStyle: TextStyle(color: Colors.deepPurple[900], fontSize: 25.0, fontWeight: FontWeight.bold)),
            ),
            children: [
              SimpleDialogOption(
                child: Text("Capture with Camera", style: TextStyle(color: Colors.pinkAccent, fontSize: 18.0),),
                onPressed: captureWithCamera,
              ),
              SimpleDialogOption(
                child: Text("Pick from Gallery", style: TextStyle(color: Colors.pinkAccent, fontSize: 18.0),),
                onPressed: pickFromGallery,
              ),
              SimpleDialogOption(
                child: Text("Cancel", style: TextStyle(color: Colors.pinkAccent, fontSize: 18.0),),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }
  captureWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);

    setState(() {
      file = imageFile;
    });
  }

  pickFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 680.0, maxWidth: 970.0);

    setState(() {
      file = imageFile;
    });
  }
  displayUploadForm() {
    return Scaffold(
        appBar:  AppBar(
          backgroundColor: Colors.deepPurple[900],
          title: Text(
            "New Product",
            style: GoogleFonts.aBeeZee(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            ),
         ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: clearForm,
          ),
        ),
      body: ListView(
        children: [
          uploading ? linearProgress():Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(image: DecorationImage(image: FileImage(file), fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top:10.0)),
          ListTile(
            leading: Icon(Icons.perm_device_info, color: Colors.pinkAccent),
            title: Container(
              width: 250.0,
              child: TextField(
                style: GoogleFonts.aBeeZee(color: Colors.deepPurpleAccent),
                controller: _productType,
                decoration: InputDecoration(
                  hintText: "Product Type",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,),
          ListTile(
            leading: Icon(Icons.perm_device_info, color: Colors.pinkAccent),
            title: Container(
              width: 250.0,
              child: TextField(
                style: GoogleFonts.aBeeZee(color: Colors.deepPurpleAccent),
                controller: _title,
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,),
          ListTile(
            leading: Icon(Icons.perm_device_info, color: Colors.pinkAccent),
            title: Container(
              width: 250.0,
              child: TextField(
                style: GoogleFonts.aBeeZee(color: Colors.deepPurpleAccent),
                controller: _description,
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,),
          ListTile(
            leading: Icon(Icons.perm_device_info, color: Colors.pinkAccent),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: GoogleFonts.aBeeZee(color: Colors.deepPurpleAccent),
                controller: _price,
                decoration: InputDecoration(
                  hintText: "Price",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,),
          ListTile(
            leading: Icon(Icons.perm_device_info, color: Colors.pinkAccent),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: GoogleFonts.aBeeZee(color: Colors.deepPurpleAccent),
                controller: _discountPercent,
                decoration: InputDecoration(
                  hintText: "Discount Percent",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,),
          SizedBox(height: 20.0,),
          RoundedButton(
              title: "Add",
              onPressed: uploading ? null: () {
                saveProductInfo();
                Fluttertoast();
              },
              colour: Colors.redAccent[400],
          ),
        ],
      ),
    );
  }
  clearForm() {
    setState(() {
      file = null;
      _description.clear();
      _productType.clear();
      _price.clear();
      _discountPercent.clear();
      _title.clear();
    });
  }

  saveProductInfo() async{
    setState(() {
      uploading = true;
    });
    String imageUrl = await uploadProductImage(file);

    saveInfo(imageUrl);

  }
  Future<String> uploadProductImage(fileImage) async{
    final StorageReference ref = FirebaseStorage.instance.ref().child("Products");
    StorageUploadTask task = ref.child("product_$productId.jpg").putFile(file);
    StorageTaskSnapshot snapshot = await task.onComplete;
    return await snapshot.ref.getDownloadURL();
  }

  saveInfo(String downloadUrl){
    final productsRef = Firestore.instance.collection("products");
    productsRef.document(productId).setData({
      "productType": _productType.text.trim(),
      "description": _description.text.trim(),
      "price": int.parse(_price.text.trim()),
      "discountPercent": int.parse(_discountPercent.text.trim()),
      "publishedDate": DateTime.now(),
      "status": "available",
      "title": _title.text.trim(),
      "thumbnailUrl": downloadUrl,
      "productId": productId,
      "productSearch": setSearchParam(_title.text.trim(), _productType.text.trim()),
    });
    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _title.clear();
      _productType.clear();
      _price.clear();
      _discountPercent.clear();
    });
  }
  setSearchParam(String productTitle, String productType) {
    List<String> productSearchList = [];
    String temp = "";
    String tempLower = "";
    productSearchList.add(productType);
    for (int i = 0; i < productTitle.length; i++) {
      temp = temp + productTitle[i];
      tempLower = tempLower + productTitle[i].toLowerCase();
      productSearchList.add(temp);
      productSearchList.add(tempLower);
    }
    return productSearchList;
  }
}
