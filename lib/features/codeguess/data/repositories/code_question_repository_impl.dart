import 'package:codeguess/features/codeguess/data/datasources/code_question_remote_data_source.dart';
import 'package:codeguess/features/codeguess/domain/entities/code_question.dart';
import 'package:codeguess/features/codeguess/domain/repositories/code_question_repository.dart';

class CodeQuestionRepositoryImpl implements CodeQuestionRepository {
  final CodeQuestionRemoteDataSource remoteDataSource;
  CodeQuestionRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CodeQuestion>> getCodeQuestions() {
    return remoteDataSource.getCodeQuestions();
  }

  @override
  Future<CodeQuestion> getRandomCodeQuestion(String language) {
    return remoteDataSource.getRandomCodeQuestion(language);
  }
}
