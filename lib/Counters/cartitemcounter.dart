import 'package:flutter/foundation.dart';
import 'package:shyamshopee/Config/config.dart';

class CartItemCounter extends ChangeNotifier{
  int _counter = ECommerce.sharedPreferences.getStringList(ECommerce.userCartList).length-1;
  int get count => _counter;

  Future <void> displayResult() async{
    int _counter = ECommerce.sharedPreferences.getStringList(ECommerce.userCartList).length-1;
    await Future.delayed(const Duration(milliseconds: 100), (){
      notifyListeners();
    });
  }
}