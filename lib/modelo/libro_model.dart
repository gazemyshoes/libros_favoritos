class Libro {
  int? id;
  String titulo;
  String autor;
  String genero;
  int calificacion;
  String resena;

  Libro({
    this.id,
    required this.titulo,
    required this.autor,
    required this.genero,
    required this.calificacion,
    required this.resena,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'autor': autor,
      'genero': genero,
      'calificacion': calificacion,
      'resena': resena,
    };
  }

  factory Libro.fromMap(Map<String, dynamic> map) {
    return Libro(
      id: map['id'],
      titulo: map['titulo'],
      autor: map['autor'],
      genero: map['genero'],
      calificacion: map['calificacion'],
      resena: map['resena'] ?? '',
    );
  }
}

class AyudanteBaseDeDatos {
  static final AyudanteBaseDeDatos instancia = AyudanteBaseDeDatos._privado();
  static int _idContador = 0;
  static final List<Libro> _libros = [];

  AyudanteBaseDeDatos._privado();

  Future<int> insertarLibro(Libro libro) async {
    libro.id = _idContador++;
    _libros.add(libro);
    return libro.id!;
  }

  Future<List<Libro>> obtenerLibros() async {
    return _libros;
  }

  Future<int> actualizarLibro(Libro libro) async {
    final index = _libros.indexWhere((l) => l.id == libro.id);
    if (index != -1) {
      _libros[index] = libro;
      return 1;
    }
    return 0;
  }

  Future<int> eliminarLibro(int id) async {
    final index = _libros.indexWhere((l) => l.id == id);
    if (index != -1) {
      _libros.removeAt(index);
      return 1;
    }
    return 0;
  }
}