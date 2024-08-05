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
      title: 'Crud Barcos',
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
        title: Text('Crud de Barcos'),
        backgroundColor: Colors.teal[800],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildTextField(
                      controller: _nombreController,
                      labelText: 'Nombre',
                    ),
                    buildTextField(
                      controller: _tipoController,
                      labelText: 'Tipo',
                    ),
                    buildTextField(
                      controller: _velocidadMaximaController,
                      labelText: 'Velocidad Máxima',
                      keyboardType: TextInputType.number,
                    ),
                    buildTextField(
                      controller: _longitudController,
                      labelText: 'Longitud',
                      keyboardType: TextInputType.number,
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
                                    id: '0',
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
              Consumer<BoatProvider>(
                builder: (context, boatProvider, child) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
                                  Provider.of<BoatProvider>(context, listen: false).deleteBoat(boat.id as int);
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            filled: true,
            fillColor: Colors.teal[50],
            border: OutlineInputBorder(),
          ),
          keyboardType: keyboardType,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese $labelText';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
      ],
    );
  }
}