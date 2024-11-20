import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:temanternak/services/storage_service.dart';
import 'package:temanternak/views/pages/chat_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListChatPage extends StatefulWidget {
  const ListChatPage({super.key});

  @override
  ListChatPageState createState() => ListChatPageState();
}

class ListChatPageState extends State<ListChatPage> {
  late Future<List<Map<String, dynamic>>> bookings;

  @override
  void initState() {
    super.initState();
    bookings = getBookings();
  }

  Future<List<Map<String, dynamic>>> getBookings() async {
    StorageService storageService = StorageService();
    String? token = await storageService.getData("token");
    var url = Uri.parse(
        "https://api.temanternak.h14.my.id/bookings?only_confirmed=true");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var response = await http.get(url, headers: headers);
    final responseData = jsonDecode(response.body);
    print(responseData);
    return List<Map<String, dynamic>>.from(responseData['data']);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 175,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 560,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: bookings,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Container(
                            width: 150.0,
                            height: 20.0,
                            color: Colors.white,
                          ),
                          subtitle: Container(
                            width: 100.0,
                            height: 20.0,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.data?.isEmpty ?? true) {
                    return Center(
                      child: Text(
                          'Belum Ada Chat Silahkan Booking Terlebih Dahulu'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                                'https://api.temanternak.h14.my.id/${snapshot.data![index]['service']['veterinarian']['formalPicturePath']}'),
                          ),
                          title: Text(snapshot.data![index]['service']
                              ['veterinarian']['nameAndTitle']),
                          subtitle:
                              Text(snapshot.data![index]['service']['name']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                    consultationId: snapshot.data![index]
                                        ['id']),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
