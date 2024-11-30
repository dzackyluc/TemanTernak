import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:temanternak/models/user.dart';
import 'package:temanternak/services/storage_service.dart';
import 'package:temanternak/views/pages/main_page.dart';
import 'package:temanternak/views/pages/sign_up_page.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool passwordVisible = false;
  User user = User();
  StorageService storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 241, 244, 249)),
          child: Center(
              child: Column(
            children: <Widget>[
              const SizedBox(
                height: 90,
              ),
              const Image(
                  image: AssetImage('lib/assets/images/logo_small.png')),
              const SizedBox(
                height: 30,
              ),
              const Text('Sign In To Teman Ternak',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins')),
              const SizedBox(height: 28),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text('Email',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Poppins')),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 400,
                        height: 50,
                        child: TextField(
                          onChanged: (value) {
                            user.email = value;
                          },
                          style: const TextStyle(
                              fontSize: 12, fontFamily: 'Poppins'),
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Enter your email'),
                        ),
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text('Password',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Poppins')),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 400,
                      height: 50,
                      child: TextField(
                        onChanged: (value) {
                          user.password = value;
                        },
                        style: const TextStyle(
                            fontSize: 12, fontFamily: 'Poppins'),
                        obscureText: !passwordVisible,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: 'Enter your password'),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Forgot your password? ',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: 'Poppins')),
                        TextButton(
                            onPressed: () {},
                            child: const Text('Reset Password',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                    fontFamily: 'Poppins')))
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  http
                      .post(
                          Uri.parse(
                              'https://api.temanternak.h14.my.id/authentications'),
                          headers: {
                            'Accept': 'application/json',
                            'Content-Type': 'application/json',
                          },
                          body: user.logintoJson())
                      .then((response) {
                    if (response.statusCode == 200) {
                      var res = jsonDecode(response.body);
                      storageService.saveData('token', res['token']);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Failed to login!'),
                          backgroundColor: Colors.red));
                    }
                  });

                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => const MainPage()));
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 150, vertical: 18)),
                child: const Text('Sign In',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins')),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Or sign in with ',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'Poppins')),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        minimumSize: const Size(0, 0)),
                    child: const Icon(Icons.facebook, color: Colors.blue),
                  ),
                  TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          minimumSize: const Size(0, 0)),
                      child: const Icon(Icons.g_mobiledata_rounded,
                          color: Colors.blue)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Don\'t have an account? ',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'Poppins')),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()));
                      },
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          minimumSize: const Size(0, 0)),
                      child: const Text('Sign Up',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              fontFamily: 'Poppins')))
                ],
              )
            ],
          )),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
