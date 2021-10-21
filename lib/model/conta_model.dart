import 'package:meus_recebimentos/persistence/db.dart';

class Conta{
  int id = 0;
  String nome = '';
  String descricao = '';
  double valor = 0;
  double valorPago = 0;
  int pago = 0;

  String dataPagamento = (DateTime.now().toIso8601String()).substring(0, 10);
  String dataVencimento = (DateTime.now().toIso8601String()).substring(0, 10);
  int parcela = 0;
  int quantParcelas = 1;

  Conta(this.nome,this.valor,this.dataVencimento,this.dataPagamento,this.parcela,this.quantParcelas,{this.id=0,this.descricao="",this.valorPago=0,this.pago=0});

  Conta.fromJson(Map<String,dynamic> json){
    this.id=json[DatabaseCreator.id];
    this.nome=json[DatabaseCreator.nome];
    this.descricao=json[DatabaseCreator.descricao];
    this.valor=json[DatabaseCreator.valor];
    this.valorPago=json[DatabaseCreator.valorPago];
    this.pago=json[DatabaseCreator.pago];

    this.dataPagamento=json[DatabaseCreator.dataPagamento] ?? '';
    this.dataVencimento=json[DatabaseCreator.dataVencimento] ?? '';
    this.parcela=json[DatabaseCreator.parcela] ?? 0;
    this.quantParcelas=json[DatabaseCreator.quantParcelas] ?? 1;
  }

}



