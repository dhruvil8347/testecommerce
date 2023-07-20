import 'package:flutter/material.dart';

class AppTextfiled extends StatelessWidget {
   AppTextfiled({Key? key,
     this.controller,
    this.keyboardType,
    this.cursorColor,
    required this.obscureText,
    required this.label,
    this.textColor,
    this.maxLines,
    this.minLines,
    this.validator,



  }) : super(key: key);

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Color? cursorColor;
  final bool obscureText;
  final String label;
  final String? Function(String?)? validator;
  final Color? textColor;
  final int? maxLines;
  final int? minLines;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        validator: validator,
        controller: controller,
        keyboardType: keyboardType,
        cursorColor: cursorColor,
        obscureText: obscureText,
        maxLines: maxLines,
        minLines: maxLines,
        decoration: InputDecoration(
          label: Text(
            label,
            style: TextStyle(
              color: textColor,
            ),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
