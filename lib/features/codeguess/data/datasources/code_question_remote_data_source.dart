import 'package:codeguess/features/codeguess/data/models/code_question_model.dart';

abstract class CodeQuestionRemoteDataSource {
  Future<List<CodeQuestionModel>> getCodeQuestions();
  Future<CodeQuestionModel> getRandomCodeQuestion(String language);
}
