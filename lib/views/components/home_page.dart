import 'package:flutter/material.dart';
import 'package:temanternak/views/components/app_bar_extended.dart';
import 'package:temanternak/views/pages/veterinary_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<AppBarExtendedState> _appBarKey =
      GlobalKey<AppBarExtendedState>();

  final List Dummy = [
    "https://api.temanternak.h14.my.id/user_files/mobile_assets/banner/Banner1.png",
    "https://api.temanternak.h14.my.id/user_files/mobile_assets/banner/Banner2.png"
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _appBarKey.currentState?.refreshProfile();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 175,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            heroTag: "ChatButton",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const VeterinaryPage()),
                              );
                            },
                            backgroundColor: Colors.blue[100],
                            child: const Icon(Icons.chat_outlined),
                          ),
                          const SizedBox(height: 10),
                          const SizedBox(
                            width: 60,
                            height: 20,
                            child: Text(
                              "Chat Dokter Hewan",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 8,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold),
                              maxLines: 2,
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            heroTag: "ConsultationLogButton",
                            onPressed: () {},
                            backgroundColor: Colors.blue[100],
                            child: Icon(Icons.description_outlined),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 60,
                            height: 20,
                            child: Text(
                              "Riwayat Konsultasi",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 8,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold),
                              maxLines: 2,
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            heroTag: "StoreButton",
                            onPressed: () {},
                            backgroundColor: Colors.blue[100],
                            child: const Icon(Icons.people_outline_outlined),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 60,
                            height: 20,
                            child: Text(
                              "Tentang Kami",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 8,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold),
                              maxLines: 2,
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            heroTag: "AllAppsButton",
                            onPressed: () {},
                            backgroundColor: Colors.blue[100],
                            child: Icon(Icons.apps_outlined),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 60,
                            height: 20,
                            child: Text(
                              "Semua Aplikasi",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 8,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold),
                              maxLines: 2,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Promo Menarik dari Kami",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: SizedBox(
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: Dummy.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Container(
                          width: 320,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    Dummy[index]),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Riwayat Konsultasi Terakhir",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: SizedBox(
                  height: 145,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: 3,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Container(
                          width: 310,
                          decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            title: Text("Konsultasi dengan Dokter Hewan"),
                            subtitle: Text("Konsultasi pada 12/12/2021"),
                            trailing: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
