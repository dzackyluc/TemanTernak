import 'package:flutter/material.dart';
import 'package:temanternak/views/components/app_bar_extended.dart';
import 'package:temanternak/views/pages/veterinary_page.dart';
import 'package:temanternak/views/pages/video_call_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<AppBarExtendedState> _appBarKey =
      GlobalKey<AppBarExtendedState>();

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
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VideoCallPage()));
                            },
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
                            child: const Icon(Icons.vaccines_outlined),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 60,
                            height: 20,
                            child: Text(
                              "Toko Obat",
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
                    itemCount: 3,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Container(
                          width: 320,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://d1bpj0tv6vfxyp.cloudfront.net/articles/ca04f801-4384-42f5-b40a-835bf5b0e748_article_image_url.webp"),
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
                  "Pesan Obat Sekarang",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: SizedBox(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://stgaccinwbsdevlrs01.blob.core.windows.net/newcorporatewbsite/blogs/october2023/detail-main-Brucellosis.jpg"),
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.2),
                                      BlendMode.darken),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text("Obat Brucellosis",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white))),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://dinpertanpangan.demakkab.go.id/wp-content/uploads/2022/10/MASTITIS-PENYAKIT-TERNAK-RUMINANSIA-PERAH.jpg"),
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.2),
                                    BlendMode.darken),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Obat Mastitis",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
