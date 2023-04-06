import 'package:bloc_floor_get_it_project/database/dao/todo_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';
import 'package:floor/floor.dart';

import 'entity/todo_entity.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Todo])
abstract class TodoDatabase extends FloorDatabase  {
  TodoDao get todoDao;
}