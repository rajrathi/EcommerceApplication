import 'package:google_fonts/google_fonts.dart';
import 'package:shyamshopee/Authentication/authenication.dart';
import 'package:shyamshopee/Config/config.dart';
import 'package:shyamshopee/Address/addAddress.dart';
import 'package:shyamshopee/Store/Search.dart';
import 'package:shyamshopee/Store/cart.dart';
import 'package:shyamshopee/Orders/myOrders.dart';
import 'package:shyamshopee/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
            decoration: new BoxDecoration(
              color: Colors.white
            ),
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  elevation: 8.0,
                  child: Container(
                    height: 160.0,
                    width: 160.0,
                    child: CircleAvatar(
                      backgroundColor: Colors.redAccent[400],
                      radius: 80.0,
                      child: CircleAvatar(
                        radius: 78.0,
                        backgroundImage: NetworkImage(
                          ECommerce.sharedPreferences.getString(ECommerce.userAvatarUrl),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.0,),
                Divider(color: Colors.black,),
                Text(
                  "Hello, " + ECommerce.sharedPreferences.getString(ECommerce.userName),
                  style: GoogleFonts.aBeeZee(color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)
                ),
              ],
            )
          ),
          Divider(color: Colors.black,),
          SizedBox(height: 15.0,),
          Container(
            padding: EdgeInsets.only(top: 1.0),
            decoration: new BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.home, color: Colors.pink,),
                  title: Text("Home", style: TextStyle(color: Colors.black),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c) => StoreHome());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.bookmark_border, color: Colors.pink,),
                  title: Text("My Orders", style: TextStyle(color: Colors.black),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c) => MyOrders());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart, color: Colors.pink,),
                  title: Text("My Cart", style: TextStyle(color: Colors.black),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c) => CartPage());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.add_location, color: Colors.pink,),
                  title: Text("Add New Address", style: TextStyle(color: Colors.black),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c) => AddAddress());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(color: Colors.black,),
                SizedBox(height: 70.0),
                Divider(color: Colors.black,),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.pink,),
                  title: Text("Logout", style: TextStyle(color: Colors.black),),
                  onTap: (){
                    ECommerce.auth.signOut().then((c){
                      Route route = MaterialPageRoute(builder: (c) => AuthenticScreen());
                      Navigator.pushReplacement(context, route);
                    });
                  },
                ),
                Divider(color: Colors.black,),
              ],
            )
          ),
        ],
      ),
    );
  }
}
