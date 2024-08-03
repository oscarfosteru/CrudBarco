import 'package:flutter/material.dart';
import 'package:flutter_oscar_9c/boat/boat.dart';

class BoatProvider with ChangeNotifier {
  List<Boat> _boats = [];
  int _nextId = 1;

  List<Boat> get boats => _boats;

  void addBoat(Boat boat) {
    boat.id = _nextId++;
    _boats.add(boat);
    notifyListeners();
  }

  void updateBoat(Boat boat) {
    int index = _boats.indexWhere((b) => b.id == boat.id);
    if (index != -1) {
      _boats[index] = boat;
      notifyListeners();
    }
  }

  void deleteBoat(int id) {
    _boats.removeWhere((boat) => boat.id == id);
    notifyListeners();
  }
}
