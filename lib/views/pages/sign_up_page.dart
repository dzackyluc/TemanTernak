import 'package:flutter/material.dart';
import 'package:temanternak/views/pages/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 241, 244, 249)),
                child: Center(
                  child: Column(children: <Widget>[
                    const SizedBox(
                      height: 50,
                    ),
                    const Image(
                        image: AssetImage('lib/assets/images/logo_small.png')),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text('Sign Up To Teman Ternak',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins')),
                    const SizedBox(height: 28),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: Column(children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text('Username',
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
                            style: const TextStyle(
                                fontSize: 12, fontFamily: 'Poppins'),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person_outline),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                hintText: 'Enter your username',
                                hintStyle: const TextStyle(
                                    fontSize: 12, fontFamily: 'Poppins'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        const SizedBox(height: 5),
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
                            style: const TextStyle(
                                fontSize: 12, fontFamily: 'Poppins'),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_outlined),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                hintText: 'Enter your email',
                                hintStyle: const TextStyle(
                                    fontSize: 12, fontFamily: 'Poppins'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text('Phone Number',
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
                            style: const TextStyle(
                                fontSize: 12, fontFamily: 'Poppins'),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_outlined),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                hintText: 'Enter your phone number',
                                hintStyle: const TextStyle(
                                    fontSize: 12, fontFamily: 'Poppins'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        const SizedBox(height: 5),
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
                            style: const TextStyle(
                                fontSize: 12, fontFamily: 'Poppins'),
                            obscureText: !passwordVisible,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                hintText: 'Enter your password',
                                hintStyle: const TextStyle(
                                    fontSize: 12, fontFamily: 'Poppins'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text('Confirm Password',
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
                            style: const TextStyle(
                                fontSize: 12, fontFamily: 'Poppins'),
                            obscureText: !confirmPasswordVisible,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(confirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      confirmPasswordVisible =
                                          !confirmPasswordVisible;
                                    });
                                  },
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                hintText: 'Confirm your password',
                                hintStyle: const TextStyle(
                                    fontSize: 12, fontFamily: 'Poppins'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: 400,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: const Text('Sign Up',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Poppins')),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text('Already have an account? ',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontFamily: 'Poppins')),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()));
                              },
                              child: const Text('Sign In',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue,
                                      fontFamily: 'Poppins')),
                            )
                          ],
                        )
                      ]),
                    )
                  ]),
                ))));
  }
}
