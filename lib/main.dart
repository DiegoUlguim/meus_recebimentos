import 'package:flutter/material.dart';
import 'package:meusrecebimentos/geral.dart';
import 'package:meusrecebimentos/model/usuario_model.dart';
import 'package:meusrecebimentos/persistence/db.dart';
import 'package:meusrecebimentos/services/usuario_service.dart';
import 'package:meusrecebimentos/views/altera_conta.dart';
import 'package:meusrecebimentos/views/cadastro_conta.dart';
import 'package:meusrecebimentos/views/home.dart';
import 'package:meusrecebimentos/views/totais.dart';
import 'package:meusrecebimentos/views/usuario_login.dart';
import 'package:pwa/client.dart' as pwa;

//void main() => runApp(Menu());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseCreator().initDatabase();
  runApp(Menu());
}

Usuario usuarioAcessado;

Object consObject; // variavel para receber objeto e mandar informacoes para proxima tela

Object getConsObject(){
  Object object = consObject;
  consObject = null;
  return object;
}

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: MenuPage(title: 'Home Page'),

      routes:<String, WidgetBuilder>{
        ALTERA_CONTA: (BuildContext context) =>
          new AlteraContaPage(title: 'Altera Conta',conta: getConsObject(),),
        MENU: (BuildContext context) =>
          new MenuPage(title: 'Home'),
        HOME: (BuildContext context) =>
          new HomePage(title: 'Home'),
        TOTAIS: (BuildContext context) =>
          new TotaisPage(title: 'Totais'),
        CADASTRO_CONTA: (BuildContext context) =>
          new CadastroContaPage(title: 'Cadastro de Conta'),
        CADASTRO_LOGIN: (BuildContext context) =>
          new CadastroUsuarioPage(title: 'Cadastro de Usuario'),
      },

      initialRoute: CADASTRO_LOGIN,

    );
  }
}

class MenuPage extends StatefulWidget {
  MenuPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  int _currentIndex=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    new pwa.Client();
  }
  final tabs = [
    Center(child: HomePage(title: 'Home',),),
    Center(child: TotaisPage(title: 'Totais',),),
  ];
  final corBar = [
    Colors.yellow,
    Colors.blueAccent
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedIconTheme: IconThemeData(
          color: Colors.white,
          size: 35
        ),
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white60,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.poll),
            title: Text('Totais',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
