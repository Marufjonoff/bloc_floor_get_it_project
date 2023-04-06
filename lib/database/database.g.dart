// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorTodoDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$TodoDatabaseBuilder databaseBuilder(String name) =>
      _$TodoDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$TodoDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$TodoDatabaseBuilder(null);
}

class _$TodoDatabaseBuilder {
  _$TodoDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$TodoDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$TodoDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<TodoDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$TodoDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$TodoDatabase extends TodoDatabase {
  _$TodoDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TodoDao? _todoDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Todo` (`createdAt` TEXT PRIMARY KEY AUTOINCREMENT, `title` TEXT, `body` TEXT, `updatedAt` TEXT, `id` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TodoDao get todoDao {
    return _todoDaoInstance ??= _$TodoDao(database, changeListener);
  }
}

class _$TodoDao extends TodoDao {
  _$TodoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _todoInsertionAdapter = InsertionAdapter(
            database,
            'Todo',
            (Todo item) => <String, Object?>{
                  'createdAt': item.createdAt,
                  'title': item.title,
                  'body': item.body,
                  'updatedAt': item.updatedAt,
                  'id': item.id
                },
            changeListener),
        _todoUpdateAdapter = UpdateAdapter(
            database,
            'Todo',
            ['createdAt'],
            (Todo item) => <String, Object?>{
                  'createdAt': item.createdAt,
                  'title': item.title,
                  'body': item.body,
                  'updatedAt': item.updatedAt,
                  'id': item.id
                },
            changeListener),
        _todoDeletionAdapter = DeletionAdapter(
            database,
            'Todo',
            ['createdAt'],
            (Todo item) => <String, Object?>{
                  'createdAt': item.createdAt,
                  'title': item.title,
                  'body': item.body,
                  'updatedAt': item.updatedAt,
                  'id': item.id
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Todo> _todoInsertionAdapter;

  final UpdateAdapter<Todo> _todoUpdateAdapter;

  final DeletionAdapter<Todo> _todoDeletionAdapter;

  @override
  Future<List<Todo>> findAllTodos() async {
    return _queryAdapter.queryList('select * from todo',
        mapper: (Map<String, Object?> row) => Todo(
            createdAt: row['createdAt'] as String?,
            title: row['title'] as String?,
            body: row['body'] as String?,
            updatedAt: row['updatedAt'] as String?,
            id: row['id'] as String?));
  }

  @override
  Future<Todo?> getMaxId() async {
    return _queryAdapter.query('select * from todo order by id desc limit 1',
        mapper: (Map<String, Object?> row) => Todo(
            createdAt: row['createdAt'] as String?,
            title: row['title'] as String?,
            body: row['body'] as String?,
            updatedAt: row['updatedAt'] as String?,
            id: row['id'] as String?));
  }

  @override
  Stream<List<Todo?>> streamedData() {
    return _queryAdapter.queryListStream('select * from todo order by id desc',
        mapper: (Map<String, Object?> row) => Todo(
            createdAt: row['createdAt'] as String?,
            title: row['title'] as String?,
            body: row['body'] as String?,
            updatedAt: row['updatedAt'] as String?,
            id: row['id'] as String?),
        queryableName: 'todo',
        isView: false);
  }

  @override
  Future<void> deleteTodo(int id) async {
    await _queryAdapter
        .queryNoReturn('delete from todo where id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertTodo(Todo todo) async {
    await _todoInsertionAdapter.insert(todo, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    await _todoUpdateAdapter.update(todo, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteAll(List<Todo> list) {
    return _todoDeletionAdapter.deleteListAndReturnChangedRows(list);
  }
}
