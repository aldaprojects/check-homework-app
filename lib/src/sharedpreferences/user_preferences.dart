import 'package:shared_preferences/shared_preferences.dart';

/*
  Recordar instalar el paquete de:
    shared_preferences:

  Inicializar en el main
    final prefs = new PreferenciasUsuario();
    await prefs.initPrefs();
    
    Recuerden que el main() debe de ser async {...

*/

class PreferenciasUsuario {

  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del username
  get username {
    return _prefs.getString('username') ?? '';
  }

  set username( String value ) {
    _prefs.setString('username', value);
  }
  
  get admin {
    return _prefs.getBool( 'admin' ) ?? false;
  }

  set admin( bool value ){
    _prefs.setBool('admin', value);
  }
}

