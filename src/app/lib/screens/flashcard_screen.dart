import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import '../models/flashcard.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/meta_chip.dart';
import '../widgets/skeleton_line.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key, required this.onSignedOut});

  final VoidCallback onSignedOut;

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  FlashcardQuestion? _question;
  FlashcardAnswer? _answer;

  @override
  void initState() {
    super.initState();
    _fetchRandomQuestion();
  }

  Future<void> _fetchRandomQuestion() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _answer = null;
    });

    try {
      final response = await Amplify.API.get(
        '/items/random',
        apiName: 'flashcardsApi',
      ).response;
      final body = await response.body.transform(utf8.decoder).join();
      final payload = jsonDecode(body);
      setState(() {
        _question = FlashcardQuestion.fromJson(payload);
      });
    } catch (error) {
      setState(() => _errorMessage = error.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _fetchAnswer() async {
    final question = _question;
    if (question == null) {
      setState(() => _errorMessage = 'Load a question first.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await Amplify.API.get(
        '/items/${question.id}/answer',
        apiName: 'flashcardsApi',
      ).response;
      final body = await response.body.transform(utf8.decoder).join();
      final payload = jsonDecode(body);
      setState(() {
        _answer = FlashcardAnswer.fromJson(payload);
      });
    } catch (error) {
      setState(() => _errorMessage = error.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signOut() async {
    try {
      await Amplify.Auth.signOut();
      widget.onSignedOut();
    } catch (error) {
      setState(() => _errorMessage = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _question;
    final answer = _answer;
    final hasQuestion = question != null;

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
        actions: [
          TextButton(
            onPressed: _signOut,
            child: const Text('Sign out'),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Daily flashcard',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pull a random card, then reveal the answer when ready.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: Card(
                    key: ValueKey(question?.id ?? 'empty'),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (question != null)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                MetaChip(label: question.locale),
                                if (question.career != null)
                                  MetaChip(label: question.career!),
                                if (question.subject != null)
                                  MetaChip(label: question.subject!),
                              ],
                            ),
                          if (question != null) const SizedBox(height: 12),
                          Text(
                            question?.question ??
                                'Press "Random card" to begin.',
                            style:
                                Theme.of(context).textTheme.titleLarge?.copyWith(
                                      height: 1.4,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (answer != null)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: Card(
                      key: ValueKey(answer.id),
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                MetaChip(label: answer.locale),
                                if (answer.career != null)
                                  MetaChip(label: answer.career!),
                                if (answer.subject != null)
                                  MetaChip(label: answer.subject!),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              answer.answer,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton(
                      onPressed: _isLoading ? null : _fetchRandomQuestion,
                      child: Text(hasQuestion ? 'Next card' : 'Random card'),
                    ),
                    OutlinedButton(
                      onPressed:
                          _isLoading || !hasQuestion ? null : _fetchAnswer,
                      child: const Text('Show answer'),
                    ),
                  ],
                ),
                if (_isLoading) ...[
                  const SizedBox(height: 16),
                  const SkeletonLine(widthFactor: 0.7),
                  const SizedBox(height: 8),
                  const SkeletonLine(widthFactor: 0.5),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
