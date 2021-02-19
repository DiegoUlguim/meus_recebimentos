import 'package:flutter/material.dart';
import 'package:meusrecebimentos/model/conta_model.dart';
import 'package:meusrecebimentos/services/conta_service.dart';
import 'package:toast/toast.dart';

class CadastroContaPage extends StatefulWidget {
  CadastroContaPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CadastroContaPageState createState() => _CadastroContaPageState();
}

class _CadastroContaPageState extends State<CadastroContaPage> {

  final txtNome = TextEditingController();
  final txtDescricao = TextEditingController();
  final txtValor = TextEditingController();
  final txtValorPago = TextEditingController();

  String _validaConta(){
    if(txtNome.text.trim()=="") return "Favor informar o nome";
    if(txtValor.text.trim()=="")  txtValor.text = "0";
    if(txtValorPago.text.trim()=="")  txtValorPago.text = "0";

    if(txtValor.text.contains("-")){
      return "O valor não pode ser negativo!";
    }
    if(txtValorPago.text.contains("-")){
      return "O valor pago não pode ser negativo!";
    }

    List<String> valorTeste = txtValor.text.split(".");
    if(valorTeste.length > 2){
      return "O valor não pode conter mais de um ponto!";
    }
    valorTeste = txtValorPago.text.split(".");
    if(valorTeste.length > 2){
      return "O valor pago não pode conter mais de um ponto!";
    }

    return "";
  }


  Future<void> _adicionaConta() async{
    String mens = _validaConta();
    if( mens != ""){
      Toast.show(mens, context,duration: 3);
      return;
    }
    Conta conta = new Conta(
        txtNome.text.trim(),
        double.parse(txtValor.text.replaceAll(',', '.')),
        descricao: txtDescricao.text.trim(),
        valorPago: double.parse(txtValorPago.text.replaceAll(',', '.'))
    );
    await ContaService.addConta(conta);
    Toast.show("Cadastro de conta realizado com sucesso!", context,duration: 3);
    Navigator.pop(context);
  }

  Widget buildText(String label, BuildContext context, {
    IconData icon,
    TextEditingController campoText,
    TextInputType textInputType = TextInputType.text,
    bool obscureText = false,Function funcao,double width})
  {
    return new Container(
      width: width,
      margin: EdgeInsets.only(right: 10.0,left: 10.0),

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
                    FlatButton(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width/6.1,
                          right: MediaQuery.of(context).size.width/6.1
                      ),
                      //color: Colors.white,
                      onPressed: _adicionaConta,
                      child: Text(
                        "CADASTRAR",
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
            buildText('Nome', context,campoText: txtNome),
            buildText('Descrição', context,campoText: txtDescricao),
            buildText('Valor', context,campoText: txtValor, textInputType: TextInputType.number),
            buildText('Valor Pago', context,campoText: txtValorPago, textInputType: TextInputType.number),
          ],
        ),
      ),
    );
  }
}
