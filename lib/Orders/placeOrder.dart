import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shyamshopee/Config/config.dart';
import 'package:shyamshopee/Store/storehome.dart';
import 'package:shyamshopee/Counters/cartitemcounter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  final String addressId;
  final double totalAmount;

  PaymentPage({Key key, this.addressId, this.totalAmount,}):super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}




class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.grey[100],
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                  child: Image.asset('images/placeOrder.jpg'),
              ),
              SizedBox(height: 10.0,),
              Text(
                "Total Order Price: ₹ ${widget.totalAmount}",
                style: GoogleFonts.aBeeZee(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                )
              ),
              SizedBox(height: 40,),
              FlatButton(
                color: Colors.redAccent[400],
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.greenAccent[700],
                onPressed: ()=>addOrderDetails(),
                child: Text("Place Order", style: GoogleFonts.aBeeZee(fontSize: 30.0),)
              )
            ],
          ),
        ),
      ),
    );
  }

  addOrderDetails() {
    writeOrderForUser({
      ECommerce.addressID: widget.addressId,
      ECommerce.totalAmount : widget.totalAmount,
      "orderBy": ECommerce.sharedPreferences.getString(ECommerce.userUID),
      ECommerce.productID: ECommerce.sharedPreferences.getStringList(ECommerce.userCartList),
      ECommerce.paymentDetails: "Cash on Delivery",
      ECommerce.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      ECommerce.isSuccess: true,
    });
    writeOrderForAdmin({
      ECommerce.addressID: widget.addressId,
      ECommerce.totalAmount : widget.totalAmount,
      "orderBy": ECommerce.sharedPreferences.getString(ECommerce.userUID),
      ECommerce.productID: ECommerce.sharedPreferences.getStringList(ECommerce.userCartList),
      ECommerce.paymentDetails: "Cash on Delivery",
      ECommerce.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      ECommerce.isSuccess: true,
    }).whenComplete(() => {
      emptyCartNow()
    });
  }

  emptyCartNow() {
    ECommerce.sharedPreferences.setStringList(ECommerce.userCartList, ["garbageValue"]);
    List tempList = ECommerce.sharedPreferences.getStringList(ECommerce.userCartList);

    Firestore.instance.collection("users").
    document(ECommerce.sharedPreferences.getString(ECommerce.userUID)).
    updateData({
      ECommerce.userCartList: tempList,
    }).then((value) {
      ECommerce.sharedPreferences.setStringList(ECommerce.userCartList, tempList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
    Fluttertoast.showToast(msg: "Congratulation, Your order has been placed successfully");
    Route route = MaterialPageRoute(builder: (c) => StoreHome());
    Navigator.pushReplacement(context, route);
  }

  Future writeOrderForUser(Map<String, dynamic> data) async {
    await ECommerce.firestore.collection(ECommerce.collectionUser)
        .document(ECommerce.sharedPreferences.getString(ECommerce.userUID))
        .collection(ECommerce.collectionOrders)
        .document(ECommerce.sharedPreferences.getString(ECommerce.userUID)+data['orderTime'])
        .setData(data);
  }
  Future writeOrderForAdmin(Map<String, dynamic> data) async {
    await ECommerce.firestore.collection(ECommerce.collectionOrders)
        .document(ECommerce.sharedPreferences.getString(ECommerce.userUID)+data['orderTime'])
        .setData(data);
  }
}
