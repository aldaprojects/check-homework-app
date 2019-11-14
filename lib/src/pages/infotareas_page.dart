import 'package:controltareas/src/bloc/provider.dart';
import 'package:controltareas/src/bloc/tareas_bloc.dart';
import 'package:controltareas/src/models/tareas.dart';
import 'package:controltareas/src/sharedpreferences/user_preferences.dart';
import 'package:flutter/material.dart';

class InfoTareasPage extends StatefulWidget {
  @override
  _InfoTareasPageState createState() => _InfoTareasPageState();
}

class _InfoTareasPageState extends State<InfoTareasPage> {

  Tarea tarea;
  Map<String, dynamic> pendientes;
  TareasBloc tareasBloc;
  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {

    tarea = ModalRoute.of(context).settings.arguments;

    tareasBloc = Provider.tareasBloc(context);

    pendientes = tarea.pendientes;



    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Más info...'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 20)),
            Text('Tarea actual', style: TextStyle(fontSize: 20)),
            _tareaActual(),
            Text('Usuarios con esta tarea', style: TextStyle(fontSize: 20)),
            _mostrarPendientes(),
            _crearBotones()
          ],
        ),
      ),

    );
  }

  Widget _crearBotones(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton.icon(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)
            ),
            color: Colors.blue,
            textColor: Colors.white,
            label: Text('Ya la hice!'),
            icon: Icon(Icons.done),
            onPressed: () {
              tareasBloc.actualizarEstado(prefs.username, tarea.id, "true");
              pendientes[prefs.username] = true;
              setState(() {
                
              });
            }
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
          RaisedButton.icon(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)
            ),
            color: Colors.blue,
            textColor: Colors.white,
            label: Text('Me faltó algo :('),
            icon: Icon(Icons.error),
            onPressed: () {
              tareasBloc.actualizarEstado(prefs.username, tarea.id, "false");
              pendientes[prefs.username] = false;
              setState(() {
                
              });
            }
          )
        ],
      ),
    );
  }

  Widget _tareaActual(){
    return Card(
      margin: EdgeInsets.all(15.0),
      elevation: 5,
      child: Column(
        children: <Widget>[
          _mostrarFoto(),
          ListTile(
            title: Text('${ tarea.nota }'),
            subtitle: Text('by: ${ tarea.autor }'),
          ),
        ],
      ),
    );
  }

  Widget _mostrarPendientes(){

    List<String> userPendientes = new List();
    pendientes.forEach((k,v){
      userPendientes.add(k);
    });

    return Card(
      elevation: 5,
      margin: EdgeInsets.all(15.0),
      child: Container(
        child: Column(
          children: userPendientes.map((u){
            return ListTile(
              title: Text(u),
              trailing: Text('${pendientes[u]}'),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _mostrarFoto(){
    return ( tarea.foto == null ) 
    ? Container()
    : FadeInImage(
      image: NetworkImage(tarea.foto),
      placeholder: AssetImage('assets/jar-loading.gif'),
      height: 500.0,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}