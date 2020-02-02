import 'package:flutter/material.dart';
import 'package:meusrecebimentos/persistence/db.dart';
import 'package:meusrecebimentos/views/home.dart';
import 'package:meusrecebimentos/views/totais.dart';

//void main() => runApp(Menu());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseCreator().initDatabase();
  runApp(Menu());
}

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MenuPage(title: 'Flutter Demo Home Page'),
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
