import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  const MyTextField({this.hint, this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          controller: controller,
          decoration: InputDecoration.collapsed(hintText: hint),
          validator: (value) =>
              value!.isEmpty ? "Field can not be empty" : null),
    );
  }
}
