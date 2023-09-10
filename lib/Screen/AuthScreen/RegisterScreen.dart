import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Services/Firebase/FirebaseAuth.dart';

class RegisterScreen extends StatefulWidget {
  final Function(int) pageSwitch;
  const RegisterScreen({super.key, required this.pageSwitch});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String email = '';
  String password = '';
  String username = '';
  List<String> roles = ["Doctor", "Patient"];
  String role = "Patient";
  bool _isObscure = true;
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _userNameFormKey = GlobalKey<FormState>();
  String? errormsg = '';
  Future<bool> fetchCanRegister() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> adminSettingsSnapshot =
          await FirebaseFirestore.instance
              .doc('adminSettings/adminSettings')
              .get();

      if (adminSettingsSnapshot.exists) {
        // Access the 'canRegister' field and return its value
        return adminSettingsSnapshot['canRegister'] ?? false;
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
              Column(
                children: [
                  Form(
                    key: _userNameFormKey,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "User Name",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      onChanged: (val) {
                        setState(() {
                          username = val;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        } else if (value.length > 15) {
                          return 'Enter a valid address';
                        }
                        return null; // Return null if the input is valid.
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButton(
                      value: role,
                      items: roles
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (String? crole) {
                        if (crole != null) {
                          setState(() {
                            role = crole;
                          });
                        }
                      }),
                  Form(
                    key: _emailFormKey,
                    child: TextFormField(
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    child: TextFormField(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () async {
                        _emailFormKey.currentState!.validate();
                        _passwordFormKey.currentState?.validate();
                        _userNameFormKey.currentState?.validate();
                        bool isRegEnabled = await fetchCanRegister();
                        if (isRegEnabled) {
                          final errorMessage =
                              await signUp(email, password, role, username);
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
                      child: const Text('Register'),
                    ),
                  ),
                  if (errormsg != "")
                    Text(errormsg!, style: TextStyle(color: Colors.red)),
                  TextButton(
                    onPressed: () {
                      widget.pageSwitch(0);
                    },
                    child: const Text('Already a User ? Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
