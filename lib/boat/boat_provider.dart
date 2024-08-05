import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'boat.dart';

class BoatProvider with ChangeNotifier {
  List<Boat> _boats = [];
  final String _baseUrl = 'https://tgsax1xdsk.execute-api.us-east-1.amazonaws.com/devvv';

  List<Boat> get boats => _boats;

  BoatProvider() {
    fetchBoats();
  }

  Future<void> fetchBoats() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        List<dynamic> data = json.decode(responseJson['body']);

        _boats = data.map((item) => Boat.fromJson(item)).toList();
        notifyListeners();
      } else {
        print('Failed to fetch boats. Status code: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Error fetching boats: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error fetching boats: $error');
      rethrow;
    }
  }

Future<void> addBoat(Boat boat) async {
  try {
    // Crear un mapa sin el ID
    final Map<String, dynamic> boatJson = {
      'nombre': boat.nombre,
      'tipo': boat.tipo,
      'velocidadMaxima': boat.velocidadMaxima,
      'longitud': boat.longitud,
    };
    final String body = json.encode({'body': json.encode(boatJson)});  // Enviar JSON envuelto en 'body'

    print('Sending JSON: $body');  // Log the JSON being sent

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 201) {
      boat.id = json.decode(response.body)['id'];
      _boats.add(boat);
      print('Boat added successfully: ${boat.toJson()}');
      notifyListeners();
    } else {
      print('Failed to add boat. Status code: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to add boat');
    }
  } catch (error) {
    print('Error adding boat: $error');
    rethrow;
  }
}






  Future<void> updateBoat(Boat boat) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/${boat.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(boat.toJson()),
      );

      if (response.statusCode == 200) {
        final index = _boats.indexWhere((b) => b.id == boat.id);
        if (index != -1) {
          _boats[index] = boat;
          print('Boat updated successfully: ${boat.toJson()}');
          notifyListeners();
        } else {
          print('Boat not found for update. Boat ID: ${boat.id}');
        }
      } else {
        print('Failed to update boat. Status code: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to update boat');
      }
    } catch (error) {
      print('Error updating boat: $error');
      rethrow;
    }
  }

  Future<void> deleteBoat(int id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/$id'));

      if (response.statusCode == 204) {
        _boats.removeWhere((boat) => boat.id == id);
        print('Boat deleted successfully. Boat ID: $id');
        notifyListeners();
      } else {
        print('Failed to delete boat. Status code: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to delete boat');
      }
    } catch (error) {
      print('Error deleting boat: $error');
      rethrow;
    }
  }
}
