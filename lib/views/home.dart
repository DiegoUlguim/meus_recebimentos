import 'package:flutter/material.dart';
import 'package:meusrecebimentos/geral.dart';
import 'package:meusrecebimentos/model/conta_model.dart';
import 'package:meusrecebimentos/services/conta_service.dart';
import 'package:toast/toast.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Conta> contas = List();
  List<Conta> contasFiltro = List();

  int filtroPago = 0;

  Future<void> _buscaContas() async{
    var result = await ContaService.getAllConta(pago: filtroPago);

    setState(() {
      contas = result;
      contasFiltro=contas;
    });
  }
  Future<void> _deletarConta(int id) async{
    await ContaService.deleteConta(id);
  }

  @override
  void initState() {
    super.initState();
  }


  Widget BuildFutureList(){
    return FutureBuilder(
      builder: (context,projectSnap){
        if (contas == null) {
          return Container(
              height: MediaQuery.of(context).size.height/2,
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
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: contasFiltro.length,
            itemBuilder: (context,int index){
              return new Dismissible(
                //confirmDismiss: new MessageEvent("tem certeza jovem?", b),
                direction: DismissDirection.endToStart,
                key: new Key(contasFiltro[index].id.toString()),
                onDismissed: (direction) {
                  _deletarConta(contasFiltro[index].id);
                  Scaffold.of(context).showSnackBar(
                      new SnackBar(
                        content: new Text("Item Removido."),
                      )
                  );
                  contasFiltro.removeAt(index);
                },
                secondaryBackground: new Container(
                  color: Colors.red,
                  padding: EdgeInsets.only(right: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                        Icons.delete
                    ),
                  ),
                ),
                background: new Container(
                  padding: EdgeInsets.only(left: 10),
                  color: Colors.blue,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                        Icons.edit
                    ),
                  ),
                ),
                child: ListTile(
                  onTap: (){
                    if(contasFiltro[index].valorPago >= contasFiltro[index].valor)
                      Toast.show('Conta Já Foi Paga!', context,duration: 3);
                    else{
                      consObject = contasFiltro[index];
                      Navigator.pushNamed(context, ALTERA_CONTA);
                    }

                  },
                  title: new Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            iconsLista[contasFiltro[index].pago],
                            size: 50,
                            color: contasFiltro[index].pago == 0 ? Colors.black54 : Colors.green,
                          ),
                          Text(
                            contasFiltro[index].nome,
                            style: TextStyle(
                                fontSize: 30
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            ""+contasFiltro[index].valor.toStringAsFixed(2)
                                +" - "+contasFiltro[index].valorPago.toStringAsFixed(2)
                                + " = ",
                            style: TextStyle(
                                fontSize: 17
                            ),
                          ),
                          Text(
                            (contasFiltro[index].valor
                                - contasFiltro[index].valorPago).toStringAsFixed(2),
                            style: TextStyle(
                                fontSize: 20,
                                fontStyle: FontStyle.italic
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      future: _buscaContas(),
    );
  }

  final iconsLista = [
    Icons.assignment_late,
    Icons.assignment_turned_in,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: filtroPago==1? Icon(Icons.data_usage) : Icon(Icons.check),
            onPressed: (){
              if(filtroPago==1) filtroPago = 0; else filtroPago = 1;
              _buscaContas();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, CADASTRO_CONTA);
        },
        child: Icon(Icons.add,color: Colors.white,size: 40,),
        backgroundColor: Colors.black,
      ),
      body: ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(3)
                ),
                color: Colors.white,
              ),
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(5),
              height: MediaQuery.of(context).size.height/1.28,
              child: BuildFutureList(),
            ),
          ],
        ),
    );
  }
}
