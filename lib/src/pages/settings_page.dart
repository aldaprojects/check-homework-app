import 'dart:math';
import 'package:controltareas/main.dart';
import 'package:flutter/material.dart';

import 'package:controltareas/src/bloc/provider.dart';
import 'package:controltareas/src/bloc/usuarios_bloc.dart';
import 'package:controltareas/src/models/usuario.dart';
import 'package:controltareas/src/sharedpreferences/user_preferences.dart';


class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final prefs = new PreferenciasUsuario();

  UsuariosBloc usuariosBloc;

  BuildContext _context;

  Random rng = new Random();
  
  String _username;

  TextEditingController _userController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    usuariosBloc = Provider.usuariosBloc(context);

    _username = prefs.username.length > 0 ? prefs.username : 'usuario${rng.nextInt(999999)}';


    if( prefs.admin ){
      final usuariosBloc = Provider.usuariosBloc(context);
      usuariosBloc.cargarUsuarios();
    }

    _context = context;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Configuraciones')
      ),
      body: ListView(
        children: <Widget>[
          
          Container(
            height: 50,
            child: Center(
              child: Text(_username, style: TextStyle(fontSize: 20))),
          ),
          GestureDetector(
            onTap: _cambiarNombre,
            child: Card(
              elevation: 4,
              child: ListTile(
                title: Text('Cambiar nombre'),
                trailing: Icon(Icons.arrow_right)
              ),
            ),
          ),
          GestureDetector(
            onTap: _agregarUsuario,
            child: Card(
              elevation: 4,
              child: ListTile(
                title: Text('Agregar usuario'),
                trailing: Icon(Icons.arrow_right)
              ),
            ),
          ),
          GestureDetector(
            onTap: _eliminarUsuario,
            child: Card(
              elevation: 4,
              child: ListTile(
                title: Text('Eliminar usuario'),
                trailing: Icon(Icons.arrow_right)
              ),
            ),
          )
        ],
      ),
    );
  }

  void _cambiarNombre(){
    showDialog(
      context: _context,
      barrierDismissible: true,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: Text('Cambiar nombre'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _userController,
                decoration: InputDecoration(
                  hintText: _username,
                  labelText: 'Nuevo nombre',
                ),    
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                if(_userController.text == "AldairAdmin123"){
                  _userController.text = "Aldair";
                  prefs.admin = true;
                } else prefs.admin = false;

                prefs.username = _userController.text;

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

  void _eliminarUsuario(){
    if(prefs.admin)
    showDialog(
      context: _context,
      barrierDismissible: true,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: Text('Eliminar usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: MyApp.usuarios.map((a){
              return ListTile(
                title: Text(a.username),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: (){
                    usuariosBloc.borrarUsuario(a.id);
                  },
                ),
              );
            }).toList(),
          )
        );
      }
    );
    else nopermiso();
  }

  void _agregarUsuario(){
    if(prefs.admin)
    showDialog(
      context: _context,
      barrierDismissible: true,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: Text('Agregar usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _userController,
                decoration: InputDecoration(
                  hintText: 'Nombre del usuario',
                  labelText: 'Nombre',
                ),    
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Usuario user = new Usuario();
                user.username = _userController.text;

                usuariosBloc.crearUsuario(user);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
    else nopermiso();
  }

  void nopermiso(){
    showDialog(
      context: _context,
      barrierDismissible: true,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: Text('Error'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(child: Text('No tienes permisos para realizar esta accion'),)
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop()
            ),
          ],
        );
      }
    );
  }
}
