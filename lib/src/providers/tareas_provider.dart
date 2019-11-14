

import 'dart:convert';
import 'dart:io';

import 'package:controltareas/src/models/tareas.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class TareasProvider {
  final String _url = 'https://flutter-varios-859f2.firebaseio.com';

  Future<bool> subirTarea( Tarea tarea) async {
    final url = '$_url/tareas.json';

    final resp = await http.post(url, body: tareasToJson(tarea));

     final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<List<Tarea>> cargarTareas() async {

    final url = '$_url/tareas.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<Tarea> tareas = new List();

    if ( decodedData == null ) return [];

    if ( decodedData['error'] != null ) return [];

    decodedData.forEach((id, tarea){

      final tareaTemp = Tarea.fromJson(tarea);
      tareaTemp.id = id;
      tareaTemp.pendientes = tarea['pendientes'];

      tareas.add( tareaTemp );

    });

    return tareas;

  }

  Future<String> subirFoto( File foto ) async {
    final Uri uri = Uri.parse('https://api.cloudinary.com/v1_1/df5v36c4q/image/upload?upload_preset=kuco39pe');
    final List<String> mimeType = mime(foto.path).split('/');

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      uri
    );

    final file = await http.MultipartFile.fromPath(
      'file', 
      foto.path,
      contentType: MediaType(mimeType[0], mimeType[1])
    );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamResponse);

    if( resp.statusCode != 200 && resp.statusCode != 201 ){
      print('Algo salió mal');
      print( resp.body );
      return null;
    }

    final respData = json.decode(resp.body);

    return respData['secure_url'];
  }

  Future<int> actualizarEstado( String username, String id, String value ) async {
    final url = '$_url/tareas/$id/pendientes/$username.json';

    final resp = await http.put(url, body: value);

    print(resp.body);

    return 1;
  }

  Future<int> borrarTarea( String id ) async {
    final url = '$_url/tareas/$id.json';

    final resp = await http.delete(url);

    return 1;
  }
}