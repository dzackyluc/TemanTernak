// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class AppBarExtended extends StatefulWidget {
  const AppBarExtended({super.key});

  @override
  AppBarExtendedState createState() => AppBarExtendedState();
}

class AppBarExtendedState extends State<AppBarExtended> {
  // Get the current date
  DateTime now = DateTime.now();

  // List of days of the week
  List<String> daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  // Get the day of the week
  late String dayOfWeek = daysOfWeek[now.weekday - 1];

  // List of months
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  //get the month
  late String month = months[now.month - 1];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 175,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 7,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month),
                      SizedBox(width: 2),
                      Text("$dayOfWeek , ${now.day} $month ${now.year}",
                          style: TextStyle(
                              fontSize: 13,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600))
                    ],
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 12, 12, 0),
                child: Stack(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.notifications, size: 20),
                      ),
                    ),
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.person,
                            color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 280,
                            child: Text("Hello, Hasan Ismail Abdulmalik",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.clip),
                          ),
                          SizedBox(
                            width: 265,
                            height: 30,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Loyalty Points: 500",
                                      style: TextStyle(
                                          fontSize: 14, fontFamily: "Poppins"),
                                    ),
                                    const SizedBox(width: 5),
                                    Icon(Icons.star,
                                        size: 16, color: Colors.yellow[700]),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                LinearProgressIndicator(
                                  value: 0.5,
                                  backgroundColor: Colors.grey[300],
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }
}
