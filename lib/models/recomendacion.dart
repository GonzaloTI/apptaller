class Recomendacion {
  int? id;
  int? diagnosticoId;
  String? recomendacion;
  String? nombreMedico;
  int? userIdCliente;
  String? createdAt;
  String? updatedAt;

  Recomendacion({
    this.id,
    this.diagnosticoId,
    this.recomendacion,
    this.nombreMedico,
    this.userIdCliente,
    this.createdAt,
    this.updatedAt,
  });

  // Constructor para crear una instancia de Recomendacion a partir de un mapa JSON
  factory Recomendacion.fromJson(Map<String, dynamic> json) {
    return Recomendacion(
      id: json['id'],
      diagnosticoId: json['diagnostico_id'],
      recomendacion: json['recomendacion'],
      nombreMedico: json['nombre_medico'],
      userIdCliente: int.tryParse(json['user_id_cliente'].toString()),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Constructor alternativo para manejar listas de recomendaciones
  factory Recomendacion.fromJsonRecomendaciones(Map<String, dynamic> json) {
    return Recomendacion(
      id: json['id'],
      diagnosticoId: json['diagnostico_id'],
      recomendacion: json['recomendacion'],
      nombreMedico: json['nombre_medico'],
      userIdCliente: int.tryParse(json['user_id_cliente'].toString()),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
