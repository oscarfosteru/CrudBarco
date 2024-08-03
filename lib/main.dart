import 'package:flutter/material.dart';
import 'package:flutter_oscar_9c/boat/boat.dart';
import 'package:flutter_oscar_9c/boat/boat_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BoatProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boat CRUD App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BoatListScreen(),
    );
  }
}

class BoatListScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _tipoController = TextEditingController();
  final _velocidadMaximaController = TextEditingController();
  final _longitudController = TextEditingController();
  Boat? _selectedBoat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Barcos'),
        backgroundColor: Colors.teal[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      filled: true,
                      fillColor: Colors.teal[50],
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el nombre';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _tipoController,
                    decoration: InputDecoration(
                      labelText: 'Tipo',
                      filled: true,
                      fillColor: Colors.teal[50],
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el tipo';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _velocidadMaximaController,
                    decoration: InputDecoration(
                      labelText: 'Velocidad Máxima',
                      filled: true,
                      fillColor: Colors.teal[50],
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la velocidad máxima';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _longitudController,
                    decoration: InputDecoration(
                      labelText: 'Longitud',
                      filled: true,
                      fillColor: Colors.teal[50],
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la longitud';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (_selectedBoat == null) {
                              Provider.of<BoatProvider>(context, listen: false).addBoat(
                                Boat(
                                  id: 0,
                                  nombre: _nombreController.text,
                                  tipo: _tipoController.text,
                                  velocidadMaxima: double.parse(_velocidadMaximaController.text),
                                  longitud: double.parse(_longitudController.text),
                                ),
                              );
                            } else {
                              _selectedBoat!.nombre = _nombreController.text;
                              _selectedBoat!.tipo = _tipoController.text;
                              _selectedBoat!.velocidadMaxima = double.parse(_velocidadMaximaController.text);
                              _selectedBoat!.longitud = double.parse(_longitudController.text);
                              Provider.of<BoatProvider>(context, listen: false).updateBoat(_selectedBoat!);
                              _selectedBoat = null;
                            }
                            _formKey.currentState!.reset();
                          }
                        },
                        child: Text(_selectedBoat == null ? 'Agregar' : 'Actualizar'),
                        style: ElevatedButton.styleFrom(),
                      ),
                      if (_selectedBoat != null)
                        ElevatedButton(
                          onPressed: () {
                            _selectedBoat = null;
                            _formKey.currentState!.reset();
                          },
                          child: Text('Cancelar'),
                          style: ElevatedButton.styleFrom(),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Consumer<BoatProvider>(
                builder: (context, boatProvider, child) {
                  return ListView.builder(
                    itemCount: boatProvider.boats.length,
                    itemBuilder: (context, index) {
                      final boat = boatProvider.boats[index];
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text('${boat.nombre} (${boat.tipo})'),
                          subtitle: Text('Velocidad: ${boat.velocidadMaxima} km/h, Longitud: ${boat.longitud} m'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _nombreController.text = boat.nombre;
                                  _tipoController.text = boat.tipo;
                                  _velocidadMaximaController.text = boat.velocidadMaxima.toString();
                                  _longitudController.text = boat.longitud.toString();
                                  _selectedBoat = boat;
                                },
                                color: Colors.teal[700],
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  Provider.of<BoatProvider>(context, listen: false).deleteBoat(boat.id);
                                },
                                color: Colors.red[700],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
