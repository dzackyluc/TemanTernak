import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:temanternak/services/storage_service.dart';
import 'dart:convert';

import 'package:temanternak/views/pages/login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  late Future<Map<String, dynamic>> profile;

  @override
  void initState() {
    super.initState();
    profile = getProfile();
  }

  Future<Map<String, dynamic>> getProfile() async {
    StorageService storageService = StorageService();
    String? token = await storageService.getData("token");
    var url = Uri.parse("https://api.temanternak.h14.my.id/users/my");
    var response = await http.get(url, headers: {
      "Authorization": "Bearer $token",
    });
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 175,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pengaturan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  FutureBuilder<Map<String, dynamic>>(
                    future: profile,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: ListTile(
                            title: Container(
                              width: 100,
                              height: 20,
                              color: Colors.white,
                            ),
                            subtitle: Container(
                              width: 100,
                              height: 20,
                              color: Colors.white,
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        var data = snapshot.data!;
                        return ListTile(
                          title: Text(data['data']['name']),
                          subtitle: Text(data['data']['email']),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Add edit profile logic
                            },
                          ),
                        );
                      } else {
                        return const Text('No data available');
                      }
                    },
                  ),
                  const Divider(height: 10),
                  ListTile(
                    leading: const Icon(Icons.group),
                    title: const Text('Tentang Kami'),
                    subtitle: const Text('Pelajari lebih lanjut tentang kami'),
                    onTap: () {
                      // Add about page navigation
                    },
                  ),
                  const Divider(height: 10),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    subtitle: const Text('Keluar dari akun saat ini'),
                    onTap: () {
                      StorageService storageService = StorageService();
                      storageService.deleteData("token");
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const LoginPage())),
                          (route) => false);
                    },
                  ),
                  const Divider(height: 10),
                  ListTile(
                    leading: const Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Hapus Akun',
                      style: TextStyle(color: Colors.red),
                    ),
                    subtitle: const Text(
                      'Tindakan ini tidak dapat dibatalkan',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Hapus Akun'),
                            content: const Text(
                              'Apakah Anda yakin ingin menghapus akun ini? Tindakan ini tidak dapat dibatalkan.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
