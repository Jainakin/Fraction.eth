import 'package:flutter/material.dart';

class BottomNavProvider extends ChangeNotifier {
  int index = 0;

  void setIndex(int value) {
    index = value;
  }
}
