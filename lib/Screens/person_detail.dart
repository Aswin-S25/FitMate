// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/Components/button.dart';
import 'package:fitmate/Screens/dashboard.dart';
import 'package:fitmate/Screens/home_screen.dart';
import 'package:fitmate/services/api_services.dart';
import 'package:fitmate/services/shared_Preference.dart';
import 'package:fitmate/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalDetails extends StatefulWidget {
  // final String? name;
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // log(widget.name!);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo1.png',
                width: MediaQuery.of(context).size.width / 1.4,
                height: MediaQuery.of(context).size.height / 13,
              ),
              Column(
                children: [
                  Text(
                    "Hello! My name is FitMate, and I'm here to help you with your fitness goals.",
                    style: GoogleFonts.archivo(
                        color: Colors.white, fontSize: 20, letterSpacing: 2),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "To help us provide you with personalized workout recommendations, we need some basic physical information from you. ",
                    style: GoogleFonts.archivo(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 15,
                        letterSpacing: 2),
                  )
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 3.3,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      textField("Height (cm)", false, _heightController),
                      textField("Weight (Kg)", false, _weightController),
                      textField("Age", false, _ageController)
                    ],
                  ),
                ),
              ),
              Text(
                "Thank you for helping us improve your fitness journey!",
                style: GoogleFonts.archivo(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 15,
                    letterSpacing: 2),
              ),
              const SizedBox(height: 20),
              Button(
                  text: "Continue",
                  fun: _detailsToDatabase,
                  formKey: _formKey,
                  route: Dashboard())
            ],
          ),
        ),
      ),
    );
  }

  void _detailsToDatabase() async {
    final String height = _heightController.text;
    final String weight = _weightController.text;
    final String age = _ageController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = prefs.getInt('id')!;

    bool response = await APIServices().AddPersonalData(
      height,
      weight,
      age,
      id
    );

    if (response) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Personal Details Added'),
          backgroundColor: Colors.green,
        ),
      );

      //navigate to Dashboard screen
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error Occured'),
          backgroundColor: Colors.red,
        ),
      );
    }

    //navigate to home screen
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => Dashboard()),
    //     (route) => false);
  }
}
