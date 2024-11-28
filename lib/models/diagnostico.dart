class Diagnostico {
  int? id;
  String? resultadoIa;
  String? resultado;
  String? estado;
  String? confidence;
  String? data;
  int? userIdCliente;
  int? userIdMedico;
  String? createdAt;
  String? updatedAt;
  Medico? medico;
  List<Ecografia>? ecografias;

  Diagnostico({
    this.id,
    this.resultadoIa,
    this.resultado,
    this.estado,
    this.confidence,
    this.data,
    this.userIdCliente,
    this.userIdMedico,
    this.createdAt,
    this.updatedAt,
    this.medico,
    this.ecografias,
  });

  // Constructor para crear una instancia de Diagnostico a partir de un mapa JSON
  factory Diagnostico.fromJson(Map<String, dynamic> json) {
    return Diagnostico(
      id: json['id'],
      resultadoIa: json['resultado_ia'],
      resultado: json['resultado'],
      estado: json['estado'],
      confidence: json['confidence'],
      data: json['data'],
      userIdCliente: json['user_id_cliente'],
      userIdMedico: json['user_id_medico'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      medico: json['medico'] != null ? Medico.fromJson(json['medico']) : null,
      ecografias: json['ecografias'] != null
          ? (json['ecografias'] as List)
              .map((e) => Ecografia.fromJson(e))
              .toList()
          : [],
    );
  }

  // Constructor alternativo para manejar listas de diagnósticos
  factory Diagnostico.fromJsonDiagnosticos(Map<String, dynamic> json) {
    return Diagnostico(
      id: json['id'],
      resultadoIa: json['resultado_ia'],
      resultado: json['resultado'],
      estado: json['estado'],
      confidence: json['confidence'],
      data: json['data'],
      userIdCliente: json['user_id_cliente'],
      userIdMedico: json['user_id_medico'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      medico: json['medico'] != null
          ? Medico.fromJsonMedicos(json['medico'])
          : null,
      ecografias: json['ecografias'] != null
          ? (json['ecografias'] as List)
              .map((e) => Ecografia.fromJsonEcografias(e))
              .toList()
          : [],
    );
  }
}

class Medico {
  int? id;
  String? name;
  String? email;
  String? role;
  String? tokenNotificacion;
  String? createdAt;
  String? updatedAt;

  Medico({
    this.id,
    this.name,
    this.email,
    this.role,
    this.tokenNotificacion,
    this.createdAt,
    this.updatedAt,
  });

  // Constructor para crear una instancia de Medico a partir de un mapa JSON
  factory Medico.fromJson(Map<String, dynamic> json) {
    return Medico(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      tokenNotificacion: json['tokenNotificacion'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Constructor alternativo para manejar listas de médicos
  factory Medico.fromJsonMedicos(Map<String, dynamic> json) {
    return Medico(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      tokenNotificacion: json['tokenNotificacion'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Ecografia {
  int? id;
  String? path;
  int? idDiagnostico;
  String? createdAt;
  String? updatedAt;

  Ecografia({
    this.id,
    this.path,
    this.idDiagnostico,
    this.createdAt,
    this.updatedAt,
  });

  // Constructor para crear una instancia de Ecografia a partir de un mapa JSON
  factory Ecografia.fromJson(Map<String, dynamic> json) {
    return Ecografia(
      id: json['id'],
      path: json['path'],
      idDiagnostico: json['id_diagnostico'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Constructor alternativo para manejar listas de ecografías
  factory Ecografia.fromJsonEcografias(Map<String, dynamic> json) {
    return Ecografia(
      id: json['id'],
      path: json['path'],
      idDiagnostico: json['id_diagnostico'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
