// model/destination.dart
class Destination {
  final String id;
  final String name;
  final String description;
  final int dailyRate; // Valor da diária em reais
  final int personRate; // Valor por pessoa em reais
  final String imagePath;

  Destination({
    required this.id,
    required this.name,
    required this.description,
    required this.dailyRate,
    required this.personRate,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dailyRate': dailyRate,
      'personRate': personRate,
      'imagePath': imagePath,
    };
  }

  factory Destination.fromMap(Map<String, dynamic> map) {
    return Destination(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      dailyRate: map['dailyRate'],
      personRate: map['personRate'],
      imagePath: map['imagePath'] ?? 'destinations/default.png',
    );
  }

  @override
  String toString() {
    return 'Destination(id: $id, name: $name, dailyRate: $dailyRate, personRate: $personRate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Destination && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}