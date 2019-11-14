import 'dart:convert';

import 'package:controltareas/src/models/usuario.dart';
import 'package:http/http.dart' as http;


class UsuariosProvider {
  
  final String _url = 'https://flutter-varios-859f2.firebaseio.com';

  Future<List<Usuario>> cargarUsuarios() async {
    
    final url = '$_url/usuarios.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<Usuario> usuarios = new List();

    if ( decodedData == null ) return [];

    if ( decodedData['error'] != null ) return [];

    decodedData.forEach((id, username){

      final userTemp = Usuario.fromJson(username);
      userTemp.id = id;

      usuarios.add( userTemp );
       
    });


    return usuarios;

  }

  Future<bool> crearUsuario( Usuario usuario ) async {
    final url = '$_url/usuarios.json';

    final resp = await http.post(url, body: usuarioToJson(usuario));

    final decodedData = json.decode(resp.body);

    print(decodedData);
    
    return true;
  }

  Future<int> borrarUsuario( String id ) async {
    final url = '$_url/usuarios/$id.json';

    final resp = await http.delete(url);

    print(resp.body);
    
    return 1;
  }
}