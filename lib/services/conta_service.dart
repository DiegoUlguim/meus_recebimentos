import 'package:meus_recebimentos/model/conta_model.dart';
import 'package:meus_recebimentos/persistence/db.dart';

class ContaService{
 static Future<List<Conta>> getAllConta({bool pago=false}) async{
   final sql = '''SELECT * FROM ${DatabaseCreator.contaTable}
   WHERE ${DatabaseCreator.pago} == ${pago}''';
   final data = await db.rawQuery(sql);
   List<Conta> contas = [];

   for (final node in data){
     final conta = Conta.fromJson(node);
     contas.add(conta);
   }
   return contas;
 }

 static Future<Conta> getConta(int id) async{
   final sql = '''SELECT * FROM ${DatabaseCreator.contaTable}
   WHERE ${DatabaseCreator.id} == $id''';
   final data =await db.rawQuery(sql);

   final conta = Conta.fromJson(data[0]);
   return conta;
 }

 static Future<void> addConta(Conta conta) async{
   final sql = '''INSERT INTO ${DatabaseCreator.contaTable}
   (
      ${DatabaseCreator.nome},
      ${DatabaseCreator.descricao},
      ${DatabaseCreator.valor},
      ${DatabaseCreator.valorPago},
      ${DatabaseCreator.pago},
      ${DatabaseCreator.dataPagamento},
      ${DatabaseCreator.dataVencimento},
      ${DatabaseCreator.parcela},
      ${DatabaseCreator.quantParcelas}
   )
   VALUES
   (
      '${conta.nome}',
      '${conta.descricao}',
      ${conta.valor},
      ${conta.valorPago},
      ${conta.pago},
      '${conta.dataPagamento}',
      '${conta.dataVencimento}',
      ${conta.parcela},
      ${conta.quantParcelas}
   )''';
   
   final result = await db.rawInsert(sql);
   DatabaseCreator.databaseLog('Add Conta', sql,[], result);
 }

 static Future<void> deleteConta(int id) async{
   final sql = '''DELETE FROM ${DatabaseCreator.contaTable}
   WHERE ${DatabaseCreator.id} == ${id}''';

   final result = await db.rawDelete(sql);
   DatabaseCreator.databaseLog('Delete Conta', sql,[],result);
 }

 static Future<void> updateConta(Conta conta) async{
   final sql = '''UPDATE ${DatabaseCreator.contaTable}
   SET 
    ${DatabaseCreator.nome} = '${conta.nome}',
    ${DatabaseCreator.descricao} = '${conta.descricao}',
    ${DatabaseCreator.valor} = '${conta.valor}',
    ${DatabaseCreator.valorPago} = '${conta.valorPago}',
    ${DatabaseCreator.pago} = ${conta.pago},
    ${DatabaseCreator.dataVencimento} = '${conta.dataVencimento}',
    ${DatabaseCreator.dataPagamento} = '${conta.dataPagamento}',
    ${DatabaseCreator.parcela} = ${conta.parcela},
    ${DatabaseCreator.quantParcelas} = ${conta.quantParcelas}
    
    WHERE ${DatabaseCreator.id} = ${conta.id}''';

   final result = await db.rawUpdate(sql);
   DatabaseCreator.databaseLog('Update Conta', sql,[],result);
 }

 static Future<int> contaCount() async{
   final data = await db.rawQuery('''SELECT COUNT(*) FROM ${DatabaseCreator.contaTable}''');

   int count = data[0].values.elementAt(0) as int;
   return count;
 }

 static Future<String> retornaTotal() async{
   final data = await db.rawQuery('''SELECT SUM(${DatabaseCreator.valor}) 
   FROM ${DatabaseCreator.contaTable}
   WHERE ${DatabaseCreator.pago}=0''');

   return double.parse(data[0].values.elementAt(0).toString()).toStringAsFixed(2);
 }

 static Future<String> retornaRestante() async{
   final data = await db.rawQuery('''SELECT SUM(${DatabaseCreator.valor}- ${DatabaseCreator.valorPago}) 
   FROM ${DatabaseCreator.contaTable}
   WHERE ${DatabaseCreator.pago}=0''');

   return double.parse((data[0].values.elementAt(0)).toString()).toStringAsFixed(2);
 }

}