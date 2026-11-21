import '../entities/code_question.dart';

abstract class CodeQuestionRepository {
  Future<List<CodeQuestion>> getCodeQuestions();
  Future<CodeQuestion> getRandomCodeQuestion(String language);
}
