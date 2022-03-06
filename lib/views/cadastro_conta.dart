import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:meus_recebimentos/model/conta_model.dart';
import 'package:meus_recebimentos/services/conta_service.dart';

import '../geral.dart';
import '../util_widget.dart';
// import 'package:toast/toast.dart';

class CadastroContaPage extends StatefulWidget {
  const CadastroContaPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CadastroContaPageState createState() => _CadastroContaPageState();
}

class _CadastroContaPageState extends State<CadastroContaPage> {

  final txtNome = TextEditingController();
  final txtDescricao = TextEditingController();
  final txtValor = MoneyMaskedTextController();
  final txtValorPago = MoneyMaskedTextController();
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

  void changedDropDownItemParcelas(int selectedStatus) {
    _currentParcelas = selectedStatus??1;
    _atualizaInformacoes();
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    txtValor.updateValue(0);
    txtValorPago.updateValue(0);
  }

  String _validaConta(){
    String validacao = '';
    if(txtNome.text.trim()=="") validacao += "Favor informar o nome!\n";
    // if(txtValor.text.trim()=="")  txtValor.updateValue(0);
    // if(txtValorPago.text.trim()=="")  txtValorPago.updateValue(0);

    // if(txtValor.text.contains("-")){
    //   validacao += "O valor não pode ser negativo!\n";
    // }
    // if(txtValorPago.text.contains("-")){
    //   validacao += "O valor pago não pode ser negativo!\n";
    // }

    // List<String> valorTeste = txtValor.text.split(".");
    // if(valorTeste.length > 2){
    //   validacao += "O valor não pode conter mais de um ponto!\n";
    // }
    // valorTeste = txtValorPago.text.split(".");
    // if(valorTeste.length > 2){
    //   validacao += "O valor pago não pode conter mais de um ponto!";
    // }

    return validacao;
  }


  void _adicionaConta() async{
    String mens = _validaConta();
    if( mens != ""){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mens)));
      return;
    }
    await ContaService.addConta(contas.first);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro de conta realizado com sucesso!')));
    Navigator.pop(context);
  }


  void _atualizaInformacoes(){

    List<Conta> contasVar = [];
    DateTime _data = dataPrimeiroPagamento;
    for (int parcela = 0;parcela<_currentParcelas;parcela++){
      Conta conta = Conta(
        txtNome.text.trim(),
        txtValor.numberValue,
        _data.toIso8601String().substring(0, 10),
        null,
        parcela+1,
        _currentParcelas,
        descricao: txtDescricao.text.trim(),
        valorPago: txtValorPago.numberValue,
      );
      contasVar.add(conta);
      _data = DateTime(_data.year, _data.month + 1, _data.day);
    }
    contas = contasVar;
  }

  @override
  Widget build(BuildContext context) {
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
                                  initialDate: dataPrimeiroPagamento,
                                  firstDate: DateTime(2018),
                                  lastDate: DateTime(2030)
                              ).then((value) {
                                if(value!=null){
                                  dataPrimeiroPagamento = value;
                                  _atualizaInformacoes();
                                  setState((){});
                                }
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
            SizedBox(
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
