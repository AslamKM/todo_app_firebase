import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String input = "";
  List todos = [];
  @override
  void initState() {
    super.initState();
  }

  createData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("ToDos").doc(input);
    Map<String, String> data = {
      "todo": input,
    };
    documentReference.set(data).whenComplete(() {
      print("$input created");
    });
  }

  deleteData(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("ToDos").doc(item);
    documentReference.delete().whenComplete(() {
      print("$item deleted");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ToDos",
          textDirection: TextDirection.ltr,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Add ToDo"),
                  content: TextField(
                    onChanged: ((String value) {
                      input = value;
                    }),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        setState(() {
                          todos.add(input);
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text("Add"),
                    )
                  ],
                );
              });
        },
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("ToDoS").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return Dismissible(
                    key: Key(index.toString()),
                    child: ListTile(
                      title: Text(ds["todo"]),
                    ),
                    onDismissed: ((direction) {
                      deleteData(ds["todo"]);
                    }),
                  );
                });
          } else {
            return const Align(
              alignment: FractionalOffset.center,
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
