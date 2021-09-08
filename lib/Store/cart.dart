import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shyamshopee/Config/config.dart';
import 'package:shyamshopee/Address/address.dart';
import 'package:shyamshopee/Widgets/customAppBar.dart';
import 'package:shyamshopee/Widgets/loadingWidget.dart';
import 'package:shyamshopee/Models/item.dart';
import 'package:shyamshopee/Counters/cartitemcounter.dart';
import 'package:shyamshopee/Counters/totalMoney.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shyamshopee/Store/storehome.dart';
import 'package:provider/provider.dart';
import 'package:shyamshopee/Widgets/myDrawer.dart';
import '../main.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalAmount;
  @override
  void initState() {
    super.initState();

    totalAmount = 0.0;
    Provider.of<TotalAmount>(context, listen: false).displayResult(0);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if(ECommerce.sharedPreferences.getStringList(ECommerce.userCartList).length == 1) {
              Fluttertoast.showToast(msg: "Cart is Empty");
            }
            else {
              Route route = MaterialPageRoute(builder: (c) => Address(totalAmount: totalAmount));
              Navigator.pushReplacement(context, route);
            }
          },
          label: Text("Check out"),
          backgroundColor: Colors.redAccent[400],
          icon: Icon(Icons.navigate_next),
      ),
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(builder: (context, amountProvider, cartProvider, c){
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: cartProvider.count == 0
                      ? Container()
                      :Text(
                          "",
                          style: GoogleFonts.aBeeZee(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                ),
              );
            }),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: ECommerce.firestore.collection("products")
                  .where("productId", whereIn: ECommerce.sharedPreferences.getStringList(ECommerce.userCartList)).snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? SliverToBoxAdapter(child: (Center(child: circularProgress(),)),)
                    : snapshot.data.documents.length == 0
                    ? beginBuildingCart()
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              ItemModel model = ItemModel.fromJson(snapshot.data.documents[index].data);
                              if(index == 0) {
                                totalAmount = 0;
                                totalAmount = (model.price *  0.01*(100-model.discountPercent)) + totalAmount;
                              }
                              else {
                                totalAmount = (model.price *  0.01*(100-model.discountPercent)) + totalAmount;
                              }
                              if(snapshot.data.documents.length - 1 == index) {
                                WidgetsBinding.instance.addPostFrameCallback((t) {

                                });
                              }
                              return sourceInfo( model, context, removeCartFunction: () => removeItemFromUserCart(model.productId));
                            },
                          childCount: snapshot.hasData ? snapshot.data.documents.length : 0,
                        ),
                );
              }
          )
        ],
      ),
    );
  }
  beginBuildingCart() {
    return SliverToBoxAdapter(
      child: Card(
        color: Colors.pinkAccent.withOpacity(0.5),
        child: Container(
          height: 100.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_emoticon, color: Colors.white),
              Text("Cart is empty"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Let's do shopping!",),
                  SizedBox(width: 30.0,),
                  IconButton(
                      icon: Icon(Icons.arrow_forward_sharp),
                      onPressed:() {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>StoreHome()));
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  removeItemFromUserCart(String smallInfoId) {
    List tempCartList = ECommerce.sharedPreferences.getStringList(ECommerce.userCartList);
    tempCartList.remove(smallInfoId);

    ECommerce.firestore.collection(ECommerce.collectionUser)
        .document(ECommerce.sharedPreferences.getString(ECommerce.userUID))
        .updateData({
      ECommerce.userCartList: tempCartList,
    }).then((v){
      Fluttertoast.showToast(msg: "Item Removed from Successfully");
      ECommerce.sharedPreferences.setStringList(ECommerce.userCartList, tempCartList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
      totalAmount = 0;
    });
  }
}
