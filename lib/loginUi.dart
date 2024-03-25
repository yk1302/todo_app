import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app/Registration.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/home_screen.dart';
import 'package:todo_app/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _validateEmail = false;
  bool _validatePassword = false;
  late SharedPreferences prefs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPrefs();
  }

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  //
  void loginUser() async {
    if (emailController.text.isEmpty && passwordController.text.isEmpty) {
      print("email and password are required");

      setState(() {
        _validateEmail = true;
        _validatePassword = true;
      });
      return; // Return here to avoid further execution
    } else if (emailController.text.toString().isEmpty) {
      print("email is required");
      setState(() {
        _validateEmail = true;
        _validatePassword = false;
      });
      return;
    } else if (passwordController.text.toString().isEmpty) {
      print("password is required");
      setState(() {
        _validateEmail = false;
        _validatePassword = true;
      });
      return;
    }

    print("Login user");
    print(emailController.text.toString());
    print(passwordController.text.toString());

    var requestBody = {
      "email": emailController.text.toString(),
      "password": passwordController.text.toString()
    };

    var response = await http.post(
      Uri.parse(login),
      headers: {"content-type": "application/json"},
      body: jsonEncode(requestBody),
    );

    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    print(jsonResponse['message']);
    print(jsonResponse['token']);
    if (jsonResponse['status']) {
      FlutterToast().toast("User has been Logged in...");
      var myToken = jsonResponse['token'];
      prefs.setString("token", myToken);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(token: myToken),
        ),
      );
    } else {
      FlutterToast().toast("Error in logging in user");
      FlutterToast().toast(jsonResponse['message']);
    }

    setState(() {
      _validatePassword = false;
      _validateEmail = false;
    });
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
                loginUser();
              },
              child: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Text(
                  "LogIn",
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
              Text("Don't Have An Account? "),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationScreen()));
                },
                child: Text(
                  "SignUp",
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
