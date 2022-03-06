import 'package:flutter/material.dart';
import 'package:meus_recebimentos/model/conta_model.dart';
import 'package:meus_recebimentos/services/conta_service.dart';
// import 'package:toast/toast.dart';

class AlteraContaPage extends StatefulWidget {
  const AlteraContaPage({Key key, this.title, this.conta}) : super(key: key);

  final String title;
  final Conta conta;

  @override
  _AlteraContaPageState createState() => _AlteraContaPageState(conta: conta);
}

class _AlteraContaPageState extends State<AlteraContaPage> {
  _AlteraContaPageState({this.conta});
  final Conta conta;

  final txtValorPago = TextEditingController();


  String _validaConta(){
    if(txtValorPago.text == "") {
      return "Favor Informar o Valor Pago!";
    }

    List<String> valorTeste = txtValorPago.text.split(".");
    if(valorTeste.length > 2){
      return "O valor pago não pode conter mais de um ponto!";
    }

    return "";
  }

  Future<void> _alteraConta() async{
    String mens = _validaConta();
    if(mens != ""){
      // Toast.show(mens, context,duration: 3);
    }

    conta.valorPago += double.parse(txtValorPago.text.replaceAll(',', '.'));

    if(conta.valorPago >= conta.valor) {
      conta.pago = 1;
    }

    await ContaService.updateConta(conta);
    // Toast.show("Alteração de conta realizado com sucesso!", context,duration: 3);
    Navigator.pop(context);
  }

  Widget buildText(String label, BuildContext context, {
    IconData icon,
    TextEditingController campoText,
    TextInputType textInputType = TextInputType.text,
    bool obscureText = false,var funcao,double width})
  {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 10.0,left: 10.0),

      child: TextField(
        controller: campoText,
        keyboardType: textInputType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
        ),
        onChanged: funcao,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),

      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Colors.black,
            height: MediaQuery.of(context).size.height/12.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      // padding: EdgeInsets.only(
                      //     left: MediaQuery.of(context).size.width/6.1,
                      //     right: MediaQuery.of(context).size.width/6.1
                      // ),
                      //color: Colors.white,
                      onPressed: _alteraConta,
                      child: const Text(
                        "ALTERAR",
                        style: TextStyle(color: Colors.white,fontSize: 24),
                      ),
                    ),
                  ],
                ),
              ],
            )
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 10,left: 10),
              child: Text(conta.nome.toUpperCase()
                ,style: const TextStyle(fontSize: 30,color: Colors.deepPurpleAccent)),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 10,left: 10),
              child: Text(conta.descricao.toUpperCase()
                  ,style: const TextStyle(fontSize: 18,color: Colors.grey)),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 10,left: 10),
              child: Text(conta.dataVencimento
                  ,style: const TextStyle(fontSize: 18,color: Colors.grey)),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(top: 25,right: 10),
              child: Text('VALOR: ' + conta.valor.toStringAsFixed(2)
                  ,style: const TextStyle(fontSize: 24,color: Colors.black)),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 10),
              child: Text('VALOR PAGO: ' + conta.valorPago.toStringAsFixed(2)
                  ,style: const TextStyle(fontSize: 15,color: Colors.green,fontStyle: FontStyle.italic)),
            ),
            Container(
              color: Colors.black,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 10),
              margin: const EdgeInsets.only(bottom: 20),
              child: Text('RESTA: ' + (conta.valor-conta.valorPago).toStringAsFixed(2)
                  ,style: const TextStyle(fontSize: 24,color: Colors.white,fontStyle: FontStyle.italic)),
            ),
            buildText('Valor Pago', context,campoText: txtValorPago,textInputType: TextInputType.number),


          ],
        ),
      ),
    );
  }
}
