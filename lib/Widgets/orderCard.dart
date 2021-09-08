import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shyamshopee/Orders/OrderDetailsPage.dart';
import 'package:shyamshopee/Models/item.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';

int counter = 0;
class OrderCard extends StatelessWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;

  OrderCard({Key key, this.itemCount, this.data, this.orderID}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: (){
        Route route;
        if(counter == 0) {
          counter = counter + 1;
          route = MaterialPageRoute(builder: (c) => OrderDetails(orderID: orderID));
        }
        Navigator.push(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100]
        ),
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        height: itemCount * 190.0,
        child: ListView.builder(
          itemCount: itemCount,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (c, index){
            ItemModel model = ItemModel.fromJson(data[index].data);
            return sourceInfo(model, context);
          }

        ),
      ),
    );
  }
}



Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background})
{
  width =  MediaQuery.of(context).size.width;

  return  Container(
    height: 170.0,
    color: Colors.white,
    width: width,
    child: Row(
      children: [
        Image.network(model.thumbnailUrl, width: 180.0,),
        SizedBox(width: 10.0,),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0.0),
                        child: Row(
                          children: [
                            Text(
                              r"Price: ₹ ",
                              style: GoogleFonts.aBeeZee(fontSize: 14.0, color: Colors.blueGrey),
                            ),
                            Text(
                              (model.price* 0.01*(100-model.discountPercent)).toString(),
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
              Divider(color: Colors.indigo[900])
            ],
          ),
        ),
      ],
    ),
  );
}
