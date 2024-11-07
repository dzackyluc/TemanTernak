// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:temanternak/views/components/app_bar_extended.dart';
import 'package:temanternak/views/components/home_page.dart';
import 'package:temanternak/views/components/log_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  List page = <Widget>[
    HomePage(),
    HomePage(),
    LogPage(),
    HomePage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: 350,
        height: 90,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 47, 60, 51),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: NavigationBar(
            selectedIndex: selectedIndex,
            backgroundColor: Colors.transparent,
            indicatorColor: Color.fromARGB(255, 68, 87, 74),
            indicatorShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            onDestinationSelected: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
            destinations: [
              NavigationDestination(
                  icon: Icon(Icons.home, color: Colors.white, size: 30),
                  label: 'Home'),
              NavigationDestination(
                icon: Icon(Icons.chat, color: Colors.white, size: 30),
                label: 'Chat',
              ),
              NavigationDestination(
                icon: Icon(Icons.description, color: Colors.white, size: 30),
                label: 'Log Consultation',
              ),
              NavigationDestination(
                icon: Icon(Icons.person, color: Colors.white, size: 30),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 241, 244, 249)),
        child: Column(
          children: <Widget>[AppBarExtended(), page[selectedIndex]],
        ),
      ),
    );
  }
}
