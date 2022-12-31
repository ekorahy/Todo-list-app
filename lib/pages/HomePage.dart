import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/CustomWidget/TodoCard.dart';
import 'package:todo_list_app/Service/Auth_Service.dart';
import 'package:todo_list_app/pages/SignUpPage.dart';
import 'package:todo_list_app/pages/AddTodo.dart';
import 'package:todo_list_app/pages/ViewTodo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("Todo").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          "Today's Schedule",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/profile.jpg"),
          ),
          SizedBox(width: 25),
        ],
        bottom: PreferredSize(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: 22,
              ),
              child: Text(
                "Monday 21",
                style: TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.w600,
                  color: Colors.purple,
                ),
              ),
            )
          ),
          preferredSize: Size.fromHeight(35),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32,
              color: Colors.white,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder) => AddTodoPage()));
              },
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        colors: [
                          Colors.indigoAccent,
                          Colors.purple,
                        ]
                    )
                ),
                child: Icon(
                  Icons.add,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              size: 32,
              color: Colors.white,
            ),
            label: "",
          ),
        ]
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
              IconData? iconData;
              Color? iconColor;
              Map<String, dynamic> document =
                snapshot.data?.docs[index].data() as Map<String, dynamic>;
                switch(document["category"]) {
                  case "Work":
                    iconData = Icons.run_circle_outlined;
                    iconColor = Colors.red;
                    break;
                  case "WorkOut":
                    iconData = Icons.alarm;
                    iconColor = Colors.red;
                    break;
                  case "Food":
                    iconData = Icons.local_grocery_store;
                    iconColor = Colors.blue;
                    break;
                  case "Design":
                    iconData = Icons.audiotrack;
                    iconColor = Colors.green;
                    break;
                  default:
                    iconData = Icons.run_circle_outlined;
                    iconColor = Colors.red;
                }
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => ViewTodoPage(
                              document: document,
                            id: snapshot.data?.docs[index].id,
                          ),
                      ),
                  );
                },
                child: TodoCard(
                  title: document["title"] == null ? "Hey There" : document["title"],
                  check: true,
                  iconBgColor: Colors.white,
                  iconColor: iconColor,
                  iconData: iconData,
                  time: "10 AM",
                ),
              );
          });
        },
      )
    );
  }
}


/// for future use
/// IconButton(icon: Icon(Icons.logout), onPressed: () async {
/// await authClass.logout();
/// Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => SignUpPage()), (route) => false);
/// })