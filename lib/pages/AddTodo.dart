import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  String? category = "";
  TimeOfDay _timeOfDay = TimeOfDay.now();
  String? time;
  bool? checklist = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                        CupertinoIcons.arrow_left,
                        color: Colors.white,
                        size: 28),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create",
                        style: TextStyle(
                          fontSize: 33,
                          color: Color(0xff28FEAF),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "New Todo",
                        style: TextStyle(
                          fontSize: 33,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                      SizedBox(height: 25),
                      label("Title"),
                      SizedBox(height: 12),
                      title(),
                      SizedBox(height: 30),
                      label("Category"),
                      SizedBox(height: 12),
                      Wrap(
                        runSpacing: 10,
                        children: [
                          categorySelect("1. Important & urgent", 0xff595A5C),
                          SizedBox(width: 20),
                          categorySelect("2. Important but not urgent", 0xff595A5C),
                          SizedBox(width: 20),
                          categorySelect("3. Urgent but not important", 0xff595A5C),
                          SizedBox(width: 20),
                          categorySelect("4. Not urgent & not important", 0xff595A5C),
                        ],
                      ),
                      SizedBox(height: 30),
                      label("Time"),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            child: Text(
                              time = _timeOfDay.hour.toString().padLeft(2, '0') + ':' +
                                  _timeOfDay.minute.toString().padLeft(2, '0'),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Color(0xff28FEAF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          MaterialButton(
                            height: 50,
                            minWidth: 50,
                            color: Color(0xff28FEAF),
                            shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                            child: Icon(
                              Icons.alarm,
                              size: 32,
                              color: Colors.black,
                            ),
                              onPressed: () {
                                selectTime();
                              }
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      SizedBox(height: 30),
                      label("Description"),
                      SizedBox(height: 12),
                      description(),
                      SizedBox(height: 50),
                      button(),
                      SizedBox(height: 30)
                    ],
                  )
                )
              ],
            )
        )
      )
    );
  }

  Widget title() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _titleController,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter Title",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
        ),
      ),
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 16.5,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget categorySelect(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          category = label;
        });
      },
      child: Chip(
        backgroundColor: category == label
            ? Color(0xff28FEAF)
            : Color(color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text(
          label,
          style: TextStyle(
            color: category == label
                ? Colors.black
                : Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: 17, vertical: 3.8),
      ),
    );
  }

  Widget description() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descController,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter Description",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
        ),
      ),
    );
  }

  Widget button() {
    return InkWell(
      onTap: () {
        time = _timeOfDay.hour.toString().padLeft(2, '0') + ':' +
            _timeOfDay.minute.toString().padLeft(2, '0');
        FirebaseFirestore.instance.collection("Todo").add({
          "title": _titleController.text,
          "category": category,
          "checklist": checklist,
          "time": time,
          "description": _descController.text,
        });
        Navigator.pop(context);
        final snackBar = SnackBar(content: Text("add new todo successful"), backgroundColor: Colors.green);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xff28FEAF),
        ),
        child: Center(
            child: Text(
                "Add Todo",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )
            )
        )
      ),
    );
  }

  Future<void> selectTime() async {
    TimeOfDay ? _picked = await showTimePicker(
        context: context,
        initialTime: _timeOfDay
    );
    if(_picked != null){
      setState(() {
        _timeOfDay = _picked;
      });
    }
  }
}
