import 'package:codeguess/features/codeguess/domain/entities/code_question.dart';
import 'package:codeguess/features/codeguess/domain/repositories/code_question_repository.dart';

class GetCodeQuestions {
  final CodeQuestionRepository repository;

  GetCodeQuestions(this.repository);

  Future<List<CodeQuestion>> call() {
    return repository.getCodeQuestions();
  }
}
