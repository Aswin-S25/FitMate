import 'package:firebase_core/firebase_core.dart';
import 'package:fitmate/Screens/activity.dart';
import 'package:fitmate/Screens/dashboard.dart';
import 'package:fitmate/Screens/home_screen.dart';
import 'package:fitmate/Screens/nutrition.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitmate',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
            displayLarge: GoogleFonts.archivo(
                fontSize: 72.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
            titleLarge: GoogleFonts.archivo(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
            bodyMedium: GoogleFonts.archivo(
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          )),
      home: MyNutrition(),
    );
  }
}
