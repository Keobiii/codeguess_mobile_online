import 'package:codeguess/features/codeguess/domain/entities/code_question.dart';
import 'package:codeguess/features/codeguess/domain/repositories/code_question_repository.dart';

class GetRandomCodeQuestion {
  final CodeQuestionRepository repository;
  GetRandomCodeQuestion(this.repository);

  Future<CodeQuestion> call(String language) =>
      repository.getRandomCodeQuestion(language);
}
