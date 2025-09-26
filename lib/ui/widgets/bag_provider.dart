// ui/widgets/bag_provider.dart
import 'package:flutter/material.dart';
import '../../model/reservation.dart';

class BagProvider extends ChangeNotifier {
  final List<Reservation> _reservationsOnBag = [];
  
  List<Reservation> get reservationsOnBag => _reservationsOnBag;

  void addToBag(Reservation reservation) {
    _reservationsOnBag.add(reservation);
    notifyListeners();
  }

  void removeReservation(Reservation reservation) {
    _reservationsOnBag.remove(reservation);
    notifyListeners();
  }

  void clearBag() {
    _reservationsOnBag.clear();
    notifyListeners();
  }

  double get totalPrice {
    return _reservationsOnBag.fold(0, (sum, reservation) => sum + reservation.totalWithDiscount);
  }
}