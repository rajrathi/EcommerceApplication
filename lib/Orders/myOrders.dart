import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shyamshopee/Config/config.dart';
import 'package:flutter/services.dart';
import 'package:shyamshopee/Store/storehome.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}



class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>StoreHome()));
            },
          ),
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent[700]
            ),
          ),
          centerTitle: true,
          title: Text("My Orders", style: GoogleFonts.aBeeZee(color: Colors.white),),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: ECommerce.firestore
              .collection(ECommerce.collectionUser)
              .document(ECommerce.sharedPreferences.getString(ECommerce.userUID))
              .collection(ECommerce.collectionOrders).snapshots(),
          builder: (c, snapshot){
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (c, index){
                      return FutureBuilder<QuerySnapshot>(
                      future: Firestore.instance.collection("products")
                          .where("productId", whereIn: snapshot.data.documents[index].data[ECommerce.productID])
                          .getDocuments(),
                      builder: (c, snap){
                        return snap.hasData
                            ? OrderCard(
                          itemCount: snap.data.documents.length,
                          data: snap.data.documents,
                          orderID: snapshot.data.documents[index].documentID,
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
