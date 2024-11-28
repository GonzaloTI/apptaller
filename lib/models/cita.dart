class Cita {
  int? id;
  String? fecha;
  String? hora;
  String? detalles;
  String? estado;
  int? userIdCliente;
  int? disponibilidadId;
  String? createdAt;
  String? updatedAt;

  Cita({
    this.id,
    this.fecha,
    this.hora,
    this.detalles,
    this.estado,
    this.userIdCliente,
    this.disponibilidadId,
    this.createdAt,
    this.updatedAt,
  });

  // Constructor para crear una instancia de Cita a partir de un mapa JSON
  factory Cita.fromJson(Map<String, dynamic> json) {
    return Cita(
      id: json['id'],
      fecha: json['fecha'],
      hora: json['hora'],
      detalles: json['detalles'],
      estado: json['estado'],
      userIdCliente: json['user_id_cliente'],
      disponibilidadId: json['disponibilidad_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Constructor alternativo para manejar listas de citas
  factory Cita.fromJsonCitas(Map<String, dynamic> json) {
    return Cita(
      id: json['id'],
      fecha: json['fecha'],
      hora: json['hora'],
      detalles: json['detalles'],
      estado: json['estado'],
      userIdCliente: json['user_id_cliente'],
      disponibilidadId: json['disponibilidad_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
