import 'package:flutter/cupertino.dart';

class TotalAmount extends ChangeNotifier{
  double _totalAmount = 0.0;
  double get totalAmount => _totalAmount;

  displayResult(double num) async{
    _totalAmount = num;
    await Future.delayed(const Duration(milliseconds: 100), () {
    notifyListeners();
    });
  }
}