import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/CustomWidget/DescriptionTextBox.dart';
import 'package:todo_list_app/CustomWidget/LabelTextBox.dart';
import 'package:todo_list_app/CustomWidget/TitleTextBox.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
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
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                        CupertinoIcons.arrow_left,
                        color: Colors.white,
                        size: 28),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Create",
                        style: TextStyle(
                          fontSize: 33,
                          color: Color(0xff28FEAF),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "New Todo",
                        style: TextStyle(
                          fontSize: 33,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 25),
                      const LabelTextBox(label: "Title"),
                      const SizedBox(height: 12),
                      TitleTextBox(titleController: _titleController),
                      const SizedBox(height: 30),
                      const LabelTextBox(label: "Category"),
                      const SizedBox(height: 12),
                      Wrap(
                        runSpacing: 10,
                        children: [
                          categorySelect("1. Important & urgent", 0xff595A5C),
                          const SizedBox(width: 20),
                          categorySelect("2. Important but not urgent", 0xff595A5C),
                          const SizedBox(width: 20),
                          categorySelect("3. Urgent but not important", 0xff595A5C),
                          const SizedBox(width: 20),
                          categorySelect("4. Not urgent & not important", 0xff595A5C),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const LabelTextBox(label: "Time"),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: Text(
                              time = '${_timeOfDay.hour.toString().padLeft(2, '0')}:${_timeOfDay.minute.toString().padLeft(2, '0')}',
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
                            color: const Color(0xff28FEAF),
                            shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                            child: const Icon(
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
                      const SizedBox(height: 12),
                      const SizedBox(height: 30),
                      const LabelTextBox(label: "Description (Optional)"),
                      const SizedBox(height: 12),
                      DescriptionTextBox(descController: _descController),
                      const SizedBox(height: 50),
                      buttonAddTodo(),
                      const SizedBox(height: 30)
                    ],
                  )
                )
              ],
            )
        )
      )
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
            ? const Color(0xff28FEAF)
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
        labelPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 3.8),
      ),
    );
  }

  Widget buttonAddTodo() {
    return InkWell(
      onTap: () {
        time = '${_timeOfDay.hour.toString().padLeft(2, '0')}:${_timeOfDay.minute.toString().padLeft(2, '0')}';
        FirebaseFirestore.instance.collection("Todo").add({
          "title": _titleController.text,
          "category": category,
          "checklist": checklist,
          "time": time,
          "description": _descController.text,
        });
        Navigator.pop(context);
        const snackBar = SnackBar(content: Text("add new todo successful"), backgroundColor: Colors.green);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xff28FEAF),
        ),
        child: const Center(
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
    TimeOfDay ? picked = await showTimePicker(
        context: context,
        initialTime: _timeOfDay
    );
    if(picked != null){
      setState(() {
        _timeOfDay = picked;
      });
    }
  }
}
