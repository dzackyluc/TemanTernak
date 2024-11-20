import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:shimmer/shimmer.dart';
import 'package:temanternak/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingDetailsPage extends StatefulWidget {
  final String? bookingId;

  const BookingDetailsPage({super.key, this.bookingId});

  @override
  BookingDetailsPageState createState() => BookingDetailsPageState();
}

class BookingDetailsPageState extends State<BookingDetailsPage> {
  late Future<Map<String, dynamic>> booking;
  MidtransSDK? _midtrans;

  @override
  void initState() {
    super.initState();
    initSDK();
    booking = getBooking();
  }

  void initSDK() async {
    _midtrans = await MidtransSDK.init(
      config: MidtransConfig(
        clientKey: "SB-Mid-client-ITTRLLHvX1zCIHBv",
        merchantBaseUrl: "",
        colorTheme: ColorTheme(
          colorPrimary: Colors.blue[700]!,
          colorPrimaryDark: Colors.blue[800]!,
          colorSecondary: Colors.blue[300]!,
        ),
      ),
    );
    _midtrans?.setUIKitCustomSetting(
      skipCustomerDetailsPages: true,
    );
    _midtrans!.setTransactionFinishedCallback((result) {
      print("Transaction Finished: $result");
      Navigator.of(context).pop();
    });
  }

  Future<Map<String, dynamic>> getBooking() async {
    StorageService storageService = StorageService();
    String? token = await storageService.getData("token");
    var url = Uri.parse(
        "https://api.temanternak.h14.my.id/bookings/${widget.bookingId}");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var response = await http.get(url, headers: headers);
    final responseData = jsonDecode(response.body);
    return Map<String, dynamic>.from(responseData['data']);
  }

  String _formatPrice(int price) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder(
                          future: booking,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.blue[100],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            width: 200,
                                            height: 20,
                                            color: Colors.grey[100],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            width: 100,
                                            height: 16,
                                            color: Colors.grey[100],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            width: 100,
                                            height: 16,
                                            color: Colors.grey[100],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.blue[100],
                                    backgroundImage: NetworkImage(
                                      'https://api.temanternak.h14.my.id/${snapshot.data!['service']['veterinarian']['formalPicturePath']}',
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!['service']
                                              ['veterinarian']['nameAndTitle'],
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          (snapshot.data!['service']
                                                          ['veterinarian']
                                                      ['specializations']
                                                  as List<dynamic>)
                                              .join(", "),
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${_formatPrice(snapshot.data!["service"]["price"])} setiap konsultasi',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.blue[700],
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                          }),
                      const SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Detail Rencana Konsultasi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Tanggal',
                                  style: TextStyle(fontFamily: 'Poppins')),
                              FutureBuilder(
                                  future: booking,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 100,
                                          height: 16,
                                          color: Colors.grey[100],
                                        ),
                                      );
                                    } else {
                                      return Text(
                                        DateFormat('dd MMMM yyyy').format(
                                            DateTime.parse(
                                                    snapshot.data!['startTime'])
                                                .toLocal()),
                                        style: const TextStyle(
                                            fontFamily: 'Poppins'),
                                      );
                                    }
                                  })
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Mulai',
                                  style: TextStyle(fontFamily: 'Poppins')),
                              FutureBuilder(
                                  future: booking,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 100,
                                          height: 16,
                                          color: Colors.grey[100],
                                        ),
                                      );
                                    } else {
                                      return Text(
                                        DateFormat('hh:mm a').format(
                                            DateTime.parse(
                                                    snapshot.data!['startTime'])
                                                .toLocal()),
                                        style: const TextStyle(
                                            fontFamily: 'Poppins'),
                                      );
                                    }
                                  }),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Selesai',
                                  style: TextStyle(fontFamily: 'Poppins')),
                              FutureBuilder(
                                  future: booking,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 100,
                                          height: 16,
                                          color: Colors.grey[100],
                                        ),
                                      );
                                    } else {
                                      return Text(
                                        DateFormat('hh:mm a').format(
                                            DateTime.parse(
                                                    snapshot.data!['endTime'])
                                                .toLocal()),
                                        style: const TextStyle(
                                            fontFamily: 'Poppins'),
                                      );
                                    }
                                  }),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Status',
                                  style: TextStyle(fontFamily: 'Poppins')),
                              FutureBuilder(
                                  future: booking,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 100,
                                          height: 16,
                                          color: Colors.grey[100],
                                        ),
                                      );
                                    } else {
                                      return Text(
                                        snapshot.data!['status'],
                                        style: const TextStyle(
                                            fontFamily: 'Poppins'),
                                      );
                                    }
                                  }),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Status Pembayaran',
                                  style: TextStyle(fontFamily: 'Poppins')),
                              FutureBuilder(
                                  future: booking,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 100,
                                          height: 16,
                                          color: Colors.grey[100],
                                        ),
                                      );
                                    } else {
                                      return Text(
                                        snapshot.data!['transaction']['status'],
                                        style: const TextStyle(
                                            fontFamily: 'Poppins'),
                                      );
                                    }
                                  }),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Biaya Konsultasi',
                                  style: TextStyle(fontFamily: 'Poppins')),
                              FutureBuilder(
                                  future: booking,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 100,
                                          height: 16,
                                          color: Colors.grey[100],
                                        ),
                                      );
                                    } else {
                                      return Text(
                                        _formatPrice(snapshot
                                            .data!['transaction']['price']),
                                        style: const TextStyle(
                                            fontFamily: 'Poppins'),
                                      );
                                    }
                                  }),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins'),
                              ),
                              FutureBuilder(
                                  future: booking,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 100,
                                          height: 16,
                                          color: Colors.grey[100],
                                        ),
                                      );
                                    } else {
                                      return Text(
                                        _formatPrice(snapshot
                                            .data!['transaction']['price']),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins'),
                                      );
                                    }
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FutureBuilder(
                future: booking,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 120,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[100],
                        ),
                      ),
                    );
                  } else if (snapshot.data!['status'] == 'CONFIRMED' ||
                      snapshot.data!['status'] == 'CANCELLED') {
                    return ElevatedButton(
                      onPressed: null,
                      child: Text(
                        (snapshot.data!['status'] == 'CANCELLED'
                            ? 'Transaksi Dibatalkan'
                            : 'Transaksi Selesai'),
                        style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Colors.white),
                      ),
                    );
                  } else if (snapshot.data!["status"] == 'FAILED') {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Refund',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Reschedule',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                color: Colors.white),
                          ),
                        )
                      ],
                    );
                  } else {
                    return ElevatedButton(
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Redirecting to payment...'),
                            backgroundColor: Colors.blue[700],
                          ),
                        );
                        await _midtrans?.startPaymentUiFlow(
                            token: snapshot.data!['transaction']
                                ['paymentToken']);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Bayar Sekarang',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Colors.white),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
