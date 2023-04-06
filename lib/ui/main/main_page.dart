import 'dart:convert';

import 'package:bloc_floor_get_it_project/core/services/log_service.dart';
import 'package:bloc_floor_get_it_project/data/provider/api_client.dart';
import 'package:bloc_floor_get_it_project/database/entity/todo_entity.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ApiClient _client = ApiClient();
  bool isLoading = true;
  List<Todo> todos = [];

  Future<void> getData() async {
    final response = await _client.getData('/todo');
    List<Todo> todo = (response.data as List).map((e) => Todo.fromJson(e)).toList();

    setState(() {
      todos = todo;
      isLoading = false;
    });
    LogService.instance.w(response.data);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Page"),
      ),
      body: isLoading ? const CircularProgressIndicator() :
      todos.isEmpty
          ? const Center(child: Text("Todo bo'sh"))
          : ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todos[index].title??""),
            subtitle: Text(todos[index].body??""),
            leading: Text(todos[index].id??""),
          );
        },
      ),
    );
  }
}
