import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:testproject/routes.dart';
import 'package:testproject/screens/profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loginUser(String username, String password) async {
    final url = Uri.parse('http://16.16.96.75:8000/admin/login');

    final body = jsonEncode({
      'username': username,
      'password': password,
    });

    final response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      // Login successful
      final responseData = json.decode(response.body);
      final token = responseData['token'];
      final id = responseData['id'];
      print(id);

      // Navigate to MainScreen and pass username, password, and id
      Navigator.pushReplacementNamed(
        context,
        Routes.MAIN,
        arguments: {
          'username': username,
          'password': password,
          'id': id,
        },
      );
    } else {
      // Login failed
      print('Login failed with status code: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 40, bottom: 20),
                  height: 100,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage('static/images/stressed.jpeg'),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Username',
                            labelText: 'Username',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username is required!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'Password',
                            labelText: 'Password',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required!';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final username = _usernameController.text;
                                final password = _passwordController.text;
                                loginUser(username, password);
                              }
                            },
                            child: const Text('Login'),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Forgot Password",
                                  style: TextStyle(color: Colors.grey),
                                )),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, Routes.SIGNUP);
                                },
                                child: const Text("Sign Up")),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
