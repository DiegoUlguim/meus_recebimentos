import 'package:flutter/material.dart';
import 'package:meus_recebimentos/geral.dart';
import 'package:meus_recebimentos/model/conta_model.dart';
import 'package:meus_recebimentos/services/conta_service.dart';
import 'package:meus_recebimentos/views/altera_conta.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Conta> contas;
  List<Conta> contasFiltro;

  bool filtroPago = false;

  Future<void> _buscaContas() async{
    if(contas==null){
      var result = await ContaService.getAllConta(pago: filtroPago);
      setState(() {
        contas = result.cast<Conta>();
        contasFiltro=contas;
      });
    }
  }
  void _deletarConta(Conta conta) async{
    await ContaService.deleteConta(conta.id);
    contas.remove(conta);
    setState(() {});
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
              alignment: Alignment.center,
              child: const Icon(
                Icons.hourglass_empty,
              )
          );
        }
        return ListView.builder(
          itemCount: contasFiltro.length,
          itemBuilder: (context,int index){
            return TextButton(
              onLongPress: (){_deletarConta(contasFiltro[index]);},
              onPressed: (){
                if(contasFiltro[index].valorPago >= contasFiltro[index].valor) {
                  // Toast.show('Conta Já Foi Paga!', context,duration: 3);
                } else{
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AlteraContaPage(title: '', conta: contasFiltro[index],)),
                  ).then((value) {
                    setState(() {
                      contas = null;
                    });
                  });
                }

              },
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 0),
                    ),
                  ],
                  borderRadius: const BorderRadius.all(
                      Radius.circular(15)
                  ),
                  color: retornaCorConta(contasFiltro[index]),
                ),
                padding: const EdgeInsets.only(left: 10),
                width: MediaQuery.of(context).size.width,
                height: 100,
                // padding: EdgeInsets.all(5),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(15)
                    ),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(10),
                  height: 100,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            contasFiltro[index].nome,
                            style: const TextStyle(
                                fontSize: 30
                            ),
                          ),
                          Text(
                            ' '+contasFiltro[index].quantParcelas.toString(),
                            style: const TextStyle(
                                fontSize: 30
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            ""+contasFiltro[index].valor.toStringAsFixed(2)
                                +" - "+contasFiltro[index].valorPago.toStringAsFixed(2)
                                + " = ",
                            style: const TextStyle(
                                fontSize: 17
                            ),
                          ),
                          Text(
                            (contasFiltro[index].valor
                                - contasFiltro[index].valorPago).toStringAsFixed(2),
                            style: const TextStyle(
                                fontSize: 20,
                                fontStyle: FontStyle.italic
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      future: _buscaContas(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(230, 230, 200, 100),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: filtroPago? const Icon(Icons.data_usage) : const Icon(Icons.check),
            onPressed: (){
              setState(() {
                filtroPago = !filtroPago;
                contas = null;
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, CADASTRO_CONTA);
        },

        child: const Icon(Icons.add,color: Colors.white,size: 40,),
        backgroundColor: Colors.black,
      ),

      body: RefreshIndicator(
        onRefresh: ()async{
          contas = null;
          setState(() {});
        },
        child: BuildFutureList(),
      ),
    );
  }
}
