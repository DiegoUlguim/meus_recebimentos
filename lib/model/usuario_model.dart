import 'package:meus_recebimentos/persistence/db.dart';

class Usuario{
  int id = 0;
  String nome = '';
  String senha = '';

  Usuario(this.nome,this.senha,{this.id=0});

  Usuario.fromJson(Map<String,dynamic> json){
    this.id=json[DatabaseCreator.id]??0;
    this.nome=json[DatabaseCreator.nome]??'';
    this.senha=json[DatabaseCreator.senha]??'';
  }

}



