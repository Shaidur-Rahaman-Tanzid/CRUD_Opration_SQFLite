import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData? trailinag;

  final bool obscureText;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.trailinag,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(),
          ),
        ),
        // SizedBox(height: 20),
        // TextField(
        //   controller: controller,
        //   obscureText: obscureText,
        //   decoration: InputDecoration(
        //     labelText: labelText,
        //     border: OutlineInputBorder(),
        //   ),
        // ),
      ],
    );
  }
}
