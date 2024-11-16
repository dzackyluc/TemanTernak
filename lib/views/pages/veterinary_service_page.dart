// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:midtrans_sdk/midtrans_sdk.dart';
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
  MidtransSDK? _midtrans;
  String? tanggal;

  @override
  void initState() {
    super.initState();
    veterinaryService = getVeterinaryService();
    initSDK();
  }

  void initSDK() async {
    _midtrans = await MidtransSDK.init(
      config: MidtransConfig(
        clientKey: "SB-Mid-client-ITTRLLHvX1zCIHBv",
        merchantBaseUrl: "",
        // colorTheme: ColorTheme(
        //   colorPrimary: Theme.of(context).colorScheme.secondary,
        //   colorPrimaryDark: Theme.of(context).colorScheme.secondary,
        //   colorSecondary: Theme.of(context).colorScheme.secondary,
        // ),
      ),
    );
    _midtrans?.setUIKitCustomSetting(
      skipCustomerDetailsPages: true,
    );
    _midtrans!.setTransactionFinishedCallback((result) {
      print(result.toJson());
    });
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
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return _showDialog();
                                          },
                                        ).then((_) {
                                          setState(() {
                                            tanggal = null;
                                            print(tanggal);
                                          });
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

  Widget _showDialog() {
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
            child: SizedBox(
              height: 410,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        'Dokter Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Veterinary',
                        style: TextStyle(fontSize: 14, fontFamily: "Poppins"),
                      ),
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://media.istockphoto.com/id/1130884625/vector/user-member-vector-icon-for-ui-user-interface-or-profile-face-avatar-app-in-circle-design.jpg?s=612x612&w=0&k=20&c=1ky-gNHiS2iyLsUPQkxAtPBWH1BZt0PKBB1WBtxQJRE="),
                            fit: BoxFit.fill,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Layanan: ',
                          style: TextStyle(fontSize: 12, fontFamily: "Poppins"),
                        ),
                        Text(
                          'Veterinary Checkup',
                          style: TextStyle(fontSize: 12, fontFamily: "Poppins"),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Duration: ',
                          style: TextStyle(fontSize: 12, fontFamily: "Poppins"),
                        ),
                        Text(
                          '30s',
                          style: TextStyle(fontSize: 12, fontFamily: "Poppins"),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'price: ',
                          style: TextStyle(fontSize: 12, fontFamily: "Poppins"),
                        ),
                        Text(
                          '200.000',
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
                        GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime != null) {
                                setStateDialog(() {
                                  final DateTime combinedDateTime = DateTime(
                                      pickedDate.year,
                                      pickedDate.month,
                                      pickedDate.day,
                                      pickedTime.hour,
                                      pickedTime.minute);
                                  tanggal = combinedDateTime.toString();
                                  print(tanggal);
                                });
                              }
                            }
                          },
                          child: Text(
                            tanggal ?? 'Pilih Tanggal',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                fontFamily: "Poppins"),
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[200],
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 8),
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
          ),
        );
      },
    );
  }
}
