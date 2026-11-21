import 'package:codeguess/features/codeguess/domain/entities/code_question.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class CodeQuestionCard extends StatelessWidget {
  final CodeQuestion question;
  const CodeQuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Type the missing code',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.secondaryText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              question.question,
              style: TextStyle(
                color: AppTheme.text,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 30),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10, width: 1.5),
            color: Colors.grey.withValues(alpha: 0.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${question.language} (${question.id})',
                      style: TextStyle(
                        color: AppTheme.secondaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: AppTheme.border.withValues(alpha: 0.2),
                thickness: 1.5,
                height: 24,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Text(
                  '${question.code}\n${question.answer}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
