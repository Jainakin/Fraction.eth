import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class WelcomePageProvider extends ChangeNotifier {
  int page = 0;

  void setPage(int index) {
    page = index;
    notifyListeners();
  }

  CarouselController carouselController = CarouselController();
}
