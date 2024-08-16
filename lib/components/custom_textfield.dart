import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String)? onChanged;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.obscureText = false,
    required this.controller,
    required this.focusNode,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText
                      ? Ionicons.eye_outline
                      : Ionicons.eye_off_outline,
                ),
                onPressed: _togglePasswordVisibility,
              )
            : null,
      ),
      style: TextStyle(
        fontSize: 16,
        letterSpacing: widget.obscureText
            ? 2.0
            : 0.0, // Ajuste o espaçamento dos caracteres apenas para obscureText
      ),
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged!(value); // Chama a função de callback
        }
      },
    );
  }
}
