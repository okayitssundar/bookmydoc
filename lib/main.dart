import 'package:bookdoc/Services/Providers/AuthProvider.dart';
import 'package:bookdoc/Services/Providers/PermsProvider.dart';
import 'package:bookdoc/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:bookdoc/Screen/Wrapper.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => AuthProvider()),
        ChangeNotifierProvider(
            create: (context) => PermsProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        home: Wrapper(),
      ),
    );

  }
}



