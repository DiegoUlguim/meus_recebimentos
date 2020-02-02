import 'package:flutter/material.dart';
import 'package:meusrecebimentos/model/conta_model.dart';
import 'package:meusrecebimentos/services/conta_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Conta> contas = List();
  List<Conta> contasFiltro = List();

  Future<void> _buscaContas() async{
    var result = await ContaService.getAllConta();

    setState(() {
      contas = result;
      contasFiltro=contas;
    });
  }

  @override
  void initState() {
    super.initState();
    ContaService.addConta(Conta("Fernando",3500));
    ContaService.addConta(Conta("Felipe",2000,pago: 1,valorPago: 2000));
    ContaService.addConta(Conta("Ruan",1300));
    ContaService.addConta(Conta("Manoel",1400));
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
                  //_deletarEmitente(contasFiltro[index].id);
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
                  //onTap: (){
                  //  consObject = contasFiltro[index];
                  //  Navigator.popAndPushNamed(context, '/cadastroEmitente');
                  //},
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
                            ""+contasFiltro[index].valor.toString()
                                +" - "+contasFiltro[index].valorPago.toString()
                                + " = ",
                            style: TextStyle(
                                fontSize: 17
                            ),
                          ),
                          Text(
                            (contasFiltro[index].valor
                                - contasFiltro[index].valorPago).toString(),
                            style: TextStyle(
                                fontSize: 20,
                                fontStyle: FontStyle.italic
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  //subtitle: Text(contasFiltro[index].fantasia),
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
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(widget.title),
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
