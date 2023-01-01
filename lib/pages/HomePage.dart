import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/CustomWidget/TodoCard.dart';
import 'package:todo_list_app/Service/Auth_Service.dart';
import 'package:todo_list_app/pages/About.dart';
import 'package:todo_list_app/pages/AddTodo.dart';
import 'package:todo_list_app/pages/SignInPage.dart';
import 'package:todo_list_app/pages/ViewTodo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  final Stream<QuerySnapshot> _stream =
  FirebaseFirestore.instance.collection("Todo").orderBy("category").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Todo List App",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.logout),
                color: Colors.red,
                onPressed: () async {
                  await authClass.logout();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => SignInPage()), (
                      route) => false);
                  final snackBar = SnackBar(content: Text("logout successful"), backgroundColor: Colors.green);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }),
          ],
          bottom: PreferredSize(
            child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 22,
                  ),
                  child: Text(
                    "My Schedule Today",
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff28FEAF),
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
                icon: InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (builder) => HomePage()), (
                            route) => false);
                  },
                  child: Icon(
                    Icons.home,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => AddTodoPage()));
                  },
                  child: Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff28FEAF),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 32,
                      color: Colors.black,
                    ),
                  ),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => AboutPage()));
                  },
                  child: Icon(
                    Icons.account_box_outlined,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                label: "",
              ),
            ]
        ),
        body: Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: StreamBuilder(
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
                    Color? textColor;
                    Color? bgColor;
                    Map<String, dynamic> document =
                    snapshot.data?.docs[index].data() as Map<String, dynamic>;
                    switch (document["category"]) {
                      case "1. Important & urgent":
                        textColor = Colors.white;
                        bgColor = Colors.red;
                        break;
                      case "2. Important but not urgent":
                        textColor = Colors.black;
                        bgColor = Colors.amber;
                        break;
                      case "3. Urgent but not important":
                        textColor = Colors.white;
                        bgColor = Colors.blue;
                        break;
                      case "4. Not urgent & not important":
                        textColor = Colors.black;
                        bgColor = Color(0xff28FEAF);
                        break;
                      default:
                        textColor = Colors.white;
                        bgColor = Colors.red;
                    }
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) =>
                                ViewTodoPage(
                                  document: document,
                                  id: snapshot.data?.docs[index].id,
                                ),
                          ),
                        );
                      },
                      child: TodoCard(
                        title: document["title"] == null
                            ? "Hey There"
                            : document["title"],
                        category: document["category"],
                        check: document["checklist"],
                        bgColor: bgColor,
                        textColor: textColor,
                        time: document["time"],
                        index: index,
                        onChangeCheckValue: () {
                          document["checklist"] == false ?
                          FirebaseFirestore.instance.collection("Todo").doc(
                              snapshot.data?.docs[index].id).update({
                            "checklist": true
                          })
                          :
                          FirebaseFirestore.instance.collection("Todo").doc(
                              snapshot.data?.docs[index].id).update({
                            "checklist": false
                          });
                        },
                      ),
                    );
                  });
            },
          ),
        )
    );
  }
}