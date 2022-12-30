import 'package:flutter/material.dart';
import 'package:todo_list_app/CustomWidget/TodoCard.dart';
import 'package:todo_list_app/Service/Auth_Service.dart';
import 'package:todo_list_app/pages/SignUpPage.dart';
import 'package:todo_list_app/pages/AddTodo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();

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
                  color: Colors.white,
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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            children: [
              TodoCard(
                title: "Wake up Bro",
                check: true,
                iconBgColor: Colors.white,
                iconColor: Colors.red,
                iconData: Icons.alarm,
                time: "10 AM",
              ),
              SizedBox(height: 10),
              TodoCard(
                title: "Let's do Gym",
                check: false,
                iconBgColor: Color(0xff2cc8d9),
                iconColor: Colors.white,
                iconData: Icons.run_circle,
                time: "11 AM",
              ),
              SizedBox(height: 10),
              TodoCard(
                title: "Buy Some food",
                check: false,
                iconBgColor: Color(0xfff19733),
                iconColor: Colors.white,
                iconData: Icons.local_grocery_store,
                time: "12 PM",
              ),
              SizedBox(height: 10),
              TodoCard(
                title: "Testing Something",
                check: false,
                iconBgColor: Color(0xffd3c2b9),
                iconColor: Colors.white,
                iconData: Icons.audiotrack,
                time: "10 PM",
              ),
              SizedBox(height: 10),
            ],
          )
        ),
      ),
    );
  }
}


/// for future use
/// IconButton(icon: Icon(Icons.logout), onPressed: () async {
/// await authClass.logout();
/// Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => SignUpPage()), (route) => false);
/// })