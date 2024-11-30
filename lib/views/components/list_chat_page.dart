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
    return List<Map<String, dynamic>>.from(responseData['data']);
  }

  Future<void> _refreshBookings() async {
    setState(() {
      bookings = getBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshBookings,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: bookings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerLoading();
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.data?.isEmpty ?? true) {
              return _buildEmptyState();
            } else {
              return _buildChatList(snapshot.data!);
            }
          }
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(radius: 25),
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
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Belum Ada Konsultasi',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Silakan Booking Konsultasi Terlebih Dahulu',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(List<Map<String, dynamic>> data) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey[300],
        height: 1,
        indent: 80,
      ),
      itemCount: data.length,
      itemBuilder: (context, index) {
        var booking = data[index];
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              'https://api.temanternak.h14.my.id/${booking['service']['veterinarian']['formalPicturePath']}',
            ),
          ),
          title: Text(
            booking['service']['veterinarian']['nameAndTitle'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            booking['service']['name'],
            style: TextStyle(
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  consultationId: booking['id'],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
