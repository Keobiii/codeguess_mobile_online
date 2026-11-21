import 'package:codeguess/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class OutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const OutlineButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.grey.withValues(alpha: 0.2),
          side: const BorderSide(color: Colors.white10, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          text,
          style: TextStyle(color: AppTheme.text, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
