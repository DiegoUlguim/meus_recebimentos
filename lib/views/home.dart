import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meus_recebimentos/geral.dart';
import 'package:meus_recebimentos/model/conta_model.dart';
import 'package:meus_recebimentos/services/conta_service.dart';
import 'package:meus_recebimentos/views/altera_conta.dart';
import 'package:meus_recebimentos/views/cadastro_conta.dart';

import '../main.dart';

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

  Future<void> _buscaContas() async {
    if (contas == null) {
      var result = await ContaService.getAllConta(pago: filtroPago);
      if (result != null) {
        setState(() {
          contas = result.cast<Conta>();
          contasFiltro = contas;
        });
      }
    }
  }

  void _deletarConta(Conta conta) async {
    await ContaService.deleteConta(conta.id);
    contas.remove(conta);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Olá, ${usuarioAcessado.nome}!',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  IconButton(
                    icon: filtroPago
                        ? const Icon(
                            Icons.data_usage,
                            color: Colors.white,
                          )
                        : const Icon(Icons.library_add_check_outlined,
                            color: Colors.white),
                    onPressed: () {
                      setState(() {
                        filtroPago = !filtroPago;
                        contas = null;
                      });
                    },
                  ),
                ],
              ),
            ),
            RefreshIndicator(
              onRefresh: () async {
                contas = null;
                setState(() {});
              },
              child: BuildFutureList(),
            )
          ],
        ),
      ),
    );
  }

  Widget BuildFutureList() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (contas == null) {
          return Container(
              height: MediaQuery.of(context).size.height / 2,
              alignment: Alignment.center,
              child: const CircularProgressIndicator());
        }
        if (contasFiltro.isEmpty) {
          return TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CadastroContaPage(
                              title: 'Adicionar Conta',
                            ))).then((value) {
                  if (value) {
                    contas = null;
                    setState(() {});
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(
                      Icons.add_box,
                      color: Colors.green,
                      size: 40,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Adicionar Conta',
                      style: TextStyle(color: Colors.green, fontSize: 20),
                    ),
                  ],
                ),
              ));
        }
        if (contasFiltro.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(
                Icons.insert_emoticon_sharp,
                color: Colors.green,
                size: 50,
              ),
              Text(
                'Nenhuma Conta a Receber.',
                style: TextStyle(color: Colors.green, fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: contasFiltro.length,
          itemBuilder: (context, int index) {
            return TextButton(
              onLongPress: () {
                _deletarConta(contasFiltro[index]);
              },
              onPressed: () {
                if (contasFiltro[index].valorPago >=
                    contasFiltro[index].valor) {
                  // Toast.show('Conta Já Foi Paga!', context,duration: 3);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AlteraContaPage(
                              title: '',
                              conta: contasFiltro[index],
                            )),
                  ).then((value) {
                    setState(() {
                      contas = null;
                    });
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: retornaCorConta(contasFiltro[index]),
                ),
                padding: const EdgeInsets.only(left: 10),
                width: MediaQuery.of(context).size.width,
                // height: 100,
                // padding: EdgeInsets.all(5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    color: Colors.grey.shade900,
                  ),
                  padding: const EdgeInsets.all(10),
                  // height: 100,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            contasFiltro[index].nome.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${contasFiltro[index].quantParcelas.toString()} parcelas',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      (contasFiltro[index].pago == 1)
                          ? Text(
                              'R\$ ${contasFiltro[index].valorPago.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.green),
                            )
                          : Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      'Total: ${contasFiltro[index].valor.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.orange),
                                    ),
                                    Text(
                                      'Pago: ${contasFiltro[index].valorPago.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.green),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text(
                                      'R\$ ',
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                    Text(
                                      (contasFiltro[index].valor -
                                              contasFiltro[index].valorPago)
                                          .toStringAsFixed(2),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.redAccent),
                                    ),
                                  ],
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
}
