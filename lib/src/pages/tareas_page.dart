
import 'dart:io';
import 'dart:math';

import 'package:controltareas/src/bloc/provider.dart';
import 'package:controltareas/src/bloc/tareas_bloc.dart';
import 'package:controltareas/src/models/tareas.dart';
import 'package:controltareas/src/models/usuario.dart';
import 'package:controltareas/src/sharedpreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../main.dart';

class TareasPage extends StatefulWidget {

  @override
  _TareasPageState createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {

  List<Usuario> usuarios = MyApp.usuarios;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  TareasBloc tareasBloc;
  Tarea tarea = new Tarea();
  File foto;
  bool _subiendo = false;
  String _username;
  bool login;

  Random rng = new Random();

  TextEditingController _descriptionController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    login = false;
    final prefs = new PreferenciasUsuario();

    _username = prefs.username.length > 0 ? prefs.username : 'usuario${rng.nextInt(999999)}';

    

    usuarios?.forEach((user){
      if(user.username == _username) {
        login = true;
      }
    });


    tareasBloc = Provider.tareasBloc(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Tarea'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              _mostrarFoto(),
              _crearDescripcion(),
              _crearBoton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _mostrarFoto(){
    return foto == null 
      ? Image(image: AssetImage( foto?.path ?? 'assets/no-image.png')) 
      : Image.file(File(foto.path));
  }

  Widget _crearDescripcion(){
    return TextField(
      controller: _descriptionController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Descripción'
      ),
    );
  }

  Widget _crearBoton(){
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.blue,
      textColor: Colors.white,
      label: Text('Subir'),
      icon: Icon(Icons.save),
      onPressed: ( !login || _subiendo ) ? null : _submit
    );
  }

  void _submit() async {
    
    setState(() { _subiendo = true; });

    mostrarSnackbar('Subiendo...');

    if ( foto != null ){
      tarea.foto = await tareasBloc.subirFoto(foto);
    }

    final prefs = new PreferenciasUsuario();

    tarea.autor = prefs.username;
    tarea.nota = _descriptionController.text;
    Map<String, dynamic> pendientes = new Map();
    MyApp.usuarios.forEach((u){
      pendientes.addAll({ '${u.username}' : false});
    });
    tarea.pendientes = pendientes;

    tareasBloc.subirTarea(tarea);

    // setState(() { _guardando = false; });

    Navigator.pop(context);

  }

  void mostrarSnackbar( String mensaje ) {
    final snackbar = SnackBar(
      content: Text( mensaje ),
      duration: Duration( milliseconds: 10000),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);

  }


  _tomarFoto() async {

    foto = await ImagePicker.pickImage(
      source: ImageSource.camera
    );

    setState(() {});
  }

  _seleccionarFoto() async {

    foto = await ImagePicker.pickImage(
      source: ImageSource.gallery
    );
    setState(() {});

  }
}