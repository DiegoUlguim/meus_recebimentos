import 'package:flutter/material.dart';

class TotaisPage extends StatefulWidget {
  TotaisPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TotaisPageState createState() => _TotaisPageState();
}

class _TotaisPageState extends State<TotaisPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),

    );
  }
}
