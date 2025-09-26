// model/reservation.dart
import 'package:aula8_mobile_teste/model/destination.dart';

class Reservation {
  final String id;
  final Destination destination;
  final int nDiarias;
  final int nPessoas;
  final String paymentMethod;
  final double total;
  final DateTime createdAt;

  Reservation({
    required this.id,
    required this.destination,
    required this.nDiarias,
    required this.nPessoas,
    required this.paymentMethod,
    required this.total,
    required this.createdAt,
  });

  double get totalWithDiscount {
    if (paymentMethod.toLowerCase() == 'pix') {
      return total * 0.9; // 10% de desconto
    }
    return total;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'destination': destination.toMap(),
      'nDiarias': nDiarias,
      'nPessoas': nPessoas,
      'paymentMethod': paymentMethod,
      'total': total,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
