import 'dart:async';

import 'package:codeguess/features/codeguess/domain/entities/record_answer.dart';
import 'package:codeguess/features/codeguess/presentation/notfiers/record_answer_notifier.dart';
import 'package:codeguess/features/codeguess/widget/code_question_card.dart';
import 'package:codeguess/features/codeguess/widget/game_header.dart';
import 'package:codeguess/features/codeguess/widget/outline_button.dart';
import 'package:codeguess/features/codeguess/widget/outline_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/code_question.dart';
import '../providers/code_question_provider.dart';

class GamePage extends ConsumerStatefulWidget {
  final String langauge;
  const GamePage({super.key, required this.langauge});

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  final TextEditingController _answerController = TextEditingController();
  final FocusNode _answerFocusNode = FocusNode();

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  final List<RecordAnswer> _answers = [];

  bool _isAnswered = false;

  String get formattedTime {
    final duration = _stopwatch.elapsed;

    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    final milliseconds = (duration.inMilliseconds % 1000 ~/ 10)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds.$milliseconds';
  }

  String formatMilliseconds(int milliseconds) {
    final minutes = (milliseconds ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((milliseconds ~/ 1000) % 60).toString().padLeft(2, '0');
    final centiseconds = ((milliseconds % 1000) ~/ 10).toString().padLeft(
      2,
      '0',
    );

    return '$minutes:$seconds.$centiseconds';
  }

  void _startStopWatch() {
    if (_stopwatch.isRunning) return;

    _stopwatch.start();

    _timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _pauseStopwatch() {
    _stopwatch.stop();
    _timer?.cancel();

    setState(() {});
  }

  void _resetGame() {
    setState(() {
      _isAnswered = false;
      _answers.clear();
    });

    _stopwatch.reset();
  }

  void _requestAnswerFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _answerFocusNode.requestFocus();
      }
    });
  }

  Future<void> _loadNextQuestion() async {
    final provider = randomCodeQuestionProvider(widget.langauge);

    ref.invalidate(provider);
    _resetGame();

    // Wait until the new question is loaded so the text field exists
    // before we try to focus it.
    try {
      await ref.read(provider.future);
    } catch (_) {
      return; // error UI is shown by .when(error: ...)
    }

    _requestAnswerFocus();
  }

  Future<void> _submitAnswer(CodeQuestion question, String answer) async {
    final elapseTime = _stopwatch.elapsed;
    final codeAnswer = RecordAnswer(
      questionId: question.id,
      language: question.language,
      answer: answer,
      isCorrect: answer == question.answer ? 1 : 0,
      time: elapseTime.inMilliseconds,
    );

    setState(() {
      _answers.add(codeAnswer);
    });

    if (answer == question.answer) {
      setState(() {
        _isAnswered = true;
      });
      _pauseStopwatch();

      _answerController.clear();
      _answerFocusNode.unfocus();

      await ref.read(recordAnswersProvider.notifier).addRecord(codeAnswer);

      return;
    }

    _answerController.clear();
    _requestAnswerFocus();
  }

  @override
  void initState() {
    super.initState();

    _answerFocusNode.addListener(() {
      if (_answerFocusNode.hasFocus) {
        _startStopWatch();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _answerController.dispose();
    _answerFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionAsync = ref.watch(
      randomCodeQuestionProvider(widget.langauge),
    );

    return questionAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Failed to load question',
                  style: TextStyle(color: AppTheme.text, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  '$error',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.secondaryText),
                ),
                const SizedBox(height: 16),
                OutlineButton(
                  text: 'Go Back',
                  onPressed: () => context.go('/'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (question) => _buildGame(question),
    );
  }

  Widget _buildGame(CodeQuestion question) {
    final sortedAnswers = [..._answers]
      ..sort((a, b) => b.time.compareTo(a.time));

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GameHeader(),

              const SizedBox(height: 32),

              // Question
              CodeQuestionCard(question: question),

              const SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  itemCount: _answers.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final answer = sortedAnswers[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            answer.answer,
                            style: TextStyle(
                              color: answer.isCorrect == 1
                                  ? Colors.green
                                  : AppTheme.secondaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            formatMilliseconds(answer.time),
                            style: TextStyle(
                              color: answer.isCorrect == 1
                                  ? Colors.green
                                  : Colors.redAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  formattedTime,
                  style: TextStyle(
                    color: AppTheme.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              const SizedBox(height: 10),
              _isAnswered
                  ? OutlineButton(
                      text: 'One More',
                      onPressed: _loadNextQuestion,
                    )
                  : OutlineTextfield(
                      controller: _answerController,
                      focusNode: _answerFocusNode,
                      hintText: 'Enter your answer',
                      onSubmitted: (answer) => _submitAnswer(question, answer),
                      enabled: !_isAnswered,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
