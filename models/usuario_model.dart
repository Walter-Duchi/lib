class Usuario {
  int? id;
  String nombreCompleto;
  String cedula;
  String fechaNacimiento;
  String sexo;
  String password;

  Usuario({
    this.id,
    required this.nombreCompleto,
    required this.cedula,
    required this.fechaNacimiento,
    required this.sexo,
    required this.password,
  });

  // Convierte un objeto Usuario a un Map.
  // Útil para insertar en la base de datos.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombreCompleto': nombreCompleto,
      'cedula': cedula,
      'fechaNacimiento': fechaNacimiento,
      'sexo': sexo,
      'password': password,
    };
  }

  // Convierte un Map a un objeto Usuario.
  // Útil para leer de la base de datos.
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nombreCompleto: map['nombreCompleto'],
      cedula: map['cedula'],
      fechaNacimiento: map['fechaNacimiento'],
      sexo: map['sexo'],
      password: map['password'],
    );
  }
}
