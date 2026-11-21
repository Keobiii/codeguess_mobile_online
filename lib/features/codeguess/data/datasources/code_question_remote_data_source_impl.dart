import 'package:codeguess/features/codeguess/data/datasources/code_question_remote_data_source.dart';
import 'package:codeguess/features/codeguess/data/models/code_question_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CodeQuestionRemoteDataSourceImpl implements CodeQuestionRemoteDataSource {
  final SupabaseClient client;
  CodeQuestionRemoteDataSourceImpl(this.client);

  @override
  Future<List<CodeQuestionModel>> getCodeQuestions() async {
    final data = await client.from('code_questions').select();
    return data.map((e) => CodeQuestionModel.fromJson(e)).toList();
  }

  @override
  Future<CodeQuestionModel> getRandomCodeQuestion(String language) async {
    var query = client.from('code_questions').select();
    query = query.eq('language', language);

    final data = await query;
    if (data.isEmpty) {
      throw Exception('No questions found');
    }

    data.shuffle();
    return CodeQuestionModel.fromJson(data.first);
  }
}
