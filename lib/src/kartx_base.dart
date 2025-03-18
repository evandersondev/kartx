import 'package:kartx/kartx.dart';

class Kartx {
  final DatabaseConnection _db;

  Kartx(this._db);

  /// Executa uma query utilizando o QueryBuilder.
  Future<List<Map<String, dynamic>>> query(QueryBuilder queryBuilder) async {
    // Constrói a query SQL e recupera os parâmetros.
    final sql = queryBuilder.toSql();
    final params = queryBuilder.getParameters();
    // Opcional: registre a query para depuração.
    print("Executando SQL: $sql");
    print("Parâmetros: $params");
    // Aqui você pode adicionar tratamento de erros, métricas, etc.
    return await _db.query(sql, params);
  }

  /// Método interno que efetivamente chama a execução na conexão.
  Future<void> execute(String sql, [List<dynamic>? params]) async {
    await _db.execute(sql);
  }
}
