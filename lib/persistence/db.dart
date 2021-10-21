import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

var db;
int dbAtual = 2;

class DatabaseCreator{
  static const contaTable = 'conta';
  static const usuarioTable = 'usuario';

  static const id = 'id';
  static const nome = 'nome';
  static const descricao = 'descricao';
  static const valor = 'valor';
  static const valorPago = 'valorPago';
  static const pago = 'pago';
  static const dataPagamento = 'dataPagamento';
  static const dataVencimento = 'dataVencimento';
  static const parcela = 'parcela';
  static const quantParcelas = 'quantParcelas';

  static const senha = 'senha';


  static const migrationScripts = [
  '''CREATE TABLE $contaTable
    (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $nome TEXT NOT NULL,
      $descricao TEXT,
      $valor REAL NOT NULL,
      $valorPago REAL NOT NULL,
      $pago INTEGER NOT NULL
    )''',
    '''CREATE TABLE $usuarioTable
    (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $nome TEXT NOT NULL,
      $senha TEXT NOT NULL
    )''',
    '''ALTER TABLE $contaTable 
    ADD COLUMN $dataPagamento TEXT;''',
    '''ALTER TABLE $contaTable 
    ADD COLUMN $dataVencimento TEXT;''',
    '''ALTER TABLE $contaTable 
    ADD COLUMN $parcela INTEGER;''',
    '''ALTER TABLE $contaTable 
    ADD COLUMN $quantParcelas INTEGER;''',
  ];

  static void databaseLog(String functionName, String sql,
      [List<Map<String, dynamic>>? selectQueryResult, int? insertAndUpdateQueryResult]){
    print(functionName);
    print(sql);
    if(selectQueryResult !=null){
      print(selectQueryResult);
    }else if (insertAndUpdateQueryResult!=null){
      print(insertAndUpdateQueryResult);
    }
  }

  // Future<void> createContaTable(Database db) async{
  //   const Sql =
  //
  //   await db.execute(Sql);
  // }
  // Future<void> createUsuarioTable(Database db) async{
  //   const Sql = ;
  //
  //   await db.execute(Sql);
  // }

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
    db = await openDatabase(path, version: migrationScripts.length,
        onCreate: onCreate,
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          for (var i = oldVersion; i <= newVersion-1; i++) {
            await db.execute(migrationScripts[i]);
          }}

          );
    print(db);
  }

  Future<void> onCreate(Database db,int version) async {
    for (var i = 0; i <= version-1; i++) {
      await db.execute(migrationScripts[i]);
    }
  }

  // Future<void> onUpgrade(Database db,int oldVersion,int versionAtual) async {
  //   var batch = db.batch();
  //   if (versionAtual <= 1){
  //     // await createContaTable(db);
  //     // await createUsuarioTable(db);
  //   }else if(versionAtual <= 2){
  //     const sql = '''ALTER TABLE $contaTable
  //         ADD $dataPagamento VARCHAR(10),
  //         $dataVencimento VANCHAR(10),
  //         $parcela INT default 0,
  //         $quantParcelas INT default 1 ;''';
  //     batch.execute(sql);
  //   }
  //   await batch.commit();
  // }
  
}