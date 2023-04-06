import 'dart:convert';
//
import 'package:floor/floor.dart';

List<Todo> todoFromJson(String str) => List<Todo>.from(json.decode(str).map((x) => Todo.fromJson(x)));
//
// String todoToJson(List<Todo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@entity
class Todo {

  Todo({
    this.createdAt,
    this.title,
    this.body,
    this.updatedAt,
    this.id,
  });

  @PrimaryKey(autoGenerate: true)
  String? createdAt;
  String? title;
  String? body;
  String? updatedAt;
  String? id;

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    createdAt: json["createdAt"],
    title: json["title"],
    body: json["body"],
    updatedAt: json["updatedAt"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt,
    "title": title,
    "body": body,
    "updatedAt": updatedAt,
    "id": id,
  };
}
