
class Gasto {
  final int? id;
  final String descripcion;
  final double cantidad;

  Gasto({
    this.id,
    required this.descripcion,
    required this.cantidad,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'descripcion': descripcion,
      'cantidad': cantidad,
    };
  }

  factory Gasto.fromMap(Map<String, Object?> map) {
    return Gasto(
      id: map['id'] as int?,
      descripcion: map['descripcion'] as String,
      cantidad: (map['cantidad'] as num).toDouble(),
    );
  }

  @override
  String toString() {
    return 'Gasto{id: $id, cantidad: $cantidad, descripcion: $descripcion}';
  }
}