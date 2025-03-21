import 'package:kartx/kartx.dart';

Future<void> main() async {
  // final createTableSql =
  //     kartx.createTable('users', {
  //       'id': 'INT PRIMARY KEY AUTO_INCREMENT',
  //       'name': 'VARCHAR(255)',
  //       'email': 'VARCHAR(255) UNIQUE',
  //       'created_at': 'TIMESTAMP DEFAULT CURRENT_TIMESTAMP',
  //     }).toSql();
  // print(createTableSql);

  final sql = Kartx().from('users').insert({
    'name': 'John Doe',
    'email': 'john@example.com',
  });

  print(sql.toSql());
  print(sql.getParameters());
}
