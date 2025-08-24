import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../modelo/libro_model.dart';
import '../controlador/libro_controller.dart';

class VistaLibros extends StatefulWidget {
  const VistaLibros({super.key});

  @override
  State<VistaLibros> createState() => _EstadoVistaLibros();
}

class _EstadoVistaLibros extends State<VistaLibros> {
  final ControladorLibro controlador = ControladorLibro();
  List<Libro> libros = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarLibros();
  }

  Future<void> _cargarLibros() async {
    try {
      final lista = await controlador.obtenerLibros();
      setState(() {
        libros = lista;
        cargando = false;
      });
    } catch (e) {
      setState(() {
        cargando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar libros: $e')),
      );
    }
  }

  void _mostrarFormularioLibro({Libro? libro}) {
    showDialog(
      context: context,
      builder: (context) => FormularioLibro(
        libro: libro,
        onGuardar: (nuevoLibro) async {
          if (libro == null) {
            await controlador.agregarLibro(nuevoLibro);
          } else {
            nuevoLibro.id = libro.id;
            await controlador.actualizarLibro(nuevoLibro);
          }
          _cargarLibros();
        },
      ),
    );
  }

  void _eliminarLibro(int id) async {
    await controlador.eliminarLibro(id);
    _cargarLibros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registra tus Libros Favoritos'),
        centerTitle: true,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : libros.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '¡Aún no tienes libros registrados!',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _mostrarFormularioLibro(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Registra un libro',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: libros.length,
                        itemBuilder: (context, index) {
                          final libro = libros[index];
                          return TarjetaLibro(
                            libro: libro,
                            onEditar: () => _mostrarFormularioLibro(libro: libro),
                            onEliminar: () => _eliminarLibro(libro.id!),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () => _mostrarFormularioLibro(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Registra otro libro',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

class TarjetaLibro extends StatelessWidget {
  final Libro libro;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const TarjetaLibro({
    super.key,
    required this.libro,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              libro.titulo,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Autor: ${libro.autor}', style: const TextStyle(fontSize: 14)),
            Text('Género: ${libro.genero}', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Calificación: ', style: TextStyle(fontSize: 14)),
                RatingBarIndicator(
                  rating: libro.calificacion.toDouble(),
                  itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 20.0,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Reseña: ${libro.resena}', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEditar,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onEliminar,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FormularioLibro extends StatefulWidget {
  final Libro? libro;
  final Function(Libro) onGuardar;

  const FormularioLibro({
    super.key,
    this.libro,
    required this.onGuardar,
  });

  @override
  State<FormularioLibro> createState() => _EstadoFormularioLibro();
}

class _EstadoFormularioLibro extends State<FormularioLibro> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controladorTitulo;
  late TextEditingController _controladorAutor;
  late TextEditingController _controladorGenero;
  late TextEditingController _controladorResena;
  double _calificacion = 3.0;

  @override
  void initState() {
    super.initState();
    _controladorTitulo = TextEditingController(text: widget.libro?.titulo ?? '');
    _controladorAutor = TextEditingController(text: widget.libro?.autor ?? '');
    _controladorGenero = TextEditingController(text: widget.libro?.genero ?? '');
    _controladorResena = TextEditingController(text: widget.libro?.resena ?? '');
    _calificacion = widget.libro?.calificacion.toDouble() ?? 3.0;
  }

  @override
  void dispose() {
    _controladorTitulo.dispose();
    _controladorAutor.dispose();
    _controladorGenero.dispose();
    _controladorResena.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      final libro = Libro(
        titulo: _controladorTitulo.text,
        autor: _controladorAutor.text,
        genero: _controladorGenero.text,
        calificacion: _calificacion.toInt(),
        resena: _controladorResena.text,
      );
      widget.onGuardar(libro);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.libro == null ? 'Agregar Libro' : 'Editar Libro'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CampoDeTexto(
                controlador: _controladorTitulo,
                etiqueta: 'Título',
                validador: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              CampoDeTexto(
                controlador: _controladorAutor,
                etiqueta: 'Autor',
                validador: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              CampoDeTexto(
                controlador: _controladorGenero,
                etiqueta: 'Género',
                validador: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              const Text('Calificación:', style: TextStyle(fontSize: 14)),
              RatingBar.builder(
                initialRating: _calificacion,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  setState(() {
                    _calificacion = rating;
                  });
                },
              ),
              const SizedBox(height: 12),
              CampoDeTexto(
                controlador: _controladorResena,
                etiqueta: 'Reseña',
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        BotonTexto(
          texto: 'Cancelar',
          onPressed: () => Navigator.pop(context),
        ),
        BotonTexto(
          texto: 'Guardar',
          onPressed: _guardar,
        ),
      ],
    );
  }
}

class CampoDeTexto extends StatelessWidget {
  final TextEditingController controlador;
  final String etiqueta;
  final String? Function(String?)? validador;
  final int? maxLines;

  const CampoDeTexto({
    super.key,
    required this.controlador,
    required this.etiqueta,
    this.validador,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      decoration: InputDecoration(
        labelText: etiqueta,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: validador,
      maxLines: maxLines,
    );
  }
}

class BotonTexto extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;

  const BotonTexto({
    super.key,
    required this.texto,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).primaryColor,
      ),
      child: Text(
        texto,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}