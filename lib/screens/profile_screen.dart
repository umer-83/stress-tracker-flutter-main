import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../user_id_provider.dart';


class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userIdProvider = Provider.of<UserIdProvider>(context);
    final userId = userIdProvider.userId;

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text('Profile Screen'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getAdminProfile(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final adminProfile = snapshot.data!;

            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Table(
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: const Text('Username'),
                          ),
                          TableCell(
                            child: Text(
                              adminProfile['username'],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: const Text('Email'),
                          ),
                          TableCell(
                            child: Text(
                              adminProfile['email'],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: const Text('Phone Number'),
                          ),
                          TableCell(
                            child: Text(
                              adminProfile['phone'].toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('No data available'),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> getAdminProfile(String? id) async {
    final url = Uri.parse('http://16.16.96.75:8000/admin/profile?_id=$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody;
    } else {
      print('Error: ${response.statusCode}');
      throw Exception('Failed to fetch admin profile');
    }
  }
}
