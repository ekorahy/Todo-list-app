import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_list_app/CustomWidget/AuthTextBox.dart';
import 'package:todo_list_app/Service/Auth_Service.dart';
import 'package:todo_list_app/pages/HomePage.dart';
import 'package:todo_list_app/pages/SignUpPage.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
                      "Sign In",
                      style: TextStyle(
                          fontSize: 35,
                          color: Color(0xff28FEAF),
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 20),
                    buttonLoginWithGoogle("assets/google.svg", "Continue with Google", 25, () {
                      authClass.googleSignIn(context);
                    }),
                    const SizedBox(height: 15),
                    const Text(
                      "Or",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 15),
                    AuthTextBox(label: "Email ...", controller: _emailController, obscureText: false),
                    const SizedBox(height: 15),
                    AuthTextBox(label: "Password ...", controller: _passwordController, obscureText: true),
                    const SizedBox(height: 30),
                    buttonLogin(),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: Color(0xff595A5C),
                              fontSize: 18,
                            )
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => const SignUpPage()), (route) => false);
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              color: Color(0xff28FEAF),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )
                          )
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                )
            )
        )
    );
  }

  Widget buttonLoginWithGoogle(String imagePath, String buttonName, double size, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 60,
          height: 60,
          child: Card(
              color: Colors.black,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    imagePath,
                    height: size,
                    width: size,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    buttonName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ],
              )
          )
      ),
    );
  }

  Widget buttonLogin() {
    return InkWell(
      onTap: () async {
        setState(() {
          circular = true;
        });
        try {
          firebase_auth.UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text
          );
          setState(() {
            circular = false;
          });
          authClass.storeTokenAndData(userCredential);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => const HomePage()), (route) => false);
          const snackBar = SnackBar(content: Text("login successful"), backgroundColor: Colors.green);
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
          color: const Color(0xff28FEAF),
        ),
          child: Center(
              child: circular
                  ?const CircularProgressIndicator()
                  :const Text(
                  "Sign In",
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
