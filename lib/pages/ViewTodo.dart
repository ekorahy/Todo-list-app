import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewTodoPage extends StatefulWidget {
  const ViewTodoPage({Key? key, this.document, this.id}) : super(key: key);

  final Map<String, dynamic>? document;
  final String? id;

  @override
  State<ViewTodoPage> createState() => _ViewTodoPageState();
}

class _ViewTodoPageState extends State<ViewTodoPage> {

  TextEditingController? _titleController;
  TextEditingController? _descController;
  String? category = "";
  TimeOfDay _timeOfDay = TimeOfDay.now();
  String? time;
  bool edit = false;
  bool? checklist;

  @override
  void initState() {
    super.initState();
    String title = widget.document?["title"] == null
    ? "Empty Title"
    : widget.document?["title"];
    String description = widget.document?["description"] == null
    ? "Empty Description"
    : widget.document?["description"];
    _titleController = TextEditingController(text: title);
    _descController = TextEditingController(text: description);
    time = widget.document?["time"];
    category = widget.document?["category"];
    checklist = widget.document?["checklist"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black
            ),
            child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                              CupertinoIcons.arrow_left,
                              color: Colors.white,
                              size: 28),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  setState(() {
                                    FirebaseFirestore.instance.collection("Todo").doc(widget.id).delete().then((value){
                                      Navigator.pop(context);
                                      final snackBar = SnackBar(content: Text("delete todo successful"), backgroundColor: Colors.green);
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    });
                                  });
                                });
                              },
                              icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 28),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  edit = !edit;
                                });
                              },
                              icon: Icon(
                                  Icons.edit,
                                  color: edit
                                      ? Colors.amber
                                      : Colors.white,
                                  size: 28),
                            ),
                          ],
                        )
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  edit
                                      ?"Edit"
                                      :"Detail",
                                  style: TextStyle(
                                    fontSize: 33,
                                    color: edit
                                        ? Colors.amber
                                        : Color(0xff28FEAF),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 4,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      checklist == false
                                          ?"undone"
                                          :"done",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: edit
                                            ? Colors.amber
                                            : Color(0xff28FEAF),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    edit
                                    ? Theme(
                                        child: Transform.scale(
                                          scale: 1.5,
                                          child: Checkbox(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            activeColor: Colors.amber,
                                            checkColor: Colors.black,
                                            value: checklist,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                checklist = value;
                                              });
                                            },
                                          ),
                                        ),
                                        data: ThemeData(
                                          primarySwatch: Colors.blue,
                                          unselectedWidgetColor: Color(0xff5e616a),
                                        )
                                    )
                                    : Container()
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Todo",
                              style: TextStyle(
                                fontSize: 33,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4,
                              ),
                            ),
                            SizedBox(height: 25),
                            label("Task Title"),
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
                                    _timeOfDay == TimeOfDay.now()
                                        ? widget.document!["time"]
                                      : _timeOfDay.hour.toString().padLeft(2, '0') + ':' +
                                        _timeOfDay.minute.toString().padLeft(2, '0'),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: !edit
                                          ? Color(0xff28FEAF)
                                          : Colors.amber,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                edit ? MaterialButton(
                                    height: 50,
                                    minWidth: 50,
                                    color: Colors.amber,
                                    shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                                    child: Icon(
                                      Icons.alarm,
                                      size: 32,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      selectTime();
                                    }
                                )
                                : Container(),
                              ],
                            ),
                            SizedBox(height: 30),
                            label("Description"),
                            SizedBox(height: 12),
                            description(),
                            SizedBox(height: 50),
                            edit ? button() : Container(),
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
        enabled: edit,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: edit
            ? "Enter Title"
            : "",
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
      onTap: edit
        ?() {
        setState(() {
          category = label;
        });
      }
      : null,
      child: Chip(
        backgroundColor: !edit ? category == label
            ? Color(0xff28FEAF)
            : Color(color)
        : category == label
            ? Colors.amber
            : Color(color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text(
          label,
          style: TextStyle(
            color: category == label?Colors.black:Colors.white,
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
        enabled: edit,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: edit
              ? "Enter Description"
              : "",
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
        FirebaseFirestore.instance.collection("Todo").doc(widget.id).update({
          "title": _titleController?.text,
          "checklist": checklist,
          "category": category,
          "time": _timeOfDay.hour.toString().padLeft(2, '0') + ':' +
              _timeOfDay.minute.toString().padLeft(2, '0'),
          "description": _descController?.text,
        });
        Navigator.pop(context);
        final snackBar = SnackBar(content: Text("update todo successful"), backgroundColor: Colors.green);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Container(
          height: 56,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.amber,
          ),
          child: Center(
              child: Text(
                  "Update Todo",
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
