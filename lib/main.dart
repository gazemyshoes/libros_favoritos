import 'package:flutter/material.dart';
import '../vista/libro_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registra tus Libros Favoritos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VistaLibros(),
    );
  }
}