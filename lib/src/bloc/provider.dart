import 'package:controltareas/src/bloc/tareas_bloc.dart';
import 'package:controltareas/src/bloc/usuarios_bloc.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget {
  
  final UsuariosBloc _usuariosBloc = new UsuariosBloc();
  final TareasBloc _tareasBloc = new TareasBloc();
  static Provider _instancia;

  factory Provider({Key key, Widget child}) {
    if ( _instancia == null ){
      _instancia = new Provider._internal(key: key, child: child);
    }
    return _instancia;
  }

  Provider._internal({Key key, Widget child})
    : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
  
  static UsuariosBloc usuariosBloc( BuildContext context ) {
    return ( context.inheritFromWidgetOfExactType(Provider) as Provider )._usuariosBloc;
  }

  static TareasBloc tareasBloc( BuildContext context ) {
    return ( context.inheritFromWidgetOfExactType(Provider) as Provider )._tareasBloc;
  }

}