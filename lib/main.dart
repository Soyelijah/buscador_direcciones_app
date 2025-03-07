// Ruta del archivo: lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Asegúrate de tener esta dependencia en pubspec.yaml

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscador de Direcciones',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Buscador de Direcciones'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController addressController = TextEditingController();
  List<String> suggestions = []; // Aquí guardaremos las sugerencias de direcciones

  @override
  void dispose() {
    // Liberar el controlador al cerrar la pantalla
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Introduce la dirección',
                hintText: 'Ej. Calle Mayor, 1',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (text) {
                _getSuggestions(text); // Actualiza sugerencias en tiempo real
              },
            ),
            if (suggestions.isNotEmpty) // Muestra solo si hay sugerencias
              Flexible(
                child: ListView.builder(
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(suggestions[index]),
                      onTap: () {
                        addressController.text = suggestions[index];
                        setState(() {
                          suggestions = []; // Limpia las sugerencias
                        });
                      },
                    );
                  },
                ),
              ),
            Expanded( // Para mostrar el mapa ocupando el espacio restante
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(51.5, -0.09), // Reemplazado 'center' por 'initialCenter'
                  initialZoom: 13.0,                  // Reemplazado 'zoom' por 'initialZoom'
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Función placeholder para obtener sugerencias (necesitas implementar la lógica real)
  void _getSuggestions(String text) {
    setState(() {
      if (text.isNotEmpty) {
        suggestions = [
          '$text Ejemplo 1',
          '$text Ejemplo 2',
          '$text Ejemplo 3',
        ];
      } else {
        suggestions = [];
      }
    });
  }
}
