import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:temanternak/services/storage_service.dart';

class VeterinaryServicePage extends StatefulWidget {
  final String veterinaryId;

  const VeterinaryServicePage({super.key, required this.veterinaryId});

  @override
  VeterinaryServicePageState createState() => VeterinaryServicePageState();
}

class VeterinaryServicePageState extends State<VeterinaryServicePage> {
  late Future<Map<String, dynamic>> veterinaryService;
  StorageService storageService = StorageService();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 244, 249),
        title: const Text(
          "Pilihan Service Dokter Hewan",
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
              height: 620,
              child: FutureBuilder<Map<String, dynamic>>(
                future: veterinaryService,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData ||
                      snapshot.data?["data"]["services"].isEmpty) {
                    return const Center(child: Text('Tidak Ada Services'));
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
                                          snapshot.data!["data"]
                                                  ["specializations"][0] ??
                                              "Dokter Spesialis",
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
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.arrow_circle_right_sharp,
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
}
