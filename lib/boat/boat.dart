class Boat {
  String id;
  String nombre;
  String tipo;
  double velocidadMaxima;
  double longitud;

  Boat({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.velocidadMaxima,
    required this.longitud,
  });

  factory Boat.fromJson(Map<String, dynamic> json) {
    return Boat(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      tipo: json['tipo'] ?? '',
      velocidadMaxima: (json['velocidadMaxima'] ?? 0).toDouble(),
      longitud: (json['longitud'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'tipo': tipo,
      'velocidadMaxima': velocidadMaxima,
      'longitud': longitud,
    };
  }
}
