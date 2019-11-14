import 'package:controltareas/src/bloc/provider.dart';
import 'package:controltareas/src/models/usuario.dart';
import 'package:controltareas/src/pages/home_page.dart';
import 'package:controltareas/src/pages/infotareas_page.dart';
import 'package:controltareas/src/pages/settings_page.dart';
import 'package:controltareas/src/pages/tareas_page.dart';
import 'package:controltareas/src/providers/usuarios_provider.dart';
import 'package:controltareas/src/sharedpreferences/user_preferences.dart';

import 'package:flutter/material.dart';
 
void main() async {
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  UsuariosProvider usuariosProvider = new UsuariosProvider();
  List<Usuario> usuarios = await usuariosProvider.cargarUsuarios();

  MyApp.usuarios = usuarios;

  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {

  static List<Usuario> usuarios;

  MyApp();

  @override
  Widget build(BuildContext context) {

    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Control de tareas',
        initialRoute: 'home',
        routes:  {
          'home'      : ( BuildContext context ) => HomePage(),
          'settings'  : ( BuildContext context) => SettingsPage(),
          'infoTareas': ( BuildContext context ) => TareasPage(),
          'tarea'     : ( BuildContext context ) => InfoTareasPage()
        },
      ),
    );
  }
}