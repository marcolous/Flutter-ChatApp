// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_constructors_in_immutables, use_build_context_synchronously, must_be_immutable, body_might_complete_normally_nullable
import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  TextFormFieldWidget({
    super.key,
    required this.label,
    this.autocorrect,
    this.keyboardType,
    required this.obscureText,
    this.onChange,
  });
  final String label;
  bool? autocorrect;
  bool obscureText;
  TextInputType? keyboardType;
  Function(String)? onChange;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (data) {
        if (data!.isEmpty) {
          return 'required field';
        }
      },
      onChanged: onChange,
      obscureText: obscureText,
      enableSuggestions: false,
      autocorrect: false,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}
