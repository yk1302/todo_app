import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app/loginUi.dart';
import "package:http/http.dart" as http;
import "package:todo_app/config.dart";
import 'package:todo_app/toast.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _validateEmail = false;
  bool _validatePassword = false;

  void registerUser() async {
    if (emailController.text.toString().isEmpty) {
      print("email is require");
      setState(() {
        _validateEmail = true;
        _validatePassword = false;
      });
    } else if (passwordController.text.toString().isEmpty) {
      print("password is require");
      if (emailController.text.toString().isEmpty) {
        setState(() {
          _validateEmail = true;
          _validatePassword = false;
        });
      } else {
        setState(() {
          _validateEmail = false;
          _validatePassword = true;
        });
      }
    } else {
      print("Registering user");
      print(emailController.text.toString());
      print(passwordController.text.toString());

      var registerBody = {
        "email": emailController.text.toString(),
        "password": passwordController.text.toString(),
      };
      // 192.168.197.77 ip of laptop
      var response = await http.post(Uri.parse(registration),
          headers: {"content-type": "application/json"},
          body: jsonEncode(registerBody));

      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse['message']);
      print(jsonResponse['data']);
      if (jsonResponse['status']) {
        FlutterToast().toast("User has been created...");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        FlutterToast().toast("Error in creating user");
        FlutterToast().toast(jsonResponse['message']);
      }

      setState(() {
        _validatePassword = false;
        _validateEmail = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 100,
              width: 100,
              child: Image(image: AssetImage('images/logo.png'))),
          SizedBox(height: 20),
          Text("CREATE YOUR ACCOUNT"),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    //label: Text("Enter Email"),
                    labelText: 'Email',
                    errorText: _validateEmail ? 'Email Required.' : null,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.deepPurpleAccent,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide(
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.deepPurpleAccent, width: 2))),
                autofocus: true),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                    //label: Text("Enter Email"),
                    labelText: 'Password',
                    errorText: _validatePassword ? 'Password Required.' : null,
                    prefixIcon: Icon(
                      Icons.password_rounded,
                      color: Colors.deepPurpleAccent,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide(
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 2))),
                autofocus: true),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
              onTap: () {
                registerUser();
              },
              child: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Text(
                  "Register",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already Registered? "),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text(
                  "SignIn",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            ],
          )
        ],
      )),
    );
  }
}
