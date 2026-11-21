import 'package:flutter/material.dart';

class OutlineTextfield extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final String hintText;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;

  const OutlineTextfield({
    super.key,
    required this.controller,
    this.focusNode,
    this.onSubmitted,
    this.enabled = true,
    this.hintText = '',
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction = TextInputAction.done,
    this.validator,
    this.autofillHints,
  });

  @override
  State<OutlineTextfield> createState() => _OutlineTextfieldState();
}

class _OutlineTextfieldState extends State<OutlineTextfield> {
  bool _obscure = true;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(color: color),
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      onFieldSubmitted: widget.onSubmitted,
      enabled: widget.enabled,
      obscureText: widget.isPassword && _obscure,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      autofillHints: widget.autofillHints,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
        border: _border(Colors.white),
        enabledBorder: _border(Colors.white),
        focusedBorder: _border(Colors.white),
        errorBorder: _border(Colors.redAccent),
        focusedErrorBorder: _border(Colors.redAccent),
      ),
    );
  }
}
