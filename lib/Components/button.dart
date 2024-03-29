// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Button extends StatefulWidget {
  final String text;
  final Widget? route;
  final GlobalKey<FormState>? formKey;
  final Function? fun;

  const Button({super.key, required this.text,  this.route, this.formKey, this.fun});

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 17,
      child: ElevatedButton(
        
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: () async{
          if(widget.formKey != null) log(widget.formKey!.currentState!.validate().toString());
          if(widget.formKey?.currentState?.validate() ?? true) {

            log(widget.fun.toString());


            await widget.fun?.call();

            if(widget.fun == null) {
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => widget.route ?? Container()));
            }

          }
          
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: GoogleFonts.archivo(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 15),
            const Icon(
              Icons.arrow_forward,
              color: Colors.black,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
