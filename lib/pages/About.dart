import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
              CupertinoIcons.arrow_left,
              color: Colors.white,
              size: 28),
        ),
      ),
      body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "About Author",
                style: TextStyle(
                  color: Color(0xff28FEAF),
                  fontWeight: FontWeight.bold,
                  fontSize: 34,
                ),
              ),
              SizedBox(height: 12),
              CircleAvatar(
                backgroundImage: AssetImage("assets/profile.png"),
                radius: 90,
              ),
              SizedBox(height: 12),
              Text(
                "Eko Rahayu Widodo",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "19441490045",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          )
      )
    );
  }
}
