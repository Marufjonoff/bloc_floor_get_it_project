import 'package:bloc_floor_get_it_project/database/database.dart';
import 'package:bloc_floor_get_it_project/database/entity/todo_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTodoPage extends StatefulWidget {
  final String? id;
  final Todo? todo;
  const AddTodoPage({Key? key, this.id, this.todo}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _bodyEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.id != null && widget.todo != null) {
      _textEditingController.text = widget.todo!.title!;
      _bodyEditingController.text = widget.todo!.body!;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingController.clear();
    _bodyEditingController.clear();
  }

  void _addTodoItem() {
    final database = $FloorTodoDatabase.databaseBuilder("todo.db").build();
    database.then((value) {
      value.todoDao.getMaxId().then((val){
        int id = 1;
        if (val != null) id = int.parse(val.id!) + 1;
        value.todoDao.insertTodo(Todo(
            id: widget.id!,
            title: _textEditingController.text,
            body: _bodyEditingController.text,
            createdAt: DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
         updatedAt: DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
        ));
      });
    });
    Navigator.pop(context, true);
  }

  void _saveEdit() {
    final database = $FloorTodoDatabase.databaseBuilder("todo.db").build();
    database.then((value) {
      value.todoDao.getMaxId().then((val){
        value.todoDao.updateTodo(Todo(
          id: widget.id!,
          title: _textEditingController.text,
          body: _bodyEditingController.text,
          createdAt: widget.todo!.createdAt,
          updatedAt: DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
        ));
      });
    });
    Navigator.pop(context, true);
  }

  void _addAndEdit() {
    if(widget.todo == null || widget.id == null) _addTodoItem();
    if(widget.todo != null && widget.id != null) _saveEdit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Todo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                minLines: 1,
                maxLines: 100,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: TextField(
                controller: _bodyEditingController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                minLines: 1,
                maxLines: 100,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton(
                onPressed: _addAndEdit,
                child: const Text("Save"))
          ],
        ),
      ),
    );
  }
}
