import 'package:flutter/material.dart';
import 'package:meus_recebimentos/geral.dart';
import 'package:meus_recebimentos/model/usuario_model.dart';
import 'package:meus_recebimentos/persistence/db.dart';
import 'package:meus_recebimentos/views/cadastro_conta.dart';
import 'package:meus_recebimentos/views/home.dart';
import 'package:meus_recebimentos/views/totais.dart';
import 'package:meus_recebimentos/views/usuario_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseCreator().initDatabase();
  runApp(const Menu());
}

Usuario usuarioAcessado;

class Menu extends StatelessWidget {
  const Menu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: MenuPage(title: 'Home Page'),

      routes:<String, WidgetBuilder>{
        // ALTERA_CONTA: (BuildContext context) =>
        //   new AlteraContaPage(title: 'Altera Conta',conta: getConsObject(),),
        MENU: (BuildContext context) =>
          const MenuPage(title: 'Meus Recebimentos'),
        HOME: (BuildContext context) =>
          HomePage(title: 'Meus Recebimentos'),
        TOTAIS: (BuildContext context) =>
          TotaisPage(title: 'Totais'),
        CADASTRO_CONTA: (BuildContext context) =>
          const CadastroContaPage(title: 'Adicionar Conta'),
        CADASTRO_LOGIN: (BuildContext context) =>
          CadastroUsuarioPage(title: 'Cadastro de Usuario'),
      },

      initialRoute: CADASTRO_LOGIN,

    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({Key key, this.title}) : super(key: key);

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
    // new pwa.Client();
  }
  final tabs = [
    Center(child: HomePage(title: 'Meus Recebimentos',),),
    Center(child: TotaisPage(title: 'Totais',),),
  ];
  final corBar = [
    Colors.yellow,
    Colors.blueAccent
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, CADASTRO_CONTA);
        },

        // label: const Text('Adicionar Conta'),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
        backgroundColor: Colors.green,
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 28
        ),
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white60,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.line_weight_sharp),
            label: 'Contas'
            // Text('Inicio',
            //   style: TextStyle(color: Colors.white70),
            // ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.poll),
            label: 'Totais'
            // Text('Totais',
            //   style: TextStyle(color: Colors.white70),
            // ),
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
