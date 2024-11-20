import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
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
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    veterinaryService = getVeterinaryService();
  }

  Future<Map<String, dynamic>> getVeterinaryService() async {
    var url = Uri.parse(
        "https://api.temanternak.h14.my.id/veterinarians/${widget.veterinaryId}");
    var response = await http.get(url);
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
      "startTime": DateTime.parse(selectedDate!).toUtc().toIso8601String(),
    });
    await http
        .post(url, headers: headers, body: body)
        .then((response) => print(response.body));
  }

  List<DateTime> parseTimestamps(List<dynamic> timestampStrings) {
    return timestampStrings
        .map((timestamp) => DateTime.parse(timestamp).toLocal())
        .toSet()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Detail Dokter",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: veterinaryService,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 13,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Icon(Icons.medical_services_outlined,
                            color: Colors.grey[300], size: 20),
                      ),
                      const SizedBox(width: 8),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 16,
                          width: 120,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: 15,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: 13,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 13,
                                      width: 50,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 15,
                                      width: 50,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data?["data"]["services"].isEmpty) {
            return const Center(child: Text('Tidak Ada Layanan'));
          }

          final doctorData = snapshot.data!["data"];

          return Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(
                            "https://api.temanternak.h14.my.id/${doctorData["formalPicturePath"]}",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctorData["nameAndTitle"],
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (doctorData["specializations"] as List<dynamic>)
                                .join(' • '),
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: "Poppins",
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.medical_services_outlined,
                        color: Colors.grey[700], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Layanan Tersedia",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: doctorData["services"].length,
                  itemBuilder: (context, index) {
                    final service = doctorData["services"][index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () async {
                          veterinaryDate = getVeterinaryDate(service["id"]);
                          await veterinaryDate.then((data) {
                            setState(() {
                              timestamps = parseTimestamps(data["data"]);
                            });
                          });
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (context) => _buildBookingSheet(
                              doctorData["nameAndTitle"],
                              doctorData["specializations"].join(", "),
                              service["name"],
                              service["price"],
                              service["duration"],
                              doctorData["formalPicturePath"],
                              service["id"],
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service["name"],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                service["description"],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Poppins",
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.access_time,
                                          size: 16, color: Colors.grey[600]),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${service["duration"]} menit",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: "Poppins",
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    currencyFormatter.format(service["price"]),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBookingSheet(
    String name,
    String specializations,
    String serviceName,
    int price,
    int duration,
    String imageUrl,
    String serviceId,
  ) {
    return StatefulBuilder(
      builder: (context, setStateBuilder) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://api.temanternak.h14.my.id/$imageUrl",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          specializations,
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Poppins",
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildInfoRow("Layanan", serviceName),
              _buildInfoRow("Durasi", "$duration menit"),
              _buildInfoRow("Harga", currencyFormatter.format(price)),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text(
                    "Pilih Jadwal",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: const SizedBox(),
                        value: selectedDate,
                        hint: Text(
                          'Pilih tanggal',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Poppins",
                            color: Colors.grey[600],
                          ),
                        ),
                        items: timestamps.map((timestamp) {
                          String formattedDate = DateFormat('dd MMM yyyy HH:mm')
                              .format(DateTime.parse(timestamp.toString()));
                          return DropdownMenuItem<String>(
                            value: timestamp.toString(),
                            child: Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 13,
                                fontFamily: "Poppins",
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setStateBuilder(() => selectedDate = value),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (selectedDate != null) {
                      addBooking(serviceId);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Pemesanan berhasil, silahkan cek status pemesanan di menu "Pemesanan"',
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Silahkan pilih tanggal terlebih dahulu'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Pesan Sekarang',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontFamily: "Poppins",
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
