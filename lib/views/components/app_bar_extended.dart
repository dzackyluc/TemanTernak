import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:temanternak/services/storage_service.dart';
import 'package:http/http.dart' as http;

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

  late Future<Map<String, dynamic>> profile;

  @override
  void initState() {
    super.initState();
    profile = getProfile();
  }

  Future<Map<String, dynamic>> getProfile() async {
    StorageService storageService = StorageService();
    String? token = await storageService.getData("token");
    var url = Uri.parse("https://api.temanternak.h14.my.id/users/my");
    var response = await http.get(url, headers: {
      "Authorization": "Bearer $token",
    });
    return jsonDecode(response.body);
  }

  void refreshProfile() {
    setState(() {
      profile = getProfile();
    });
  }

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
                padding: const EdgeInsets.fromLTRB(12, 25, 0, 0),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month),
                    const SizedBox(width: 2),
                    Text("$dayOfWeek , ${now.day} $month ${now.year}",
                        style: const TextStyle(
                            fontSize: 13,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600))
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
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
                          FutureBuilder(
                              future: profile,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey,
                                    highlightColor: Colors.white,
                                    child: Container(
                                      width: 200,
                                      height: 13,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                  );
                                } else {
                                  var data =
                                      snapshot.data as Map<String, dynamic>?;
                                  return SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    child: Text(
                                        "Hello, ${data!['data']['name']}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  );
                                }
                              }),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 110,
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
