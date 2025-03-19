# Kartx 🛒

Kartx is a Dart package for building SQL queries in a fluent and intuitive way. Inspired by the Knex query builder, Kartx allows you to create complex queries simply and efficiently.

<br>

### Support 💖

If you find Kartx useful, please consider supporting its development 🌟[Buy Me a Coffee](https://buymeacoffee.com/evandersondev).🌟 Your support helps us improve the framework and make it even better!

<br>

## Installation

Add Kartx to your `pubspec.yaml`:

```yaml
dependencies:
  kartx: ^0.0.1
```

<br>

## Usage

### Select Queries

#### Selecting Specific Columns

```dart
final query = kartx
  .from('users')
  .select(['id', 'name'])
  .toSql();

print(query); // SELECT id, name FROM users;
```

<br>

#### Selecting with WHERE Clauses

```dart
final query = kartx
  .from('users')
  .select(['id', 'name'])
  .where('age', '>', 18)
  .toSql();

print(query); // SELECT id, name FROM users WHERE age > ?;
```

<br>

### Insert Queries

```dart
final query = kartx
  .from('users')
  .insert({'name': 'John', 'age': 30})
  .toSql();

print(query); // INSERT INTO users (name, age) VALUES (?, ?);
```

<br>

### Update Queries

```dart
final query = kartx
  .from('users')
  .update({'name': 'John Doe'})
  .where('id', '=', 1)
  .toSql();

print(query); // UPDATE users SET name = ? WHERE id = ?;
```

<br>

### Delete Queries

```dart
final query = kartx
  .from('users')
  .delete()
  .where('id', '=', 1)
  .toSql();

print(query); // DELETE FROM users WHERE id = ?;
```

<br>

### Join Queries

```dart
final query = kartx
  .from('orders')
  .select(['orders.id', 'users.name'])
  .join('users', 'orders.user_id', 'users.id')
  .toSql();

print(query); // SELECT orders.id, users.name FROM orders INNER JOIN users ON orders.user_id = users.id;
```

<br>

### Limit and Offset

```dart
final query = kartx
  .from('users')
  .select(['id', 'name'])
  .limit(10)
  .offset(5)
  .toSql();

print(query); // SELECT id, name FROM users LIMIT 10 OFFSET 5;
```

<br>

### Order By

```dart
final query = kartx
  .from('users')
  .select(['id', 'name'])
  .orderBy('name', 'DESC')
  .toSql();

print(query); // SELECT id, name FROM users ORDER BY name DESC;
```

<br>

### Aggregation Functions

```dart
final query = kartx
  .from('users')
  .count()
  .toSql();

print(query); // SELECT COUNT(*) AS total FROM users;
```

<br>

## Full API

### Methods

- `from(String table)`: Defines the table for the query.
- `select(List<String> columns)`: Defines the columns to be selected.
- `where(String column, String operator, dynamic value)`: Adds a WHERE clause.
- `orderBy(String column, [String direction = 'ASC'])`: Adds an ORDER BY clause.
- `limit(int value)`: Sets a limit on the number of results.
- `offset(int value)`: Sets an offset for the results.
- `insert(Map<String, dynamic> data)`: Defines the data for insertion.
- `update(Map<String, dynamic> data)`: Defines the data for updating.
- `delete()`: Defines a delete operation.
- `join(String table, String column1, String column2, {String type = 'INNER'})`: Adds a JOIN clause.
- `function(String function, String column, String alias)`: Defines an aggregation function.
- `count()`: Counts the number of records.
- `createTable(String table, Map<String, String> columns)`: Creates a table.
- `dropTable(String table)`: Drops a table.
- `addColumn(String columnName, String columnType)`: Adds a column.
- `dropColumn(String columnName)`: Drops a column.
- `union(Kartx otherQuery)`: Adds a UNION clause.
- `toSql()`: Generates the SQL query.
- `getParameters()`: Returns the query parameters.

<br>

### Correct Order of Methods

1. `from`
2. `select`
3. `where`
4. `orderBy`
5. `limit`
6. `offset`
7. `join`
8. `function`
9. `count`
10. `insert`
11. `update`
12. `delete`
13. `createTable`
14. `dropTable`
15. `addColumn`
16. `dropColumn`
17. `union`
18. `toSql`
19. `getParameters`

<br>

## Contribution

Contributions are welcome! Feel free to open issues and pull requests on the [GitHub repository](https://github.com/evandersondev/kartx).

<br>

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

Made with ❤️ for Dart/Flutter developers! 🎯
