// data/hotel_data.dart
import 'package:flutter/material.dart';
import '../model/destination.dart';

class HotelData extends ChangeNotifier {
  List<Destination> _destinations = [];
  
  List<Destination> get destinations => _destinations;

  Future<void> getDestinations() async {
    // Simula carregamento de dados
    await Future.delayed(const Duration(seconds: 1));
    
    _destinations = [
      Destination(
        id: '1',
        name: 'Angra dos Reis',
        description: 'Paraíso tropical no Rio de Janeiro',
        dailyRate: 384,
        personRate: 70,
        imagePath: 'destinations/angra.jpg',
      ),
      Destination(
        id: '2',
        name: 'Jericoacoara',
        description: 'Dunas e praias paradisíacas no Ceará',
        dailyRate: 571,
        personRate: 75,
        imagePath: 'destinations/jericoacoara.jpg',
      ),
      Destination(
        id: '3',
        name: 'Arraial do Cabo',
        description: 'Caribe brasileiro no Rio de Janeiro',
        dailyRate: 534,
        personRate: 65,
        imagePath: 'destinations/arraial.jpg',
      ),
      Destination(
        id: '4',
        name: 'Florianópolis',
        description: 'Ilha da Magia em Santa Catarina',
        dailyRate: 348,
        personRate: 85,
        imagePath: 'destinations/floripa.jpg',
      ),
      Destination(
        id: '5',
        name: 'Madri',
        description: 'Capital cultural da Espanha',
        dailyRate: 401,
        personRate: 85,
        imagePath: 'destinations/madrid.jpg',
      ),
      Destination(
        id: '6',
        name: 'Paris',
        description: 'Cidade Luz da França',
        dailyRate: 546,
        personRate: 95,
        imagePath: 'destinations/paris.jpg',
      ),
      Destination(
        id: '7',
        name: 'Orlando',
        description: 'Capital mundial dos parques temáticos',
        dailyRate: 616,
        personRate: 105,
        imagePath: 'destinations/orlando.jpg',
      ),
      Destination(
        id: '8',
        name: 'Las Vegas',
        description: 'Cidade que nunca dorme nos EUA',
        dailyRate: 504,
        personRate: 110,
        imagePath: 'destinations/vegas.jpg',
      ),
      Destination(
        id: '9',
        name: 'Roma',
        description: 'Cidade Eterna da Itália',
        dailyRate: 478,
        personRate: 85,
        imagePath: 'destinations/roma.jpg',
      ),
      Destination(
        id: '10',
        name: 'Chile',
        description: 'Paisagens únicas na América do Sul',
        dailyRate: 446,
        personRate: 95,
        imagePath: 'destinations/chile.jpg',
      ),
    ];
    
    notifyListeners();
  }
}
