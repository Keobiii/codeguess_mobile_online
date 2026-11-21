import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_theme.dart';

class GameHeader extends StatelessWidget {
  const GameHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => context.go('/'),
          child: Icon(Icons.arrow_back_ios, size: 24, color: Colors.white),
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Code',
                style: TextStyle(
                  color: AppTheme.text,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'Guess',
                style: TextStyle(
                  color: AppTheme.secondaryText,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => context.push('/history'),
          child: Icon(Iconsax.ranking_1, size: 30, color: Colors.white),
        ),
      ],
    );
  }
}
