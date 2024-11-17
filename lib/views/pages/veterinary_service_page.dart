// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:temanternak/services/storage_service.dart';

class VeterinaryServicePage extends StatefulWidget {
  final String veterinaryId;

  const VeterinaryServicePage({super.key, required this.veterinaryId});

  @override
  VeterinaryServicePageState createState() => VeterinaryServicePageState();
}

class VeterinaryServicePageState extends State<VeterinaryServicePage> {
  late Future<Map<String, dynamic>> veterinaryService;
  late Future<Map<String, dynamic>> veterinaryDate;
  StorageService storageService = StorageService();
  late List<DateTime> timestamps;
  String? selectedDate;
  String? tanggal;

  @override
  void initState() {
    super.initState();
    veterinaryService = getVeterinaryService();
  }

  Future<Map<String, dynamic>> getVeterinaryService() async {
    var url = Uri.parse(
        "https://api.temanternak.h14.my.id/veterinarians/${widget.veterinaryId}");
    var response = await http.get(url);
    print(response.body);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getVeterinaryDate(serviceid) async {
    var url = Uri.parse(
        "https://api.temanternak.h14.my.id/veterinarians/services/$serviceid/startTimes");
    var headers = {
      "Authorization": "Bearer ${await storageService.getData("token")}"
    };
    var response = await http.get(url, headers: headers);
    return jsonDecode(response.body);
  }

  void addBooking(id) async {
    var url = Uri.parse(
        "https://api.temanternak.h14.my.id/veterinarians/${widget.veterinaryId}/services/$id/bookings");
    var headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await storageService.getData("token")}"
    };
    var body = jsonEncode({
      "startTime": selectedDate,
    });
    var response = await http.post(url, headers: headers, body: body);
    print(response.body);
  }

  List<DateTime> parseTimestamps(List<dynamic> timestampStrings) {
    return timestampStrings
        .map((timestamp) => DateTime.parse(timestamp))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 244, 249),
        title: const Text(
          "Pilihan Layanan",
          style: TextStyle(
              fontSize: 20, fontFamily: "Poppins", fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 241, 244, 249)),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 100,
              child: FutureBuilder<Map<String, dynamic>>(
                future: veterinaryService,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData ||
                      snapshot.data?["data"]["services"].isEmpty) {
                    return const Center(child: Text('Tidak Ada Layanan'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!["data"]["services"].length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 2,
                              )
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            "https://api.temanternak.h14.my.id/${snapshot.data!["data"]["formalPicturePath"]}"),
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: 250,
                                        margin: const EdgeInsets.fromLTRB(
                                            10, 0, 0, 0),
                                        child: Text(
                                          "${snapshot.data!["data"]["nameAndTitle"]}",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            10, 0, 0, 0),
                                        child: Text(
                                          (snapshot.data!["data"]
                                                      ["specializations"]
                                                  as List<dynamic>)
                                              .join(", "),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Text(
                                  "${snapshot.data!["data"]["services"][index]["description"]}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w400),
                                  maxLines: 3,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                              const Divider(
                                color: Colors.grey,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Harga: Rp ${snapshot.data!["data"]["services"][index]["price"].toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontFamily: "Poppins"),
                                        ),
                                        Text(
                                          "Durasi: ${snapshot.data!["data"]["services"][index]["duration"]}s",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontFamily: "Poppins"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 10, 10),
                                    child: IconButton(
                                      onPressed: () async {
                                        veterinaryDate = getVeterinaryDate(
                                            snapshot.data!["data"]["services"]
                                                [index]["id"]);
                                        await veterinaryDate.then((data) {
                                          setState(() {
                                            timestamps =
                                                parseTimestamps(data["data"]);
                                          });
                                        });
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return _showDialog(
                                                name: snapshot.data!["data"]
                                                    ["nameAndTitle"],
                                                specializations: (snapshot.data!["data"]
                                                            ["specializations"]
                                                        as List<dynamic>)
                                                    .join(", "),
                                                serviceName: snapshot.data!["data"]
                                                    ["services"][index]["name"],
                                                price: snapshot.data!["data"]["services"]
                                                        [index]["price"]
                                                    .toString()
                                                    .replaceAllMapped(
                                                        RegExp(r'\B(?=(\d{3})+(?!\d))'),
                                                        (match) => '.'),
                                                duration: snapshot.data!["data"]["services"][index]["duration"].toString(),
                                                imageUrl: snapshot.data!["data"]["formalPicturePath"],
                                                serviceId: snapshot.data!["data"]["services"][index]["id"]);
                                          },
                                        ).then((value) {
                                          selectedDate = null;
                                          veterinaryDate = Future.value({});
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.payments,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showDialog(
      {required name,
      required specializations,
      required serviceName,
      required String price,
      required String duration,
      required String imageUrl,
      required String serviceId}) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setStateDialog) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          actionsPadding: EdgeInsets.zero,
          content: Card(
            surfaceTintColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(
                      name,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      specializations,
                      style: TextStyle(fontSize: 11, fontFamily: "Poppins"),
                    ),
                    leading: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://api.temanternak.h14.my.id/$imageUrl"),
                          fit: BoxFit.fill,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Layanan: ',
                        style: TextStyle(fontSize: 12, fontFamily: "Poppins"),
                      ),
                      Text(
                        serviceName,
                        style: TextStyle(fontSize: 12, fontFamily: "Poppins"),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Durasi: ',
                        style: TextStyle(fontSize: 12, fontFamily: "Poppins"),
                      ),
                      Text(
                        "${duration}s",
                        style: TextStyle(fontSize: 12, fontFamily: "Poppins"),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Harga: ',
                        style: TextStyle(fontSize: 12, fontFamily: "Poppins"),
                      ),
                      Text(
                        "Rp $price",
                        style: TextStyle(fontSize: 12, fontFamily: "Poppins"),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Tanggal: ',
                        style: TextStyle(fontSize: 12, fontFamily: "Poppins"),
                      ),
                      SizedBox(
                        width: 105,
                        height: 30,
                        child: DropdownButton<String>(
                          iconSize: 14,
                          value: selectedDate,
                          items: timestamps.map((dynamic timestamp) {
                            DateTime dateTime =
                                DateTime.parse(timestamp.toString());
                            String formattedDate =
                                DateFormat('dd-MM-yyyy HH:mm').format(dateTime);
                            return DropdownMenuItem<String>(
                              value: timestamp.toString(),
                              child: Text(formattedDate,
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 10,
                                  )),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setStateDialog(() {
                              selectedDate = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.pop(context);
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return BookingPendingPage();
                      // }));
                      if (selectedDate != null) {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return BookingPendingPage();
                        // }));
                        addBooking(serviceId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Pemesanan berhasil, silahkan cek status pemesanan di menu "Pemesanan"')),
                        );
                        // Navigator.pop(context);
                      } else {
                        // Show a message or handle the case when the dropdown is not selected
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Silahkan pilih tanggal terlebih dahulu')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[200],
                      padding:
                          EdgeInsets.symmetric(horizontal: 45, vertical: 8),
                    ),
                    child: Text('Pesan Sekarang',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: "Poppins")),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
