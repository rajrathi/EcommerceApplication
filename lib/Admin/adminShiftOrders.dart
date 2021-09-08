import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shyamshopee/Admin/adminOrderCard.dart';
import 'package:shyamshopee/Config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';

class AdminShiftOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}


class _MyOrdersState extends State<AdminShiftOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                color: Colors.deepPurpleAccent[700]
            ),
          ),
          centerTitle: true,
          title: Text("My Orders", style: GoogleFonts.aBeeZee(color: Colors.white),),
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_drop_down_circle, color: Colors.white),
              onPressed: (){
                SystemNavigator.pop();
              },
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection("orders").snapshots(),
            builder: (c, snapshot){
              return snapshot.hasData
                  ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (c, index){
                  return FutureBuilder<QuerySnapshot>(
                    future: Firestore.instance.collection("products")
                        .where("smallInfo", whereIn: snapshot.data.documents[index].data[ECommerce.productID])
                        .getDocuments(),
                    builder: (c, snap){
                      return snap.hasData
                          ? AdminOrderCard(
                        itemCount: snap.data.documents.length,
                        data: snap.data.documents,
                        orderID: snapshot.data.documents[index].documentID,
                        orderBy: snapshot.data.documents[index].data["orderBy"],
                        addressID: snapshot.data.documents[index].data["addressID"],
                      )
                          : Center(child: circularProgress(),);
                    },
                  );
                },
              )
                  : Center(child: circularProgress());
            }
        ),
      ),
    );
  }
}
