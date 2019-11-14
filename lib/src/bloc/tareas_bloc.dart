import 'dart:async';
import 'dart:io';

import 'package:controltareas/src/models/tareas.dart';
import 'package:controltareas/src/providers/tareas_provider.dart';

class TareasBloc {

  final _tareasController = new StreamController<List<Tarea>>.broadcast();
  
  final _tareasProvider = new TareasProvider();

  List<Tarea> tareas;

  Stream<List<Tarea>> get tareasStream => _tareasController.stream;

  void cargarTareas() async {
    tareas = await _tareasProvider.cargarTareas();
    _tareasController.sink.add(tareas);
  }

  void subirTarea( Tarea tarea ) async {
    await _tareasProvider.subirTarea(tarea);
  }

  void actualizarEstado( String username, String id, String value ) async {
    await _tareasProvider.actualizarEstado(username, id, value);
  }

  void borrarTarea( String id ) async {
    await _tareasProvider.borrarTarea(id);
  }

  Future<String> subirFoto( File foto ) async {
    final _foto = await _tareasProvider.subirFoto(foto);
    return _foto;
  }

  dispose(){
    _tareasController?.close();
  }
}