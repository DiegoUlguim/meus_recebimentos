import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Database db;

class DatabaseCreator{
  static const contaTable = 'conta';
  static const id = 'id';
  static const nome = 'nome';
  static const descricao = 'descricao';
  static const valor = 'valor';
  static const valorPago = 'valorPago';
  static const pago = 'pago';

  static void databaseLog(String functionName, String sql,
      [List<Map<String, dynamic>> selectQueryResult, int insertAndUpdateQueryResult]){
    print(functionName);
    print(sql);
    if(selectQueryResult !=null){
      print(selectQueryResult);
    }else if (insertAndUpdateQueryResult!=null){
      print(insertAndUpdateQueryResult);
    }
  }

  Future<void> createContaTable(Database db) async{
    final Sql = '''CREATE TABLE $contaTable
    (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $nome TEXT NOT NULL,
      $descricao TEXT,
      $valor REAL NOT NULL,
      $valorPago REAL NOT NULL,
      $pago INTEGER NOT NULL
    )''';

    await db.execute(Sql);
  }

  Future<String> getDatabasePath(String dbName) async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath,dbName);

    if(await Directory(dirname(path)).exists()){
      //await deleteDatabase(path);
    }else{
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initDatabase() async{
    final path = await getDatabasePath('conta_db');
    db = await openDatabase(path,version: 1,onCreate: onCreate);
    print(db);
  }

  Future<void> onCreate(Database db,int version) async{
    await createContaTable(db);
  }

  
}