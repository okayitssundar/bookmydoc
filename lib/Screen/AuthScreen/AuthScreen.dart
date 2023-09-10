
import 'package:bookdoc/Screen/AuthScreen/RegisterScreen.dart';
import 'package:bookdoc/Screen/AuthScreen/LoginScreen.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthPage();
}

class _AuthPage extends State<AuthScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      LoginScreen(pageSwitch: _onItemTapped),
      RegisterScreen(pageSwitch: _onItemTapped),
    ];
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
