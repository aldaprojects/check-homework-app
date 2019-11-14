import 'dart:math';
import 'package:controltareas/src/bloc/provider.dart';
import 'package:controltareas/src/bloc/tareas_bloc.dart';
import 'package:controltareas/src/models/tareas.dart';
import 'package:flutter/material.dart';

import 'package:controltareas/main.dart';
import 'package:controltareas/src/sharedpreferences/user_preferences.dart';
import 'package:controltareas/src/models/usuario.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  Random rng = new Random();

  String _username;

  List<Usuario> usuarios = MyApp.usuarios;

  @override
  Widget build(BuildContext context) {

    final TareasBloc tareasBloc = Provider.tareasBloc(context);
    tareasBloc.cargarTareas();

    bool login = false;
    final prefs = new PreferenciasUsuario();

    _username = prefs.username.length > 0 ? prefs.username : 'usuario${rng.nextInt(999999)}';

    usuarios?.forEach((user){
      if(user.username == _username) {
        login = true;
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Control de tareas'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, 'settings')
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, 'infoTareas')
      ),
      body: login ? _crearListadoTareas( tareasBloc )
            : _mensajeNoRegistrado(),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Container(
                child: Center(
                  child: Text('Usuarios registrados', style: TextStyle(fontSize: 30)),
                ),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/drawer.png'),
                  fit: BoxFit.cover
                )
              ),
            ),
            Expanded(
              child: Container(
                child: login ? _crearListadoUsuarios(usuarios) 
                      : _mensajeNoRegistrado(),
              ),
            )
            
          ],
        )
      ),
    );
  }

  Widget _mensajeNoRegistrado(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('No estas registrado :(', style: TextStyle(fontSize: 15)),
          Text('Para registrarte cambia tu nombre en ajustes', style: TextStyle(fontSize: 15)),
          Icon(Icons.settings, color: Colors.blue),
          Text('y pide al administrador que te agregue', style: TextStyle(fontSize: 15))
        ],
      ),
    );
  }

  Widget _crearListadoTareas( TareasBloc tareasBloc ){
    return StreamBuilder(
      stream: tareasBloc.tareasStream,
      builder: ( BuildContext context, AsyncSnapshot<List<Tarea>> snapshot ){
        if ( snapshot.hasData ){
          List<Tarea> tareas = snapshot.data;
          
          return tareas.length > 0 ?ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 17),
            itemCount: tareas.length,
            itemBuilder: ( context, index ){

              bool delete = false;
              if (borrar(tareas[index].pendientes)){
                tareasBloc.borrarTarea(tareas[index].id);
                delete = true;
              }
              return delete ? Container()
                     : _tarjetaTarea(tareas[index], context);
            },
          ):
          Center(
            child: Text('No hay tareas!!! :D', style: TextStyle(fontSize: 30)),
          );
        }else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  bool borrar(Map<String, dynamic> pendientes){
    bool borrar = true;
    pendientes.forEach((k,v){
      if(!v) {
        borrar = false;
        return;
      }
    });
    return borrar;
  }

  Widget _tarjetaTarea( Tarea tarea , BuildContext context ){
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        Card(
          elevation: 8,
          child: Column(
            children: <Widget>[
              ( tarea.foto == null ) 
              ? Container()
              : FadeInImage(
                image: NetworkImage(tarea.foto),
                placeholder: AssetImage('assets/jar-loading.gif'),
                height: 200.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              ListTile(
                title: Text('${ tarea.nota }'),
                subtitle: Text('by: ${ tarea.autor }'),
                onTap: () => Navigator.pushNamed(context, 'tarea', arguments: tarea),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _crearListadoUsuarios( List<Usuario> usuarios ) {

    return ListView.builder(
      itemCount: usuarios.length,
      itemBuilder: ( context, index ) => ListTile(
          title: Text(usuarios[index].username),
          leading: Icon(Icons.person),
      ),
    );
  } 
}