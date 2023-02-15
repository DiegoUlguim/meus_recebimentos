import 'package:meus_recebimentos/persistence/db.dart';

class Pagamento{
  int id = 0;
  int idConta;
  double valor = 0;
  String data = (DateTime.now().toIso8601String()).substring(0, 10);
  int parcela = 0;

  Pagamento(this.idConta,this.valor,this.data,this.parcela,{this.id=0});

  Pagamento.fromJson(Map<String,dynamic> json){
    this.id=json[DatabaseCreator.id];
    this.idConta=json[DatabaseCreator.idConta];
    this.valor=json[DatabaseCreator.valor];
    this.data=json[DatabaseCreator.data] ?? '';
    this.parcela=json[DatabaseCreator.parcela] ?? 0;
  }

}



