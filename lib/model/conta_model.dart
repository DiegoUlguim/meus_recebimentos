import 'package:meusrecebimentos/persistence/db.dart';

class Conta{
  int id;
  String nome;
  String descricao;
  double valor;
  double valorPago;
  int pago;

  Conta(this.nome,this.valor,{this.descricao="",this.valorPago=0,this.pago=0});

  Conta.fromJson(Map<String,dynamic> json){
    this.id=json[DatabaseCreator.id];
    this.nome=json[DatabaseCreator.nome];
    this.descricao=json[DatabaseCreator.descricao];
    this.valor=json[DatabaseCreator.valor];
    this.valorPago=json[DatabaseCreator.valorPago];
    this.pago=json[DatabaseCreator.pago];
  }

}



