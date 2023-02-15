import 'package:flutter/material.dart';
import 'package:meus_recebimentos/services/conta_service.dart';

class TotaisPage extends StatefulWidget {
  TotaisPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TotaisPageState createState() => _TotaisPageState();
}

class _TotaisPageState extends State<TotaisPage> {
  String total;
  String restante;
  String totalPago;

  Future<void> _buscaTotais() async {
    if (total == null && totalPago == null) {
      var vTotal = await ContaService.retornaTotal();
      var vRestante = await ContaService.retornaRestante();

      if (vTotal != null && vRestante != null) {
        setState(() {
          total = vTotal;
          restante = vRestante;
          totalPago =
              (double.parse(total) - double.parse(restante)).toStringAsFixed(2);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(widget.title)],
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: _futureBuildContainer(),
    );
  }

  Widget _futureBuildContainer() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (total == null) {
          return Container(
              height: MediaQuery.of(context).size.height / 2,
              alignment: Alignment.center,
              child: const CircularProgressIndicator());
        }
        if(total=='0'){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.insert_emoticon_sharp,color: Colors.green,size: 50,),
              Text('Nenhuma Conta a Receber.',
                style: TextStyle(color: Colors.green,fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }
        return Column(
          children: [
            Container(
              color: Colors.black,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 10),
              margin: EdgeInsets.only(top: 20),
              child: Text('Valores a Receber: ' + total,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                      fontStyle: FontStyle.italic)),
            ),
            Container(
              color: Colors.black,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 10),
              margin: EdgeInsets.only(bottom: 10),
              child: Text('Total Pago: ' + totalPago,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontStyle: FontStyle.italic)),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                        color: Colors.green,
                      ),
                      width: MediaQuery.of(context).size.width *
                          (double.parse(totalPago) / double.parse(total)),
                      height: 15),
                  Expanded(
                    child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: Colors.redAccent,
                        ),
                        height: 15),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                color: Colors.grey.shade900,
              ),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Total Restante: ',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text('R\$ ' + restante,
                      style: TextStyle(
                          fontSize: 24,
                          color: Color.fromRGBO(
                            255 -
                                int.parse((255 *
                                        (double.parse(totalPago) /
                                            double.parse(total)))
                                    .toStringAsFixed(0)),
                            int.parse((255 *
                                    (double.parse(totalPago) /
                                        double.parse(total)))
                                .toStringAsFixed(0)),
                            0,
                            100,
                          ),
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        );
      },
      future: _buscaTotais(),
    );
  }
}
