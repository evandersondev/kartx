import 'package:kartx/kartx.dart';

Future<void> main() async {
  final createTableSql =
      kartx.createTable('users', {
        'id': 'INT PRIMARY KEY AUTO_INCREMENT',
        'name': 'VARCHAR(255)',
        'email': 'VARCHAR(255) UNIQUE',
        'created_at': 'TIMESTAMP DEFAULT CURRENT_TIMESTAMP',
      }).toSql();
  print(createTableSql);

  var sql =
      kartx
          .from('users')
          .select(['id', 'name'])
          .where('status', '=', 'active')
          .orderBy('name')
          .toSql();

  print(sql);
}
