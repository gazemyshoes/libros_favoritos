# App de Registro de Libros Favoritos

Una aplicación Flutter para registrar, ver, editar y eliminar libros favoritos, diseñada con una interfaz amigable y el patrón MVC. Utiliza una base de datos en memoria para pruebas rápidas en Flutter Web (Chrome).

## Características
- **Interfaz Intuitiva**: Botón centrado "Agrega tu libro" y tarjetas visuales para cada libro.
- **Operaciones CRUD**: Agrega, lista, edita y elimina libros.
- **Diseño MVC**: Separación clara entre Modelo (`libro_model.dart`), Vista (`libro_vista.dart`) y Controlador (`libro_controller.dart`).
- **Widgets en Español**: Incluye `CampoDeTexto`, `TarjetaLibro`, y `BotonTexto` para una experiencia localizada.
- **UX/UI Mejorada**: Mensaje amigable para lista vacía, bordes redondeados, sombras y colores consistentes.

## Requisitos
- Flutter SDK: `>=2.12.0 <3.0.0`
- Dart: `>=2.12.0`
- Dependencias: `flutter_rating_bar: ^4.0.1`
- Navegador: Chrome (para pruebas en Flutter Web)

## Instalación
1. Clona el repositorio:
   ```bash
   git clone <URL-del-repositorio>
   cd registro_libros
   ```
2. Instala las dependencias:
   ```bash
   flutter pub get
   ```
3. Ejecuta la app en Chrome:
   ```bash
   flutter run -d chrome
   ```

## Estructura del Proyecto
- **`main.dart`**: Punto de entrada, configura la app y lanza `VistaLibros`.
- **`libro_model.dart`**: Modelo, gestiona datos en memoria (lista de libros) y operaciones CRUD.
- **`libro_controller.dart`**: Controlador, conecta el modelo con la vista.
- **`libro_vista.dart`**: Vista, muestra la interfaz con un botón centrado "Agrega tu libro" y tarjetas de libros.

## Uso
1. Abre la app en Chrome (`flutter run -d chrome`).
2. Haz clic en "Agrega tu libro" para abrir un formulario.
3. Completa los campos (título, autor, género, calificación, reseña) y guarda.
4. Edita o elimina libros desde las tarjetas.
5. Nota: Los datos se almacenan en memoria y se reinician al recargar la página.

## Limitaciones
- **Persistencia**: Los datos no persisten entre sesiones (base de datos en memoria).
- **Plataforma**: Optimizado para Flutter Web, pero compatible con móviles.

## Mejoras Futuras
- Implementar persistencia con MySQL o Firebase.
- Agregar animaciones y filtros de búsqueda.
- Personalizar colores y estilos avanzados.

## Licencia
MIT License