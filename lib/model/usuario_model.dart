import 'package:meusrecebimentos/persistence/db.dart';

class Usuario{
  int id;
  String nome;
  String senha;

  Usuario(this.nome,this.senha);

  Usuario.fromJson(Map<String,dynamic> json){
    this.id=json[DatabaseCreator.id];
    this.nome=json[DatabaseCreator.nome];
    this.senha=json[DatabaseCreator.senha];
  }

}



