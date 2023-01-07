import 'package:flutter/material.dart';
import 'package:todo_list_app/CustomWidget/AuthTextBox.dart';
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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: 35,
                          color: Color(0xff28FEAF),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    AuthTextBox(
                        label: "Email ...",
                        controller: _emailController,
                        obscureText: false),
                    const SizedBox(height: 15),
                    AuthTextBox(
                        label: "Password ...",
                        controller: _passwordController,
                        obscureText: true),
                    const SizedBox(height: 30),
                    buttonRegister(),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? ",
                            style: TextStyle(
                              color: Color(0xff595A5C),
                              fontSize: 18,
                            )),
                        InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => const SignInPage()),
                                  (route) => false);
                            },
                            child: const Text("Login",
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

  Widget buttonRegister() {
    return InkWell(
      onTap: () async {
        setState(() {
          circular = true;
        });
        try {
          firebase_auth.UserCredential userCredential =
              await firebaseAuth.createUserWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text);
          setState(() {
            circular = false;
          });
          authClass.storeTokenAndData(userCredential);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => const SignInPage()),
              (route) => false);
          const snackBar = SnackBar(
              content: Text("register account successful"),
              backgroundColor: Colors.green);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } catch (e) {
          final snackBar = SnackBar(
              content: Text(e.toString()), backgroundColor: Colors.red);
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
            color: const Color(0xff28FEAF),
          ),
          child: Center(
              child: circular
                  ? const CircularProgressIndicator()
                  : const Text("Sign Up",
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
