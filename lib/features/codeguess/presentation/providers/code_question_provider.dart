import 'package:codeguess/features/codeguess/data/repositories/code_question_repository_impl.dart';
import 'package:codeguess/features/codeguess/domain/entities/code_question.dart';
import 'package:codeguess/features/codeguess/domain/repositories/code_question_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/providers/supabase_provider.dart';
import '../../data/datasources/code_question_remote_data_source.dart';
import '../../data/datasources/code_question_remote_data_source_impl.dart';
import '../../domain/usecases/get_code_questions.dart';
import '../../domain/usecases/get_random_code_question.dart';

// Supabase Client

// Remote Data Source
final codeQuestionRemoteDataSourceProvider =
    Provider<CodeQuestionRemoteDataSource>((ref) {
      return CodeQuestionRemoteDataSourceImpl(
        ref.watch(supabaseClientProvider),
      );
    });

// Repository
final codeQuestionRepositoryProvider = Provider<CodeQuestionRepository>((ref) {
  return CodeQuestionRepositoryImpl(
    ref.watch(codeQuestionRemoteDataSourceProvider),
  );
});

// Use Cases
final getCodeQuestionsProvider = Provider<GetCodeQuestions>((ref) {
  return GetCodeQuestions(ref.watch(codeQuestionRepositoryProvider));
});

final getRandomCodeQuestionProvider = Provider<GetRandomCodeQuestion>((ref) {
  return GetRandomCodeQuestion(ref.watch(codeQuestionRepositoryProvider));
});

// State
final selectedLanguageProvider = StateProvider<String>((ref) {
  return 'JavaScript';
});

// All questions
final codeQuestionsProvider = FutureProvider<List<CodeQuestion>>((ref) {
  return ref.watch(getCodeQuestionsProvider).call();
});

// Random question for the selected language
final randomCodeQuestionProvider = FutureProvider.autoDispose
    .family<CodeQuestion, String>((ref, language) {
      return ref.watch(getRandomCodeQuestionProvider).call(language);
    });
