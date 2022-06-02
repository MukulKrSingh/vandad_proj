import 'package:flutter/material.dart';
import 'package:vandad_proj/strings.dart' show enterYourPassword;

class PasswordTextField extends StatelessWidget {
  final TextEditingController emailController;
  const PasswordTextField({
    Key? key,
    required this.emailController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: enterYourPassword,
      ),
    );
  }
}
