import 'package:mysql1/mysql1.dart' as mysql;
import 'package:postgres/postgres.dart';
import 'package:sqlite3/sqlite3.dart';

class DatabaseConnection {
  final String databaseType;
  mysql.MySqlConnection? _mysqlConnection;
  Connection? _postgresConnection;
  Database? _sqliteDatabase;

  DatabaseConnection({required this.databaseType});

  Future<void> connect({
    required String host,
    int? port,
    required String user,
    required String password,
    required String database,
  }) async {
    if (databaseType == 'mysql') {
      final settings = mysql.ConnectionSettings(
        host: host,
        port: port ?? 3306,
        user: user,
        password: password,
        db: database,
      );
      final conn = await mysql.MySqlConnection.connect(settings);
      _mysqlConnection = conn;
    } else if (databaseType == 'postgres') {
      final endpoint = Endpoint(
        host: host,
        database: database,
        username: user,
        password: password,
      );
      _postgresConnection = await Connection.open(
        endpoint,
        settings: ConnectionSettings(sslMode: SslMode.disable),
      );
    } else if (databaseType == 'sqlite') {
      // Sugestão: separar o caso de abertura in-memory em um bloco else
      if (host == ':memory:') {
        _sqliteDatabase = sqlite3.openInMemory();
      } else {
        final dbPath = 'database/$database';
        _sqliteDatabase = sqlite3.open(dbPath);
      }
    } else {
      throw Exception("Banco de dados não suportado!");
    }
  }

  Future<List<Map<String, dynamic>>> query(
    String sql,
    List<dynamic> params,
  ) async {
    if (databaseType == 'mysql' && _mysqlConnection != null) {
      var results = await _mysqlConnection!.query(sql, params);
      return results.map((row) => row.fields).toList();
    } else if (databaseType == 'postgres' && _postgresConnection != null) {
      // Substituição simples dos parâmetros: cuidado com interrogações que não sejam parâmetros.
      String sqlRaw = sql;
      for (var i = 1; i <= params.length; i++) {
        sqlRaw = sqlRaw.replaceFirst('?', '\$$i');
      }
      var result = await _postgresConnection!.execute(
        sqlRaw,
        parameters: params,
      );
      return result.map((row) => row.toColumnMap()).toList();
    } else if (databaseType == 'sqlite' && _sqliteDatabase != null) {
      final stmt = _sqliteDatabase!.prepare(sql);
      final result = stmt.select(params);
      return result.map((row) {
        // row.toTableColumnMap() retorna Map<String?, Map<String, dynamic>?>
        final nestedMap = row.toTableColumnMap();
        final flattened = <String, dynamic>{};
        nestedMap?.forEach((table, colMap) {
          flattened.addAll(colMap);
        });
        return flattened;
      }).toList();
    } else {
      throw Exception("Nenhuma conexão ativa!");
    }
  }

  Future<void> execute(String sql, [List<dynamic>? params]) async {
    if (databaseType == 'mysql' && _mysqlConnection != null) {
      if (params == null) {
        await _mysqlConnection?.query(sql);
      } else {
        await _mysqlConnection?.query(sql, params);
      }
    } else if (databaseType == 'postgres' && _postgresConnection != null) {
      if (params == null) {
        await _postgresConnection!.execute(sql);
      } else {
        String sqlRaw = sql;
        for (var i = 1; i <= params.length; i++) {
          sqlRaw = sqlRaw.replaceFirst('?', '\$$i');
        }
        await _postgresConnection!.execute(sqlRaw, parameters: params);
      }
    } else if (databaseType == 'sqlite' && _sqliteDatabase != null) {
      final stmt = _sqliteDatabase!.prepare(sql);
      if (params == null) {
        stmt.execute();
      } else {
        stmt.execute(params);
      }
      stmt.dispose();
    } else {
      throw Exception("Nenhuma conexão ativa!");
    }
  }

  Future<void> close() async {
    await _mysqlConnection?.close();
    await _postgresConnection?.close();
    _sqliteDatabase?.dispose();
  }
}
