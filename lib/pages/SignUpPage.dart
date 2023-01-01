import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:todo_list_app/Service/Auth_Service.dart';
import 'package:todo_list_app/pages/SignInPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool circular = false;
  AuthClass authClass = AuthClass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 35,
                  color: Color(0xff28FEAF),
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 20),
              textItem("Email ...", _emailController, false),
              SizedBox(height: 15),
              textItem("Password ...", _passwordController, true),
              SizedBox(height: 30),
              colorButton(),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      color: Color(0xff595A5C),
                      fontSize: 18,
                    )
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => SignInPage()), (route) => false);
                    },
                    child: Text(
                        "Login",
                        style: TextStyle(
                          color: Color(0xff28FEAF),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )
                    )
                  )
                ],
              ),
            ],
          )
        )
      )
    );
  }

  Widget textItem(String labelText, TextEditingController controller, bool obscureText) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: 17,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1.5,
              color: Color(0xff28FEAF),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
      )
    );
  }

  Widget colorButton() {
    return InkWell(
      onTap: () async {
        setState(() {
          circular = true;
        });
       try {
         firebase_auth.UserCredential userCredential =
         await firebaseAuth.createUserWithEmailAndPassword(
             email: _emailController.text,
             password: _passwordController.text
         );
         setState(() {
           circular = false;
         });
         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => SignInPage()), (route) => false);
         final snackBar = SnackBar(content: Text("register account successful"), backgroundColor: Colors.green);
         ScaffoldMessenger.of(context).showSnackBar(snackBar);
       } catch(e) {
         final snackBar = SnackBar(content: Text(e.toString()), backgroundColor: Colors.red);
         ScaffoldMessenger.of(context).showSnackBar(snackBar);
         setState(() {
           circular = false;
         });
       }
      },
      child: Container(
          width: MediaQuery.of(context).size.width - 90,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xff28FEAF),
          ),
          child: Center(
              child: circular
                  ?CircularProgressIndicator()
                  :Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )
              )
          )
      ),
    );
  }
}
