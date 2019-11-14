import 'dart:async';

import 'package:controltareas/src/models/usuario.dart';
import 'package:controltareas/src/providers/usuarios_provider.dart';

class UsuariosBloc {

  final _usuariosController = new StreamController<List<Usuario>>.broadcast();
  
  final _usuariosProvider = new UsuariosProvider();

  List<Usuario> usuarios;

  Stream<List<Usuario>> get usuariosStream => _usuariosController.stream;

  void cargarUsuarios() async {
    usuarios = await _usuariosProvider.cargarUsuarios();
    _usuariosController.sink.add(usuarios);
  }

  void crearUsuario( Usuario usuario ) async {
    await _usuariosProvider.crearUsuario(usuario);
    usuarios.add( usuario );
  }

  void borrarUsuario( String id ) async {
    await _usuariosProvider.borrarUsuario(id);
    usuarios.removeWhere((user) => user.id == id);
  }

  dispose(){
    _usuariosController?.close();
  }
}