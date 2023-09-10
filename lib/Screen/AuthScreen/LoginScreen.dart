import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Services/Firebase/FirebaseAuth.dart';

class LoginScreen extends StatefulWidget {
  final Function(int) pageSwitch;
  const LoginScreen({super.key, required this.pageSwitch});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';
  String? errormsg = '';
  bool _isObscure = true;
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  Future<bool> fetchCanRegister() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> adminSettingsSnapshot =
          await FirebaseFirestore.instance
              .doc('adminSettings/adminSettings')
              .get();

      if (adminSettingsSnapshot.exists) {
        // Access the 'canRegister' field and return its value
        return adminSettingsSnapshot['canLogin'] ?? false;
      } else {
        // Handle the case where the adminSettings document doesn't exist
        return false; // Set a default value or handle as needed
      }
    } catch (e) {
      // Handle any errors that may occur while fetching data
      print('Error fetching adminSettings: $e');
      return false; // Set a default value or handle as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Welcome to BookDoc",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
              Text(
                "Team Appetizers(Proto)",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Image.asset("assets/login.gif"),
              const SizedBox(height: 20),
              Form(
                key: _emailFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        } else if (!RegExp(
                                r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                            .hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null; // Return null if the input is valid.
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      key: _passwordFormKey,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null; // Return null if the input is valid.
                      },
                      obscureText: _isObscure, // Hide or show the password
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        onPressed: () async {
                          _emailFormKey.currentState!.validate();
                          _passwordFormKey.currentState?.validate();
                          final errorMessage = await signIn(email, password);
                          bool isRegEnabled = await fetchCanRegister();
                          if (isRegEnabled) {
                            final errorMessage = await signIn(email, password);
                            setState(() {
                              if (errorMessage != null) {
                                final parts = errorMessage.split(' ');
                                if (parts.isNotEmpty) {
                                  parts.remove(parts.first);
                                  String result = parts.join(" ");
                                  errormsg = result;
                                } else {
                                  errormsg = errorMessage;
                                }
                              } else {
                                errormsg = null; // No error message
                              }
                            });
                          } else {
                            setState(() {
                              errormsg =
                                  "Sorry , Registration is Disabled by Admin";
                            });
                          }
                        },
                        child: const Text('Login'),
                      ),
                    ),
                  ],
                ),
              ),
              if (errormsg != "")
                Text(errormsg!, style: TextStyle(color: Colors.red)),
              TextButton(
                onPressed: () {
                  widget.pageSwitch(1);
                },
                child: const Text('New User ? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
