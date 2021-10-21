import 'package:flutter/material.dart';
import 'package:meus_recebimentos/model/conta_model.dart';
import 'package:meus_recebimentos/services/conta_service.dart';

import '../geral.dart';
import '../util_widget.dart';
// import 'package:toast/toast.dart';

class CadastroContaPage extends StatefulWidget {
  const CadastroContaPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _CadastroContaPageState createState() => _CadastroContaPageState();
}

class _CadastroContaPageState extends State<CadastroContaPage> {

  final txtNome = TextEditingController();
  final txtDescricao = TextEditingController();
  final txtValor = TextEditingController();
  final txtValorPago = TextEditingController();
  DateTime dataPrimeiroPagamento=DateTime.now();
  final txtQuantParcelas = TextEditingController();
  final txtDataVencimento = TextEditingController();

  List<Conta> contas = [Conta('',0.0,DateTime.now().toString(),'',0,1)];

  final List<DropdownMenuItem<int>> _dropDownParcelas = [
    DropdownMenuItem(value: 1, child: textFormatDropDown(" 1  "))
    ,DropdownMenuItem(value: 2, child: textFormatDropDown(" 2 "))
    ,DropdownMenuItem(value: 3, child: textFormatDropDown(" 3 "))
    ,DropdownMenuItem(value: 4, child: textFormatDropDown(" 4 "))
    ,DropdownMenuItem(value: 5, child: textFormatDropDown(" 5 "))
    ,DropdownMenuItem(value: 6, child: textFormatDropDown(" 6 "))
    ,DropdownMenuItem(value: 7, child: textFormatDropDown(" 7 "))
    ,DropdownMenuItem(value: 8, child: textFormatDropDown(" 8 "))
    ,DropdownMenuItem(value: 9, child: textFormatDropDown(" 9 "))
    ,DropdownMenuItem(value: 10, child: textFormatDropDown(" 10 "))
    ,DropdownMenuItem(value: 11, child: textFormatDropDown(" 11 "))
    ,DropdownMenuItem(value: 12, child: textFormatDropDown(" 12 "))
  ];
  int _currentParcelas = 1;

  void changedDropDownItemParcelas(int? selectedStatus) {
    setState(() {
      _currentParcelas = selectedStatus??1;
    });
  }

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
      // Toast.show(mens, context,duration: 3);
      return;
    }
    Conta conta = Conta(
        txtNome.text.trim(),
        double.parse(txtValor.text.replaceAll(',', '.')),
        (DateTime.now().toIso8601String()).substring(0, 10),
        (DateTime.now().toIso8601String()).substring(0, 10),
        0,
        int.parse(txtQuantParcelas.text),
        descricao: txtDescricao.text.trim(),
        valorPago: double.parse(txtValorPago.text.replaceAll(',', '.')),
    );
    await ContaService.addConta(conta);
    // Toast.show("Cadastro de conta realizado com sucesso!", context,duration: 3);
    Navigator.pop(context);
  }

  Widget buildText(String label, BuildContext context, {
    IconData? icon,
    TextEditingController? campoText,
    TextInputType textInputType = TextInputType.text,
    bool obscureText = false,var funcao, double? width})
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
  void _atualizaInformacoes(){

    List<Conta> contasVar = [];
    int parcelas = _currentParcelas;
    for (int parcela = 0;parcela<parcelas;parcela++){
      Conta conta = Conta(
        txtNome.text.trim(),
        txtValor.text.trim()==''?0:double.parse(txtValor.text.replaceAll(',', '.')),
        (DateTime.now().toIso8601String()).substring(0, 10),
        (DateTime.now().toIso8601String()).substring(0, 10),
        parcela+1,
        _currentParcelas,
        descricao: txtDescricao.text.trim(),
        valorPago: txtValor.text.trim()==''?0:double.parse(txtValorPago.text.replaceAll(',', '.')),
      );
      contasVar.add(conta);
    }
    contas = contasVar;
  }

  @override
  Widget build(BuildContext context) {
    _atualizaInformacoes();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.save,size: 30,color: Colors.white,),
        onPressed: _adicionaConta,
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Container(
      //       color: Colors.black,
      //       height: MediaQuery.of(context).size.height/12.0,
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         children: <Widget>[
      //           Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: <Widget>[
      //               FlatButton(
      //                 padding: EdgeInsets.only(
      //                     left: MediaQuery.of(context).size.width/6.1,
      //                     right: MediaQuery.of(context).size.width/6.1
      //                 ),
      //                 //color: Colors.white,
      //                 onPressed: _adicionaConta,
      //                 child: const Text(
      //                   "CADASTRAR",
      //                   style: TextStyle(color: Colors.white,fontSize: 24),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ],
      //       )
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            buildText('Nome', context,campoText: txtNome),
            buildText('Descrição', context,campoText: txtDescricao),
            buildText('Valor', context,campoText: txtValor, textInputType: TextInputType.number),
            buildText('Valor Pago', context,campoText: txtValorPago, textInputType: TextInputType.number),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 100,
                  margin: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      const Text('Quantidade'),
                      DropdownButton(
                        isExpanded: true,
                        hint: const Text("Parcelas"),
                        value: _currentParcelas,
                        items: _dropDownParcelas,
                        onChanged: changedDropDownItemParcelas,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 140,
                  child: Column(
                    children: [
                      const Text('Primeiro Pagamento'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(retornaDataVisualFormat(dataPrimeiroPagamento)),
                          IconButton(
                            icon: const Icon(Icons.date_range),
                            onPressed: (){
                              showDatePicker(context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2018),
                                  lastDate: DateTime(2030)
                              ).then((value) => {
                                setState((){dataPrimeiroPagamento = value!;})
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(top: 10,bottom: 10),
              alignment: Alignment.center,
              child: const Text('Parcelas',style: TextStyle(color: Colors.white,fontSize: 15),),
            ),
            Container(
              height: 300,
              child: ListView.builder(
                itemCount: contas.length,
                itemBuilder: (context,int index){
                  return Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 0),
                        ),
                      ],
                      borderRadius: BorderRadius.all(
                          Radius.circular(15)
                      ),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.only(left: 10),
                    margin: const EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(contas[index].parcela.toString()),
                            Text(retornaDataVisualFormat(DateTime.parse(contas[index].dataVencimento))),
                          ],
                        ),

                      ],
                    ),
                  );
                }),
              ),



          ],
        ),
      ),
    );
  }
}
