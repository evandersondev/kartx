import 'dart:io';

import 'package:kartx/kartx.dart';

Future<void> main() async {
  var db = DatabaseConnection(databaseType: 'mysql');
  bool connected = false;
  int retries = 0;
  while (!connected && retries < 5) {
    try {
      await db.connect(
        host: 'localhost',
        user: 'user',
        password: 'userpassword',
        database: 'mydb',
        port: 3307,
      );
      connected = true;
      print("Conectado ao MySQL");
    } catch (e) {
      retries++;
      print("Tentativa $retries: erro ao conectar - $e");
      await Future.delayed(Duration(seconds: 5));
    }
  }

  if (!connected) {
    print("Não foi possível conectar ao MySQL.");
    exit(1);
  }

  // Teste a criação de tabela
  final createTableSql =
      QueryBuilder().createTable('users', {
        'id': 'INT PRIMARY KEY AUTO_INCREMENT',
        'name': 'VARCHAR(255)',
        'email': 'VARCHAR(255) UNIQUE',
        'created_at': 'TIMESTAMP DEFAULT CURRENT_TIMESTAMP',
      }).toSql();

  // Remova o ponto e vírgula final, se presente

  try {
    await Kartx(db).execute(createTableSql);
    print("Tabela 'users' criada com sucesso!");
  } catch (e) {
    print("Erro ao executar a query de criação de tabela: $e");
  } finally {
    await db.close();
  }
}
