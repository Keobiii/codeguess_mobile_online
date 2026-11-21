import 'package:codeguess/features/codeguess/domain/entities/code_question.dart';

class CodeQuestionModel extends CodeQuestion {
  const CodeQuestionModel({
    required super.id,
    required super.question,
    required super.code,
    required super.language,
    required super.answer,
  });

  factory CodeQuestionModel.fromJson(Map<String, dynamic> json) {
    return CodeQuestionModel(
      id: json['id'] as int,
      question: json['question'] as String,
      code: json['code'] as String,
      language: json['language'] as String,
      answer: json['answer'] as String,
    );
  }
}
