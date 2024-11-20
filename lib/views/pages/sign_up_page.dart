import 'package:flutter/material.dart';
import 'package:temanternak/models/user.dart';
import 'package:temanternak/views/pages/login_page.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  User user = User();

  void signUp() async {
    var url = Uri.parse('https://api.temanternak.h14.my.id/users');
    var response = await http.post(url, body: user.registertoJson());

    if (response.statusCode == 200) {
      Navigator.pop(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sign up failed'),
      ));
    }
  }

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
                          child: const Text('Nama Lengkap',
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
                              user.name = value;
                            },
                            style: const TextStyle(
                                fontSize: 12, fontFamily: 'Poppins'),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person_outline),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                hintText: 'Masukkan nama lengkap Anda',
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
                            onChanged: (value) {
                              user.email = value;
                            },
                            style: const TextStyle(
                                fontSize: 12, fontFamily: 'Poppins'),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_outlined),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                hintText: 'Masukkan email Anda',
                                hintStyle: const TextStyle(
                                    fontSize: 12, fontFamily: 'Poppins'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text('Nomor Telepon',
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
                              user.phone = value;
                            },
                            style: const TextStyle(
                                fontSize: 12, fontFamily: 'Poppins'),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_outlined),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                hintText: 'Masukkan nomor telepon Anda',
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
                            onChanged: (value) {
                              user.password = value;
                            },
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
                                hintText: 'Masukkan password Anda',
                                hintStyle: const TextStyle(
                                    fontSize: 12, fontFamily: 'Poppins'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text('Konfirmasi Password',
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
                              user.password == value;
                            },
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
                                hintText: 'Masukkan konfirmasi password Anda',
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
                            onPressed: () {
                              signUp();
                            },
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
