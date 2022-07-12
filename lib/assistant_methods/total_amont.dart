import 'package:flutter/cupertino.dart';

class TotalAmount extends ChangeNotifier {
  num _totalAmount = 0;

  num get totalAmount => _totalAmount;

  displayTotalAmount(num number) async {
    _totalAmount = number;

    await Future.delayed(const Duration(milliseconds: 100), () {});
  }
}
