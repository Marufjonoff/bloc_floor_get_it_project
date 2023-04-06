import 'package:bloc_floor_get_it_project/database/dao/todo_dao.dart';
import 'package:bloc_floor_get_it_project/database/database.dart';
import 'package:bloc_floor_get_it_project/database/entity/todo_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_todo_page.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({Key? key}) : super(key: key);

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  TodoDao? todoDao;
  final database = $FloorTodoDatabase.databaseBuilder("todo.db").build();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todos", style: TextStyle(color: Colors.black),),
      ),
      body: FutureBuilder(
        future: _callTodo(),
        builder: (BuildContext context, AsyncSnapshot<TodoDao> snapshot) {
          if(!snapshot.hasData || snapshot.connectionState == ConnectionState.none) {
            return const Center(child: CupertinoActivityIndicator());
          } else {
            return StreamBuilder(
              stream: snapshot.data!.streamedData(),
              builder: (BuildContext context, AsyncSnapshot<List<Todo?>> snapshot) {
                if(!snapshot.hasData || snapshot.connectionState == ConnectionState.none) {
                  return const Center(child: CupertinoActivityIndicator());
                } else {
                  if(snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("No Data Found"),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data![snapshot.data!.length - index - 1]!.title??"Title yo'q",
                              style: const TextStyle(color: Colors.black),
                            ),
                            
                            Text(snapshot.data![snapshot.data!.length - index - 1]!.body??"Body yo'q",
                                style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)
                            ),
                            
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Created:  ${(snapshot.data![snapshot.data!.length - index - 1]!.createdAt)!.substring(11)}",
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                    
                                    Text(
                                      "Updated: ${(snapshot.data![snapshot.data!.length - index - 1]!.updatedAt)!.substring(11)}",
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.blue.shade50,
                                      child: IconButton(
                                        splashRadius: 15,
                                        icon: const Icon(Icons.edit, color: Colors.blue,),
                                        onPressed: (){
                                          _openEditTodo(snapshot, index);
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.red.shade50,
                                      child: IconButton(
                                        splashRadius: 15,
                                        icon: const Icon(Icons.delete, color: Colors.red,),
                                        onPressed: (){
                                          _delete(int.parse(snapshot.data![snapshot.data!.length - index - 1]!.id!));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTodo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // add to do
  Future<void> _openAddTodo() async {
    await Navigator.push(context, CupertinoPageRoute(builder: (_) => const AddTodoPage()));
    setState(() {});
  }

  // edit to do
  Future<void> _openEditTodo(AsyncSnapshot<List<Todo?>> snapshot, int index) async {
    await Navigator.push(context, CupertinoPageRoute(builder: (_) => AddTodoPage(
      id: snapshot.data![snapshot.data!.length - index - 1]!.id,
      todo: snapshot.data![snapshot.data!.length - index - 1],
    )));
    setState(() {});
  }

  // delete to do
  void _delete(int id) {
    todoDao!.deleteTodo(id);
    setState(() {});
  }

  // get todos
  Future<TodoDao> _callTodo() async {
    TodoDatabase todoDatabase = await database;
    todoDao = todoDatabase.todoDao;
    return todoDatabase.todoDao;
  }
}
