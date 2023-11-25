import 'package:flutter/material.dart';
import 'cafe.dart';

class CafeList extends ChangeNotifier {
  List<Cafe> cafes = [];

  void addCafe(Cafe cafe) {
    cafes.add(cafe);
    notifyListeners(); // Notify listeners after adding a cafe
  }

  void removeCafe(Cafe cafe) {
    cafes.remove(cafe);
    notifyListeners(); // Notify listeners after removing a cafe
  }
}
