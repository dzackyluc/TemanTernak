import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:temanternak/services/storage_service.dart';
import 'package:temanternak/views/pages/booking_details_page.dart';

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  LogPageState createState() => LogPageState();
}

class LogPageState extends State<LogPage> {
  late Future<List<Map<String, dynamic>>> bookings;

  String _formatDateTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr).toLocal();
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      case 'FAILED':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatPrice(int price) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }

  Future<List<Map<String, dynamic>>> getBookings() async {
    StorageService storageService = StorageService();
    String? token = await storageService.getData("token");
    var url = Uri.parse("https://api.temanternak.h14.my.id/bookings");
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
  void initState() {
    super.initState();
    bookings = getBookings();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 175,
      child: RefreshIndicator(
        onRefresh: _refreshBookings,
        child: FutureBuilder(
          future: bookings,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: Colors.grey[100]!,
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                      ),
                      title: Container(
                        width: 100.0,
                        height: 10.0,
                        color: Colors.white,
                      ),
                      subtitle: Container(
                        width: 60.0,
                        height: 20.0,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              );
            } else {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.data?.isEmpty ?? true) {
                return const Center(child: Text('Belum Ada Transaksi'));
              } else {
                return ListView.separated(
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final booking = snapshot.data![index];
                    final service = booking['service'];
                    final veterinarian = service['veterinarian'];
                    final transaction = booking['transaction'];

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          "https://api.temanternak.h14.my.id/${veterinarian['formalPicturePath']}",
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              service['name'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(booking['status']),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              booking['status'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            veterinarian['nameAndTitle'],
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 14),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  _formatDateTime(booking['startTime']),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              if (transaction != null) ...[
                                Text(
                                  _formatPrice(transaction['price']),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BookingDetailsPage(bookingId: booking['id']),
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
    );
  }
}
