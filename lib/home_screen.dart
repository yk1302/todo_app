import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/Registration.dart';
import 'package:todo_app/config.dart';
import 'package:todo_app/toast.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  final token;
  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var email = '';
  var id = '';
  List? items;
  @override
  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    print(widget.token);
    email = jwtDecodedToken['email'] ??
        'N/A'; // Provide default value or handle null
    id =
        jwtDecodedToken['_id'] ?? 'N/A'; // Provide default value or handle null
    getTodoList(id);
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool _validateTitle = false;
  bool _validateDescription = false;

  void AddTodoData() async {
    if (titleController.text.isEmpty && descriptionController.text.isEmpty) {
      print("email and password are required");

      setState(() {
        _validateTitle = true;
        _validateDescription = true;
      });
      return; // Return here to avoid further execution
    } else if (titleController.text.toString().isEmpty) {
      print("title is required");
      setState(() {
        _validateTitle = true;
        _validateDescription = false;
      });
      return;
    } else if (descriptionController.text.toString().isEmpty) {
      print("description is required");
      setState(() {
        _validateTitle = false;
        _validateDescription = true;
      });
      return;
    }

    var registerBody = {
      "userId": id,
      "title": titleController.text.toString(),
      "description": descriptionController.text.toString(),
    };
    // 192.168.197.77 ip of laptop
    var response = await http.post(Uri.parse(addTodo),
        headers: {"content-type": "application/json"},
        body: jsonEncode(registerBody));

    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse['message']);
    print(jsonResponse['data']);
    if (jsonResponse['status']) {
      FlutterToast().toast("Data has been added...");
      titleController.clear();
      descriptionController.clear();
      Navigator.pop(context);
      getTodoList(id);
    } else {
      FlutterToast().toast("Error in adding data");
      FlutterToast().toast(jsonResponse['message']);
    }

    setState(() {
      _validateTitle = false;
      _validateDescription = false;
    });
  }

  void getTodoList(userId) async {
    var regBody = {"userId": userId};
    var response = await http.post(Uri.parse(getTodoData),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);
    items = jsonResponse['data'];

    setState(() {});
  }

  void deleteItem(ItemId) async {
    print(ItemId);
    var regBody = {
      "ItemId": ItemId,
    };
    var response = await http.post(Uri.parse(deleteTodoData),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));
    var jsonResponse = jsonDecode(response.body);
    print("Deleted data.....");
    print(jsonResponse);
    if (jsonResponse['status']) {
      getTodoList(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        backgroundColor: Colors.deepPurpleAccent.shade100,
        title: Text("AppBar"),
        actions: [
          InkWell(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrationScreen()));
              },
              child: Icon(
                Icons.logout_outlined,
                color: Colors.white,
              )),
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: Container(
          width: double.infinity,
          child: Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: items == null
                    ? null
                    : ListView.builder(
                        itemCount: items!.length,
                        itemBuilder: (context, int index) {
                          return Slidable(
                            key: const ValueKey(0),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              dismissible: DismissiblePane(onDismissed: () {}),
                              children: [
                                SlidableAction(
                                  backgroundColor: Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                  onPressed: (BuildContext context) {
                                    print('${items![index]['_id']}');
                                    print('${items![index]['title']}');
                                    deleteItem('${items![index]['_id']}');
                                  },
                                ),
                              ],
                            ),
                            child: Card(
                              borderOnForeground: false,
                              child: ListTile(
                                leading: Icon(Icons.task),
                                title: Text('${items![index]['title']}'),
                                subtitle:
                                    Text('${items![index]['description']}'),
                                trailing: Icon(Icons.arrow_back),
                              ),
                            ),
                          );
                        }),
              ),
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayTextInputDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add To-Do"),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Title",
                      errorText: _validateTitle ? 'Title Required.' : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Description",
                      errorText:
                          _validateDescription ? 'Description Required.' : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )),
                ),
                SizedBox(height: 25),
                ElevatedButton(
                    onPressed: () {
                      AddTodoData();
                    },
                    child: Text("ADD"))
              ],
            ),
          );
        });
  }
}
