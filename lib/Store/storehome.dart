import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shyamshopee/Store/cart.dart';
import 'package:shyamshopee/Store/product_page.dart';
import 'package:shyamshopee/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shyamshopee/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo[900],
          title: Text(
            "Shyam Shopee",
            style: GoogleFonts.aBeeZee(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                    icon: Icon(Icons.shopping_cart_outlined, color: Colors.pinkAccent,),
                    onPressed: (){
                      Route route = MaterialPageRoute(builder: (c) => CartPage());
                      Navigator.pushReplacement(context, route);
                    }
                ),
                Positioned(
                    child: Stack(
                      children: [
                        Icon(
                          Icons.brightness_1,
                          size: 20.0,
                          color: Colors.green,
                        ),
                        Positioned(
                          top: 3.0,
                          bottom: 4.0,
                          left: 4.5,
                          child: Consumer<CartItemCounter>(
                            builder: (context, counter, _){
                              return Text(
                                  (ECommerce.sharedPreferences.getStringList(ECommerce.userCartList).length-1).toString(),
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12.0),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                ),
              ],
            )
          ],
        ),
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(pinned: true, delegate: SearchBoxDelegate()),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("products").limit(30).orderBy("publishedDate", descending: true).snapshots(),
              builder: (context, dataSnapshot) {
                return !dataSnapshot.hasData
                    ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                    : SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 1,
                    staggeredTileBuilder: (c)=> StaggeredTile.fit(1),
                    itemBuilder: (context, index) {
                      ItemModel model = ItemModel.fromJson(dataSnapshot.data.documents[index].data);
                      return sourceInfo(model, context);
                    },
                    itemCount: dataSnapshot.data.documents.length,
                );
              }
            )
          ],
        )
      ),
    );
  }
}



Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      Route route = MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
      Navigator.pushReplacement(context, route);
    },
    splashColor: Colors.redAccent[400],
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        height: 225.0,
        width: width,
        child: Row(
          children: [
            Image.network(model.thumbnailUrl, width: 140.0, height: 140.0,),
            SizedBox(width: 4.0,),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15.0,),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(child: Text(model.title, style: GoogleFonts.aBeeZee(color: Colors.black, fontSize: 15.0)))
                        ],
                      ),
                    ),
                    SizedBox(height: 5.0,),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(child: Text(model.productType, style: GoogleFonts.aBeeZee(color: Colors.black45, fontSize: 15.0)))
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.pink,
                          ),
                          alignment: Alignment.topLeft,
                          width: 40.0,
                          height: 43.0,
                          child: Center(
                            child: Column(
                              children: [
                                 Text(
                                  (model.discountPercent).toString(), style: TextStyle(fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  "% OFF", style: TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(top: 0.0),
                                child: Row(
                                  children: [
                                    Text(
                                      r"Original Price: ₹ ",
                                      style: GoogleFonts.aBeeZee(fontSize: 14.0, color: Colors.blueGrey,),
                                    ),
                                    Text(
                                      (model.price).toString(),
                                      style: GoogleFonts.aBeeZee(fontSize: 14.0, color: Colors.black, decoration: TextDecoration.lineThrough),

                                    ),
                                  ],
                                ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: Row(
                                children: [
                                  Text(
                                    r"New Price: ₹ ",
                                    style: GoogleFonts.aBeeZee(fontSize: 14.0, color: Colors.blueGrey),
                                  ),
                                  Text(
                                    (model.price* 0.01*(100-model.discountPercent)).toStringAsFixed(2),
                                    style: GoogleFonts.aBeeZee(fontSize: 14.0, color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Flexible(
                        child:Container(),
                        ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: removeCartFunction == null
                        ? IconButton(
                          icon: Icon(Icons.add_shopping_cart, color: Colors.amber),
                          onPressed: (){
                            checkItemInCart(model.productId, context);
                          }
                        )
                        : IconButton(
                          icon: Icon(Icons.delete, color: Colors.amber),
                        onPressed: () {
                            removeCartFunction();
                            Route route = MaterialPageRoute(builder: (c) => StoreHome());
                            Navigator.pushReplacement(context, route);
                        },
                          ),
                        ),
                    Divider(color: Colors.indigo[900])
                  ],
                ),
            ),
          ],
        ),
      )
    ),
  );
}



Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height: 150.0,
    width: width * 0.35,
    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      boxShadow: <BoxShadow>[
        BoxShadow(offset: Offset(0,5), blurRadius: 10.0, color: Colors.grey[200]),
      ]
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Image.network(
        imgPath,
        height: 150.0,
        width: width* 0.35,
        fit: BoxFit.fill,
      ),
    ),
  );
}



void checkItemInCart(String productId, BuildContext context) {
  ECommerce.sharedPreferences.getStringList(ECommerce.userCartList).contains(productId)
      ? Fluttertoast.showToast(msg: "Item is already in cart.")
      : addItemToCart(productId, context);
}


addItemToCart(String productId, BuildContext context) {
  List tempCartList = ECommerce.sharedPreferences.getStringList(ECommerce.userCartList);
  tempCartList.add(productId);

  ECommerce.firestore.collection(ECommerce.collectionUser)
    .document(ECommerce.sharedPreferences.getString(ECommerce.userUID))
    .updateData({
    ECommerce.userCartList: tempCartList,
  }).then((v){
    Fluttertoast.showToast(msg: "Item Added to Cart Successfully");
    ECommerce.sharedPreferences.setStringList(ECommerce.userCartList, tempCartList);
    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });
}