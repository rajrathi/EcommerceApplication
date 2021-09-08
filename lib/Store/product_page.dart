import 'package:google_fonts/google_fonts.dart';
import 'package:shyamshopee/Widgets/customAppBar.dart';
import 'package:shyamshopee/Widgets/myDrawer.dart';
import 'package:shyamshopee/Models/item.dart';
import 'package:flutter/material.dart';
import 'package:shyamshopee/Store/storehome.dart';


class ProductPage extends StatefulWidget {

  final ItemModel itemModel;
  ProductPage({this.itemModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}



class _ProductPageState extends State<ProductPage> {

  int itemQuantity = 1;

  @override
  Widget build(BuildContext context)
  {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.network(widget.itemModel.thumbnailUrl),
                      ),
                      Container(
                        color: Colors.blueGrey,
                        child: SizedBox(
                          height: 1.0,
                          width: double.infinity,
                        )
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.itemModel.title,
                            style: GoogleFonts.aBeeZee(
                              textStyle: boldTextStyle
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Text(
                            widget.itemModel.description,
                            style: GoogleFonts.aBeeZee(
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Text(
                            "₹ " + (widget.itemModel.price* 0.01*(100-widget.itemModel.discountPercent)).toStringAsFixed(2),
                            style: GoogleFonts.aBeeZee(
                                textStyle: boldTextStyle
                            ),
                          ),
                          SizedBox(height: 10.0,),
                        ],
                      )
                    )
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: InkWell(
                          onTap: ()=>checkItemInCart(widget.itemModel.productId, context),
                          child: Container(
                            color: Colors.redAccent[400],
                            width: MediaQuery.of(context).size.width - 50.0,
                            height: 50.0,
                            child: Center(
                              child: Text(
                                "Add to Cart",
                                style: GoogleFonts.aBeeZee(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ),
                      ),
                  )
                ],
              ),
            )
          ]
        ),
      ),
    );
  }

}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
