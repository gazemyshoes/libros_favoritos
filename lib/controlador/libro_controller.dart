import '../modelo/libro_model.dart';

class ControladorLibro {
  final AyudanteBaseDeDatos _ayudanteBaseDeDatos = AyudanteBaseDeDatos.instancia;

  Future<int> agregarLibro(Libro libro) async {
    return await _ayudanteBaseDeDatos.insertarLibro(libro);
  }

  Future<List<Libro>> obtenerLibros() async {
    return await _ayudanteBaseDeDatos.obtenerLibros();
  }

  Future<int> actualizarLibro(Libro libro) async {
    return await _ayudanteBaseDeDatos.actualizarLibro(libro);
  }

  Future<int> eliminarLibro(int id) async {
    return await _ayudanteBaseDeDatos.eliminarLibro(id);
  }
}