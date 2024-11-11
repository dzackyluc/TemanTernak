import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:temanternak/services/storage_service.dart';
import 'package:temanternak/views/pages/veterinary_service_page.dart';

class VeterinaryPage extends StatefulWidget {
  const VeterinaryPage({super.key});

  @override
  VeterinaryPageState createState() => VeterinaryPageState();
}

class VeterinaryPageState extends State<VeterinaryPage> {
  late Future<List<dynamic>> veterinary;
  StorageService storageService = StorageService();
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    veterinary = getVeterinary();
  }

  Future<List<dynamic>> getVeterinary() async {
    var url = Uri.parse("https://api.temanternak.h14.my.id/veterinarians");
    var response = await http.get(url);
    return jsonDecode(response.body)["data"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 244, 249),
        title: const Text(
          "Pilihan Dokter Hewan",
          style: TextStyle(
              fontSize: 20, fontFamily: "Poppins", fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 241, 244, 249)),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: 350,
                    height: 40,
                    child: Center(
                      child: TextField(
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400),
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by name',
                          hintStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    )),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 100,
                child: FutureBuilder<List<dynamic>>(
                  future: veterinary,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Tidak Ada Dokter'));
                    } else {
                      var filteredList = snapshot.data!.where((vet) {
                        return vet["nameAndTitle"]
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase());
                      }).toList();

                      return ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
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
                                      margin: const EdgeInsets.fromLTRB(
                                          10, 10, 0, 0),
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              "https://api.temanternak.h14.my.id/${filteredList[index]["formalPicturePath"]}"),
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
                                            "${filteredList[index]["nameAndTitle"]}",
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
                                            (filteredList[index]
                                                        ["specializations"]
                                                    as List<dynamic>)
                                                .join(', '),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return VeterinaryServicePage(
                                              veterinaryId: filteredList[index]
                                                  ["id"]);
                                        }));
                                      },
                                      icon: const Icon(
                                        Icons.arrow_circle_right_sharp,
                                        size: 40,
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
      ),
    );
  }
}
