import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shyamshopee/Counters/ItemQuantity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication.dart';
import 'package:shyamshopee/Config/config.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'Store/storehome.dart';
import 'package:animated_text_kit/animated_text_kit.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ECommerce.auth = FirebaseAuth.instance;
  ECommerce.sharedPreferences = await SharedPreferences.getInstance();
  ECommerce.firestore = Firestore.instance;
  runApp(EShop());
}

class EShop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (c)=> CartItemCounter()),
          ChangeNotifierProvider(create: (c)=> ItemQuantity()),
          ChangeNotifierProvider(create: (c)=> AddressChanger()),
          ChangeNotifierProvider(create: (c)=> TotalAmount()),
        ],
      child: MaterialApp(
        title: 'e-Shop',
        debugShowCheckedModeBanner: false,
        home: SplashScreen()
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State <SplashScreen> {

  @override
  void initState() {
    super.initState();

    displaySplash();
  }

  displaySplash (){
    Timer (Duration(seconds: 2), () async {
      if(await ECommerce.auth.currentUser() != null){
        Route route = MaterialPageRoute(builder: (_) => StoreHome());
        Navigator.pushReplacement (context, route);
      }
    else {
        Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
        Navigator.pushReplacement (context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
                  Container(
                    child: Image.asset('images/logo.png'),
                    height: 200.0,
                    width: 200.0,
                  ),
                  SizedBox(height: 15,),
                  TypewriterAnimatedTextKit(
                    text: ['Shyam E-Shop'],
                    textAlign: TextAlign.center,
                    speed: Duration(milliseconds: 100),
                    textStyle: GoogleFonts.aBeeZee(
                        textStyle: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                  ),
              ],
          ),
        ),
    );
  }
}
