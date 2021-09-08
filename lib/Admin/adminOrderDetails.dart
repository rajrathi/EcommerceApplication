import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shyamshopee/Address/address.dart';
import 'package:shyamshopee/Admin/uploadItems.dart';
import 'package:shyamshopee/Config/config.dart';
import 'package:shyamshopee/Widgets/loadingWidget.dart';
import 'package:shyamshopee/Widgets/orderCard.dart';
import 'package:shyamshopee/Models/address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String getOrderId="";
class AdminOrderDetails extends StatelessWidget {

  final String orderID;
  final String orderBy;
  final String addressID;

  AdminOrderDetails({Key key, this.orderID, this.orderBy, this.addressID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: ECommerce.firestore
                .collection(ECommerce.collectionOrders).document(getOrderId).get(),
            builder: (c, snapshot){
              Map dataMap;
              if(snapshot.hasData){
                dataMap = snapshot.data.data;
              }
              return snapshot.hasData
                  ? Container(
                      child: Column(
                      children: [
                        AdminStatusBanner(status: dataMap[ECommerce.isSuccess],),
                        SizedBox(height: 10.0,),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "₹ " + dataMap[ECommerce.totalAmount].toString(),
                                style: GoogleFonts.aBeeZee(fontSize: 20.0, fontWeight: FontWeight.bold),
                              )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text("Order ID: " + getOrderId),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            "Ordered at "+DateFormat("dd MMMM, yyyy - hh:mm:aa")
                                .format(DateTime.fromMicrosecondsSinceEpoch(int.parse(dataMap["orderTime"]))),
                            style: GoogleFonts.aBeeZee(color: Colors.grey, fontSize: 16.0),
                          ),
                        ),
                        Divider(height: 2.0),
                        FutureBuilder<QuerySnapshot>(
                          future: ECommerce.firestore
                              .collection("products")
                              .where("smallInfo", whereIn: dataMap[ECommerce.productID])
                              .getDocuments(),
                          builder: (c, dataSnapshot){
                            return dataSnapshot.hasData
                                ? OrderCard(
                              itemCount: dataSnapshot.data.documents.length,
                              data: dataSnapshot.data.documents,
                            )
                                :Center(child: circularProgress(),);
                          },
                        ),
                        Divider(height: 2.0,),
                        FutureBuilder<DocumentSnapshot>(
                          future: ECommerce.firestore.collection(ECommerce.collectionUser)
                              .document(orderBy)
                              .collection(ECommerce.subCollectionAddress).document(addressID).get(),
                          builder: (c, snap){
                            return snap.hasData
                                ? AdminShippingDetails(model: AddressModel.fromJson(snap.data.data),)
                                : Center(child: circularProgress(),);
                      },
                    ),
                  ],
                ),
              )
                  : Center(child: circularProgress(),);
            },
          ),
        ),
      ),

    );
  }
}

class AdminStatusBanner extends StatelessWidget {
  final bool status;
  AdminStatusBanner({Key key, this.status}):super(key:key);

  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;
    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Successful" : msg = "Unsuccessful";
    return Container(
        decoration: BoxDecoration(
            color: Colors.deepPurpleAccent[700]
        ),
        height: 40.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                SystemNavigator.pop();
              },
              child: Container(
                child: Icon(
                  Icons.arrow_drop_down_circle,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(width: 20.0,),
            Text(
              "Order Shipped" + msg,
              style: GoogleFonts.aBeeZee(color: Colors.black),
            ),
            SizedBox(width: 5.0,),
            CircleAvatar(
              radius: 8.0,
              backgroundColor: Colors.blueGrey,
              child: Icon(
                iconData,
                color: Colors.black,
                size: 14.0,
              ),
            )
          ],
        )
    );
  }
}



class AdminShippingDetails extends StatelessWidget {
  final AddressModel model;

  AdminShippingDetails({Key key, this.model}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0,),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 90.0),
          child: Text(
            "Shipment Details: ",
            style: GoogleFonts.aBeeZee(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(
                  children: [
                    KeyText(msg: "Name"),
                    Text(model.name),
                  ]
              ),
              TableRow(
                  children: [
                    KeyText(msg: "Phone"),
                    Text(model.phoneNumber),
                  ]
              ),
              TableRow(
                  children: [
                    KeyText(msg: "Flat/House Number"),
                    Text(model.flatNumber),
                  ]
              ),
              TableRow(
                  children: [
                    KeyText(msg: "City"),
                    Text(model.city),
                  ]
              ),
              TableRow(
                  children: [
                    KeyText(msg: "State"),
                    Text(model.state),
                  ]
              ),
              TableRow(
                  children: [
                    KeyText(msg: "Pin Code"),
                    Text(model.pincode),
                  ]
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () {
                confirmOrderShipped(context, getOrderId);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.redAccent[400],
                ),
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 40.0,
                child: Center(
                  child: Text(
                    "Confirmed || Order Shipped",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  confirmOrderShipped(BuildContext context, String orderId) {
    ECommerce.firestore.collection(ECommerce.collectionOrders).document(orderId)
        .delete();
    getOrderId = "";
    Route route = MaterialPageRoute(builder: (c) => UploadPage());
    Navigator.pushReplacement(context, route);

    Fluttertoast.showToast(msg: "Order is confirmed and shipped");
  }


}