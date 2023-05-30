import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controller/constant.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool error;
  final FocusNode focusNode;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.error,
    required this.focusNode,
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        keyboardType: widget.hintText == 'Phone No.'
            ? TextInputType.number
            : TextInputType.text,
        inputFormatters: widget.hintText == 'Phone No.'
            ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))]
            : null,
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: widget.obscureText && !_passwordVisible,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.focusNode?.hasFocus ?? false
                  ? Colors.red
                  : Colors.grey,
            ),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: greyColor),
          suffixIcon: widget.hintText == 'Password' ||
                  widget.hintText == 'Confirm Password' || widget.hintText == 'New Password' || widget.hintText == 'Current Password'
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: greyColor,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
