import 'package:flutter/material.dart';
import 'package:meus_recebimentos/services/conta_service.dart';

class TotaisPage extends StatefulWidget {
  TotaisPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _TotaisPageState createState() => _TotaisPageState();
}

class _TotaisPageState extends State<TotaisPage> {

  String? total;
  String? restante;
  String? totalPago;

  Future<void> _buscaTotais() async{
    var vTotal = await ContaService.retornaTotal();
    var vRestante = await ContaService.retornaRestante();

    setState(() {
      total = vTotal;
      restante = vRestante;
      totalPago = (double.parse(total!) - double.parse(restante!)).toStringAsFixed(2);
    });
  }

  Widget _futureBuildContainer(){
    return FutureBuilder(
      builder: (context,projectSnap){
        if (total == null) {
          return Container(
              width: MediaQuery.of(context).size.width/1,
              height: MediaQuery.of(context).size.height/1.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.hourglass_empty,
                  )
                ],
              )
          );
        }
        return Column(
          children: <Widget>[

            Container(
              color: Colors.black,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 10),
              margin: EdgeInsets.only(bottom: 20,top: 20),
              child: Text('TOTAL DEVEDORES: ' + total!
                  ,style: TextStyle(fontSize: 24,color: Colors.white,fontStyle: FontStyle.italic)),
            ),
            Container(
              color: Colors.black,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 10),
              margin: EdgeInsets.only(bottom: 20),
              child: Text('TOTAL RESTANTE: ' + restante!
                  ,style: TextStyle(fontSize: 24,color: Colors.white,fontStyle: FontStyle.italic)),
            ),
            Container(
              color: Colors.black,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 10),
              margin: EdgeInsets.only(bottom: 20),
              child: Text('TOTAL PAGO: ' + totalPago!
                  ,style: TextStyle(fontSize: 24,color: Colors.white,fontStyle: FontStyle.italic)),
            ),
          ],
        );
      },
      future: _buscaTotais(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: _futureBuildContainer(),
      ),
    );
  }
}
