import 'package:google_fonts/google_fonts.dart';
import 'package:shyamshopee/Config/config.dart';
import 'package:shyamshopee/Store/cart.dart';
import 'package:shyamshopee/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shyamshopee/Store/storehome.dart';


class MyAppBar extends StatelessWidget with PreferredSizeWidget
{
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom,});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: bottom,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>StoreHome()));
        },
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Colors.indigo[900]
        ),
      ),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }


  Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}
